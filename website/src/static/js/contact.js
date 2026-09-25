// Formulaire de contact : envoyé à la Cloud Function « contact » (via /api/contact/ sur le même domaine),
// qui valide, archive et transmet le message par e-mail.
import { config } from './firebase-rest.js';

const S = config.strings;
const form = document.getElementById('contact-form');
const status = document.getElementById('c-status');
const send = document.getElementById('c-send');

const show = (ok, msg) => {
  status.className = `form-status ${ok ? 'ok' : 'err'}`;
  status.textContent = msg;
};

form.addEventListener('submit', async (e) => {
  e.preventDefault();
  const d = Object.fromEntries(new FormData(form));
  const email = (d.email || '').trim();
  const valid = form.checkValidity() && /^[^@\s]+@[^@\s]+\.[^@\s]+$/.test(email);
  if (!valid) {
    form.reportValidity();
    show(false, S.invalid);
    return;
  }

  send.disabled = true;
  send.querySelector('span').textContent = S.sending;
  try {
    const res = await fetch('/api/contact/', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({
        name: d.name, email, phone: d.phone, subject: d.subject, message: d.message,
        lang: config.lang, website: d.website,
      }),
    });
    if (!res.ok) throw new Error(`HTTP ${res.status}`);
    form.reset();
    show(true, S.success);
  } catch (err) {
    console.error(err);
    show(false, S.error);
  } finally {
    send.disabled = false;
    send.querySelector('span').textContent = S.send;
  }
});
