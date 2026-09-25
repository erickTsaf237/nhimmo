# Site vitrine NHimmo

Site statique bilingue (français à la racine, anglais sous `/en/`), hébergé sur Firebase Hosting.
Les APK sont sur Firebase Storage, les versions et les messages de contact dans Firestore.

```
website/
├── build.py                 génère le site dans website/public
├── site.config.json         URL du site, projet Firebase, coordonnées
├── releases/<version>.json  notes de version (FR/EN) — copie locale de Firestore
├── tools/publish_release.py compile et publie une version
└── src/
    ├── i18n/fr.json, en.json   tous les textes du site
    ├── templates/              pages (Jinja2)
    └── static/                 CSS, JS, captures d'écran brutes
```

Firebase (à la racine du projet Flutter) : `firebase.json`, `.firebaserc`, `firestore.rules`, `storage.rules`.

## Générer et prévisualiser

```bash
python website/build.py                     # génère website/public
firebase serve --only hosting --port 5055   # http://localhost:5055
```

Le déploiement régénère le site automatiquement (`predeploy`) :

```bash
firebase deploy --only hosting
```

Prérequis Python : `pip install jinja2 pillow qrcode`.

## Publier une nouvelle version

1. Copier `website/releases/1.0.0.json` en `website/releases/1.1.0.json`, incrémenter `build`,
   mettre la date et rédiger les nouveautés (`added`), améliorations (`improved`) et corrections (`fixed`) en français et en anglais.
2. Lancer :

```bash
python website/tools/publish_release.py 1.1.0
```

Le script met à jour la version dans `pubspec.yaml`, compile l'APK universel et les 3 APK par processeur,
les envoie sur Storage (`releases/1.1.0/…`), crée la fiche `releases/1.1.0` dans Firestore et redéploie le site.
Options : `--draft` (envoyer sans publier), `--skip-build`, `--no-deploy`.

### Ajouter ou modifier une version à la main (console Firebase)

Firestore → collection `releases` → document nommé comme la version (`1.1.0`) :

| Champ | Type | Exemple |
|---|---|---|
| `version` | string | `1.1.0` |
| `build` | number | `2` (ordre d'affichage : le plus grand en premier) |
| `date` | timestamp | 1 octobre 2026 |
| `published` | boolean | `true` (sinon invisible sur le site) |
| `minAndroid` | string | `7.0` |
| `notes` | map | `fr` et `en`, chacun une map : `summary` (string), `added`, `improved`, `fixed` (arrays de strings) |
| `files` | map | `universal`, `arm64`, `armv7`, `x86_64`, chacun une map : `path` (string, chemin dans Storage), `size` (number, octets), `sha256` (string) |

Déposer les APK dans Storage sous `releases/<version>/`. Le site affiche la nouvelle version immédiatement ;
un redéploiement (`firebase deploy --only hosting`) met aussi à jour les pages pré-rendues pour les moteurs de recherche.

## Formulaire de contact (Cloud Function)

Le formulaire envoie le message à la fonction `contact` (`functions/index.js`), appelée par `/api/contact/`
sur le domaine du site. Elle valide les champs, limite à 5 messages par heure et par IP, archive le message
dans Firestore (`contact_messages`, fermé au public) puis l'envoie par e-mail via Gmail.

Coût : fonction HTTP en `us-central1`, 256 Mo, 0 instance permanente, 2 instances maximum : l'usage reste dans
le quota gratuit (2 millions d'appels par mois). Les anciennes images de déploiement sont supprimées au bout d'un jour.

**Mot de passe Gmail (une seule fois)** : activer la validation en deux étapes sur le compte Google, créer un
mot de passe d'application (Compte Google → Sécurité → Mots de passe des applications), puis :

```bash
firebase functions:secrets:set SMTP_PASSWORD      # coller le mot de passe d'application (16 lettres)
firebase deploy --only functions                  # la fonction utilise la nouvelle valeur
```

Les adresses d'expédition et de réception sont dans `functions/.env` (`SMTP_USER`, `CONTACT_TO`).

> Avec Node 22.9, Firebase CLI 15.31 exige `NODE_OPTIONS=--experimental-require-module` devant chaque commande
> `firebase` (ou installer Node ≥ 22.12 pour s'en passer).

## Référencement

- Titres, descriptions, `canonical`, `hreflang` FR/EN, Open Graph et cartes X/Twitter sur chaque page
  (images d'aperçu 1200×630 générées automatiquement dans `assets/og/`).
- Données structurées : `SoftwareApplication`, `WebSite`, `FAQPage`, `BreadcrumbList`, `ContactPage`, `Person`.
- `sitemap.xml` avec alternatives de langue, `robots.txt`, manifeste web.
- Nom de domaine personnalisé : modifier `siteUrl` dans `site.config.json`, puis redéployer.
- Après la mise en ligne : déclarer le site dans Google Search Console et soumettre `sitemap.xml`.

## Choix automatique du fichier à télécharger

Sur Android, le navigateur indique si possible le type de processeur (Client Hints, `navigator.platform`) :
ARM 64 bits → APK `arm64` (~30 Mo), ARM 32 bits → `armv7`, x86 64 bits → `x86_64`. Dans le doute, l'APK universel
(compatible avec tous les appareils) est proposé. Les variantes et leurs conditions d'installation sont regroupées
dans une section repliée en bas de la page de téléchargement.
