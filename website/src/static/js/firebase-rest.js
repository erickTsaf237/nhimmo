// Accès léger à Firestore / Storage par l'API REST publique (aucun SDK à charger).
// Les règles de sécurité n'autorisent que la lecture des versions publiées et la création de messages.

export const config = JSON.parse(document.getElementById('nh-config').textContent);

let ready;
/** Configuration Firebase : celle fournie par Hosting (/__/firebase/init.json), sinon celle du build. */
export function firebaseConfig() {
  ready ??= fetch('/__/firebase/init.json')
    .then((r) => (r.ok ? r.json() : {}))
    .catch(() => ({}))
    .then((init) => ({
      projectId: init.projectId || config.projectId,
      storageBucket: init.storageBucket || config.storageBucket,
      apiKey: init.apiKey || null,
    }));
  return ready;
}

const base = (projectId) => `https://firestore.googleapis.com/v1/projects/${projectId}/databases/(default)/documents`;

/** Valeur Firestore REST → valeur JavaScript. */
export function decode(v) {
  if (!v) return null;
  if ('stringValue' in v) return v.stringValue;
  if ('integerValue' in v) return Number(v.integerValue);
  if ('doubleValue' in v) return v.doubleValue;
  if ('booleanValue' in v) return v.booleanValue;
  if ('timestampValue' in v) return v.timestampValue;
  if ('nullValue' in v) return null;
  if ('arrayValue' in v) return (v.arrayValue.values || []).map(decode);
  if ('mapValue' in v) return decodeFields(v.mapValue.fields || {});
  return null;
}
export const decodeFields = (fields) => Object.fromEntries(Object.entries(fields).map(([k, v]) => [k, decode(v)]));

/** Valeur JavaScript → valeur Firestore REST. */
export function encode(v) {
  if (v === null || v === undefined) return { nullValue: null };
  if (Array.isArray(v)) return { arrayValue: { values: v.map(encode) } };
  if (v instanceof Date) return { timestampValue: v.toISOString() };
  if (typeof v === 'boolean') return { booleanValue: v };
  if (typeof v === 'number') return Number.isInteger(v) ? { integerValue: String(v) } : { doubleValue: v };
  if (typeof v === 'object') return { mapValue: { fields: Object.fromEntries(Object.entries(v).map(([k, x]) => [k, encode(x)])) } };
  return { stringValue: String(v) };
}

/** Versions publiées, de la plus récente à la plus ancienne. */
export async function fetchReleases() {
  const { projectId, apiKey } = await firebaseConfig();
  if (!projectId) throw new Error('projectId manquant');
  const url = `${base(projectId)}:runQuery${apiKey ? `?key=${apiKey}` : ''}`;
  const res = await fetch(url, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({
      structuredQuery: {
        from: [{ collectionId: 'releases' }],
        where: { fieldFilter: { field: { fieldPath: 'published' }, op: 'EQUAL', value: { booleanValue: true } } },
      },
    }),
  });
  if (!res.ok) throw new Error(`Firestore ${res.status}`);
  const rows = await res.json();
  return rows
    .filter((r) => r.document)
    .map((r) => decodeFields(r.document.fields || {}))
    .sort((a, b) => (b.build || 0) - (a.build || 0) || String(b.date).localeCompare(String(a.date)));
}

/** URL publique de téléchargement d'un fichier Storage (lecture autorisée par les règles). */
export async function storageUrl(path) {
  const { storageBucket } = await firebaseConfig();
  return `https://firebasestorage.googleapis.com/v0/b/${storageBucket}/o/${encodeURIComponent(path)}?alt=media`;
}

/** Crée un document (ex. message de contact pour l'extension « Trigger Email »). */
export async function createDoc(collection, data) {
  const { projectId, apiKey } = await firebaseConfig();
  const url = `${base(projectId)}/${collection}${apiKey ? `?key=${apiKey}` : ''}`;
  const res = await fetch(url, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({ fields: encode(data).mapValue.fields }),
  });
  if (!res.ok) throw new Error(`Firestore ${res.status}`);
  return res.json();
}
