// NHimmo — formulaire de contact du site : validation, anti-abus, archivage et envoi par e-mail.
//
// Coût : une fonction HTTP 2e génération en us-central1 (niveau tarifaire le plus bas, quota gratuit
// de 2 millions d'appels / mois), 256 Mo, aucune instance permanente et 2 instances au maximum :
// un afflux de requêtes ne peut pas faire exploser la facture. L'envoi passe par le SMTP de Gmail (gratuit).
import { createHash } from 'node:crypto';

import { initializeApp } from 'firebase-admin/app';
import { FieldValue, getFirestore } from 'firebase-admin/firestore';
import { setGlobalOptions } from 'firebase-functions/v2';
import { onRequest } from 'firebase-functions/v2/https';
import { defineSecret, defineString } from 'firebase-functions/params';
import { logger } from 'firebase-functions';
import nodemailer from 'nodemailer';

setGlobalOptions({ region: 'us-central1', memory: '256MiB', maxInstances: 2, timeoutSeconds: 30 });

initializeApp();
const db = getFirestore();

/** Mot de passe d'application Gmail (Secret Manager) : firebase functions:secrets:set SMTP_PASSWORD */
const SMTP_PASSWORD = defineSecret('SMTP_PASSWORD');
const SMTP_USER = defineString('SMTP_USER', { default: 'ericktsafack2017@gmail.com' });
const CONTACT_TO = defineString('CONTACT_TO', { default: 'ericktsafack2017@gmail.com' });

const MAX_PER_HOUR = 5;
const EMAIL_RE = /^[^@\s]+@[^@\s]+\.[^@\s]+$/;

const clean = (v, max) => String(v ?? '').replace(/\r/g, '').trim().slice(0, max);
const esc = (s) => s.replace(/[&<>"']/g, (c) => ({ '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;', "'": '&#39;' })[c]);

let transport;
const mailer = () =>
  (transport ??= nodemailer.createTransport({
    host: 'smtp.gmail.com',
    port: 465,
    secure: true,
    // Gmail affiche les mots de passe d'application en 4 groupes (« abcd efgh ijkl mnop ») : espaces retirés.
    auth: { user: SMTP_USER.value(), pass: SMTP_PASSWORD.value().replace(/\s+/g, '') },
  }));

/** Au plus MAX_PER_HOUR messages par heure et par adresse IP (IP stockée hachée). */
async function allowed(ipHash) {
  const ref = db.collection('contact_rate').doc(ipHash);
  const hour = Math.floor(Date.now() / 3600000);
  return db.runTransaction(async (tx) => {
    const snap = await tx.get(ref);
    const d = snap.exists ? snap.data() : {};
    const count = d.hour === hour ? d.count : 0;
    if (count >= MAX_PER_HOUR) return false;
    tx.set(ref, { hour, count: count + 1, updatedAt: FieldValue.serverTimestamp() });
    return true;
  });
}

export const contact = onRequest({ secrets: [SMTP_PASSWORD] }, async (req, res) => {
  res.set('Cache-Control', 'no-store');
  if (req.method !== 'POST') {
    res.status(405).json({ ok: false, error: 'method' });
    return;
  }
  const b = typeof req.body === 'object' && req.body ? req.body : {};
  // Champ piège invisible : un robot le remplit, on répond « OK » sans rien faire.
  if (b.website) {
    res.json({ ok: true });
    return;
  }

  const msg = {
    name: clean(b.name, 100),
    email: clean(b.email, 200),
    phone: clean(b.phone, 40),
    subject: clean(b.subject, 120),
    message: clean(b.message, 5000),
    lang: b.lang === 'en' ? 'en' : 'fr',
  };
  if (!msg.name || !EMAIL_RE.test(msg.email) || !msg.subject || msg.message.length < 10) {
    res.status(400).json({ ok: false, error: 'invalid' });
    return;
  }

  const ip = String(req.headers['x-forwarded-for'] || req.ip || '').split(',')[0].trim();
  const ipHash = createHash('sha256').update(`nhimmo:${ip}`).digest('hex').slice(0, 32);
  if (!(await allowed(ipHash))) {
    res.status(429).json({ ok: false, error: 'rate' });
    return;
  }

  // Archivage (collection fermée au public par les règles Firestore).
  const ref = await db.collection('contact_messages').add({
    ...msg,
    ipHash,
    userAgent: clean(req.headers['user-agent'], 300),
    status: 'pending',
    createdAt: FieldValue.serverTimestamp(),
  });

  const lines = [
    `Nom : ${msg.name}`,
    `E-mail : ${msg.email}`,
    msg.phone ? `Téléphone : ${msg.phone}` : null,
    `Sujet : ${msg.subject}`,
    `Langue du site : ${msg.lang}`,
    '',
    msg.message,
  ].filter((l) => l !== null);

  try {
    await mailer().sendMail({
      from: `"NHimmo – site" <${SMTP_USER.value()}>`,
      to: CONTACT_TO.value(),
      replyTo: { name: msg.name, address: msg.email },
      subject: `[NHimmo] ${msg.subject} – ${msg.name}`.slice(0, 200),
      text: lines.join('\n'),
      html: `<div style="font-family:Arial,sans-serif;font-size:14px;color:#0f172a">
        <h2 style="color:#0b1b3d;margin:0 0 12px">Nouveau message depuis le site NHimmo</h2>
        <table cellpadding="4" style="border-collapse:collapse">
          <tr><td style="color:#5b6478">Nom</td><td><b>${esc(msg.name)}</b></td></tr>
          <tr><td style="color:#5b6478">E-mail</td><td><a href="mailto:${esc(msg.email)}">${esc(msg.email)}</a></td></tr>
          ${msg.phone ? `<tr><td style="color:#5b6478">Téléphone</td><td><a href="tel:${esc(msg.phone.replace(/\s/g, ''))}">${esc(msg.phone)}</a></td></tr>` : ''}
          <tr><td style="color:#5b6478">Sujet</td><td>${esc(msg.subject)}</td></tr>
          <tr><td style="color:#5b6478">Langue</td><td>${msg.lang}</td></tr>
        </table>
        <p style="white-space:pre-wrap;border-left:3px solid #e3a93f;padding:8px 12px;background:#f6f8fb">${esc(msg.message)}</p>
        <p style="color:#5b6478;font-size:12px">Répondez directement à ce message pour écrire à ${esc(msg.name)}.</p>
      </div>`,
    });
    await ref.update({ status: 'sent', sentAt: FieldValue.serverTimestamp() });
    res.json({ ok: true });
  } catch (err) {
    logger.error('Envoi du message impossible', err);
    await ref.update({ status: 'error', error: String(err.message || err).slice(0, 500) });
    // Le message est archivé : on ne fait pas perdre sa demande au visiteur.
    res.status(502).json({ ok: false, error: 'mail' });
  }
});
