// Pages « Télécharger » et « Versions » : données en direct depuis Firestore,
// détection du téléphone pour proposer le fichier le plus léger compatible.
import { config, fetchReleases, storageUrl } from './firebase-rest.js';

const S = config.strings;
const VARIANTS = ['universal', 'arm64', 'armv7', 'x86_64'];
const $ = (id) => document.getElementById(id);
const esc = (s) => String(s ?? '').replace(/[&<>"']/g, (c) => ({ '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;', "'": '&#39;' })[c]);

const fmtSize = (bytes) =>
  `${new Intl.NumberFormat(config.lang, { maximumFractionDigits: 1 }).format(bytes / 1048576)} ${S.mb}`;
const fmtDate = (d) =>
  d ? new Intl.DateTimeFormat(config.lang, { day: 'numeric', month: 'long', year: 'numeric' }).format(new Date(d)) : '';
const notesOf = (rel) => {
  const n = (rel.notes && (rel.notes[config.lang] || rel.notes.fr)) || {};
  return { summary: n.summary || '', added: n.added || [], improved: n.improved || [], fixed: n.fixed || [] };
};

/**
 * Type de téléphone. Les navigateurs Android récents indiquent l'architecture via les
 * « Client Hints » ; sinon on s'appuie sur navigator.platform. Dans le doute : universelle.
 */
async function detectDevice() {
  const ua = navigator.userAgent || '';
  if (/iPhone|iPad|iPod/i.test(ua) || (navigator.platform === 'MacIntel' && navigator.maxTouchPoints > 1)) return { os: 'ios' };
  if (!/Android/i.test(ua)) return { os: 'desktop' };
  let arch = '';
  let bitness = '';
  try {
    if (navigator.userAgentData?.getHighEntropyValues) {
      const v = await navigator.userAgentData.getHighEntropyValues(['architecture', 'bitness']);
      arch = (v.architecture || '').toLowerCase();
      bitness = v.bitness || '';
    }
  } catch { /* information indisponible */ }
  const platform = (navigator.platform || '').toLowerCase();
  if ((arch === 'arm' && bitness === '64') || /aarch64|arm64/.test(platform) || /aarch64|arm64/i.test(ua)) return { os: 'android', variant: 'arm64' };
  if ((arch === 'x86' && bitness === '64') || /x86_64|x64/.test(platform)) return { os: 'android', variant: 'x86_64' };
  // armv7l = processeur 32 bits. (armv8l = processeur 64 bits avec navigateur 32 bits : incertain.)
  if (/armv7l/.test(platform)) return { os: 'android', variant: 'armv7' };
  return { os: 'android', variant: 'universal' };
}

async function renderDownload(releases) {
  const device = await detectDevice();
  if (device.os === 'ios') $('dl-ios').classList.remove('hidden');
  if (device.os === 'desktop') $('dl-desktop').classList.remove('hidden');

  const latest = releases[0];
  if (!latest || !latest.files) {
    if ($('dl-btn').getAttribute('href') === '#') $('dl-error').classList.remove('hidden');
    return;
  }
  const files = latest.files;
  const variant = device.variant && files[device.variant] ? device.variant : 'universal';
  const file = files[variant] || files.universal;
  if (!file) {
    $('dl-error').classList.remove('hidden');
    return;
  }

  const btn = $('dl-btn');
  btn.href = await storageUrl(file.path);
  btn.setAttribute('download', file.path.split('/').pop());
  $('dl-size').textContent = `(${fmtSize(file.size)})`;
  $('dl-hint').querySelector('span').textContent = variant === 'universal' ? S.recommended_universal : S.recommended_optimized;
  $('dl-meta').innerHTML = `${esc(S.version)} <strong>${esc(latest.version)}</strong> · ${esc(fmtDate(latest.date))} · ${esc(S.android_only)}`;

  const notes = notesOf(latest);
  const items = [...notes.added, ...notes.improved, ...notes.fixed].slice(0, 6);
  const box = $('dl-notes');
  const link = box.querySelector('p.mt');
  box.innerHTML = `<h2 style="font-size:1.25rem">${esc(S.whats_new)}</h2>${notes.summary ? `<p class="muted">${esc(notes.summary)}</p>` : ''}<ul>${items.map((i) => `<li>${esc(i)}</li>`).join('')}</ul>`;
  if (link) box.appendChild(link);

  // Tableau des variantes (section repliée, pour les utilisateurs avertis).
  for (const key of VARIANTS) {
    const row = document.querySelector(`tr[data-variant="${key}"]`);
    if (!row) continue;
    const f = files[key];
    row.classList.toggle('hidden', !f);
    if (!f) continue;
    row.querySelector('.size').textContent = fmtSize(f.size);
    const a = row.querySelector('a');
    a.href = await storageUrl(f.path);
    a.setAttribute('download', f.path.split('/').pop());
    row.querySelector('.rec').classList.toggle('hidden', key !== variant);
    const req = row.children[2];
    const code = req.querySelector('code');
    if (f.sha256) {
      if (code) code.textContent = `SHA-256 : ${f.sha256}`;
      else req.insertAdjacentHTML('beforeend', `<br><code>SHA-256 : ${esc(f.sha256)}</code>`);
    }
  }
}

async function renderVersions(releases) {
  const box = $('releases');
  if (!releases.length) {
    box.innerHTML = `<p class="center muted">${esc(S.empty)}</p>`;
    return;
  }
  const cards = await Promise.all(releases.map(async (rel, i) => {
    const n = notesOf(rel);
    const sections = ['added', 'improved', 'fixed']
      .filter((k) => n[k].length)
      .map((k) => `<h3 class="${k}">${esc(S[k])}</h3><ul>${n[k].map((x) => `<li>${esc(x)}</li>`).join('')}</ul>`)
      .join('');
    const links = await Promise.all(VARIANTS.filter((k) => rel.files?.[k]).map(async (k) =>
      `<a class="btn btn-navy btn-small" href="${esc(await storageUrl(rel.files[k].path))}" download>${esc(S.variants[k])} · ${esc(fmtSize(rel.files[k].size))}</a>`));
    return `<article class="card release" id="v${esc(rel.version)}">
      <header><h2>${esc(S.version)} ${esc(rel.version)}</h2>${i === 0 ? `<span class="tag">${esc(S.latest)}</span>` : ''}
      <time datetime="${esc(rel.date)}">${esc(S.released)} ${esc(fmtDate(rel.date))}</time></header>
      ${n.summary ? `<p class="summary">${esc(n.summary)}</p>` : ''}${sections}
      ${links.length ? `<details><summary>${esc(S.files)} · ${esc(S.min_android)} ${esc(rel.minAndroid || '7.0')}</summary><div class="files">${links.join('')}</div></details>` : ''}
    </article>`;
  }));
  box.innerHTML = cards.join('');
  if (location.hash) document.querySelector(location.hash)?.scrollIntoView();
}

(async () => {
  let releases = null;
  try {
    releases = await fetchReleases();
  } catch (e) {
    console.warn('Versions indisponibles, contenu pré-rendu conservé.', e);
  }
  if ($('dl')) await renderDownload(releases || []);
  if ($('releases') && releases) await renderVersions(releases);
})();
