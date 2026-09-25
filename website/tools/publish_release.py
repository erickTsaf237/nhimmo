"""Publie une nouvelle version de NHimmo : APK sur Firebase Storage + fiche dans Firestore.

Préparer d'abord les notes de version : website/releases/<version>.json (copier la précédente).

    python website/tools/publish_release.py 1.1.0              # compile, envoie, publie, redéploie le site
    python website/tools/publish_release.py 1.1.0 --draft      # envoie sans rendre la version visible
    python website/tools/publish_release.py 1.1.0 --skip-build # réutilise les APK déjà compilés
    python website/tools/publish_release.py 1.1.0 --no-deploy  # ne redéploie pas le site

Prérequis : Flutter, Google Cloud SDK connecté au compte propriétaire du projet
(`gcloud auth login`), Firebase CLI pour le redéploiement du site.
"""
from __future__ import annotations

import argparse
import datetime as dt
import hashlib
import json
import re
import shutil
import subprocess
import sys
import time
import urllib.request
from pathlib import Path

# Console Windows : sortie en UTF-8 (accents, flèches).
if hasattr(sys.stdout, 'reconfigure'):
    sys.stdout.reconfigure(encoding='utf-8', errors='replace')

WEBSITE = Path(__file__).resolve().parents[1]
APP = WEBSITE.parent
OUT_APK = APP / 'build' / 'app' / 'outputs' / 'flutter-apk'
DIST = WEBSITE / 'dist'
SPLITS = {'arm64': 'app-arm64-v8a-release.apk', 'armv7': 'app-armeabi-v7a-release.apk', 'x86_64': 'app-x86_64-release.apk'}


def run(cmd: list[str], cwd: Path = APP, capture: bool = False) -> str:
    print('  $', ' '.join(cmd))
    exe = shutil.which(cmd[0]) or cmd[0]
    res = subprocess.run([exe, *cmd[1:]], cwd=cwd, text=True, capture_output=capture, shell=False)
    if res.returncode != 0:
        if capture:
            print(res.stdout, res.stderr)
        sys.exit(f'Échec : {" ".join(cmd)}')
    return res.stdout.strip() if capture else ''


def sha256(p: Path) -> str:
    h = hashlib.sha256()
    with p.open('rb') as f:
        for chunk in iter(lambda: f.read(1 << 20), b''):
            h.update(chunk)
    return h.hexdigest()


def encode(v):
    """Valeur Python → valeur Firestore REST."""
    if v is None:
        return {'nullValue': None}
    if isinstance(v, bool):
        return {'booleanValue': v}
    if isinstance(v, int):
        return {'integerValue': str(v)}
    if isinstance(v, float):
        return {'doubleValue': v}
    if isinstance(v, dt.datetime):
        return {'timestampValue': v.astimezone(dt.timezone.utc).isoformat().replace('+00:00', 'Z')}
    if isinstance(v, (list, tuple)):
        return {'arrayValue': {'values': [encode(x) for x in v]}}
    if isinstance(v, dict):
        return {'mapValue': {'fields': {k: encode(x) for k, x in v.items()}}}
    return {'stringValue': str(v)}


def upload(token: str, bucket: str, path: str, file: Path, project: str) -> None:
    """Envoi d'un APK sur Cloud Storage (API JSON, envoi multipart)."""
    meta = json.dumps({
        'name': path,
        'contentType': 'application/vnd.android.package-archive',
        'contentDisposition': f'attachment; filename="{file.name}"',
        'cacheControl': 'public, max-age=31536000, immutable',
    }).encode()
    boundary = 'nhimmo-' + hashlib.md5(path.encode()).hexdigest()
    body = b''.join([
        f'--{boundary}\r\nContent-Type: application/json; charset=UTF-8\r\n\r\n'.encode(), meta,
        f'\r\n--{boundary}\r\nContent-Type: application/vnd.android.package-archive\r\n\r\n'.encode(),
        file.read_bytes(), f'\r\n--{boundary}--\r\n'.encode(),
    ])
    url = f'https://storage.googleapis.com/upload/storage/v1/b/{bucket}/o?uploadType=multipart'
    req = urllib.request.Request(url, body, method='POST', headers={
        'Authorization': f'Bearer {token}', 'Content-Type': f'multipart/related; boundary={boundary}',
        'x-goog-user-project': project})
    for attempt in range(1, 4):
        try:
            urllib.request.urlopen(req, timeout=600).read()
            return
        except Exception as e:  # coupure réseau : on réessaie
            if attempt == 3:
                raise
            print(f'  envoi interrompu ({e}), nouvel essai {attempt + 1}/3…')
            time.sleep(5 * attempt)


def set_pubspec_version(version: str, build: int) -> None:
    p = APP / 'pubspec.yaml'
    s = p.read_text(encoding='utf-8')
    s2 = re.sub(r'^version:.*$', f'version: {version}+{build}', s, count=1, flags=re.M)
    if s2 != s:
        p.write_text(s2, encoding='utf-8')
        print(f'  pubspec.yaml → version {version}+{build}')


def main() -> None:
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument('version')
    ap.add_argument('--notes', type=Path)
    ap.add_argument('--draft', action='store_true', help='envoyer sans publier (published = false)')
    ap.add_argument('--skip-build', action='store_true')
    ap.add_argument('--no-deploy', action='store_true')
    args = ap.parse_args()

    cfg = json.loads((WEBSITE / 'site.config.json').read_text(encoding='utf-8'))
    project, bucket = cfg['projectId'], cfg['storageBucket']
    notes_path = args.notes or WEBSITE / 'releases' / f'{args.version}.json'
    if not notes_path.exists():
        sys.exit(f'Notes de version introuvables : {notes_path}\nCopiez la version précédente et modifiez-la.')
    rel = json.loads(notes_path.read_text(encoding='utf-8'))
    rel['version'] = args.version
    build = int(rel.get('build') or 1)
    print(f'NHimmo {args.version} (build {build}) → projet {project}')

    # 0. Jamais de publication signée avec la clé de débogage : les mises à jour deviendraient impossibles.
    if not (APP / 'android' / 'key.properties').exists():
        sys.exit('android/key.properties introuvable : impossible de signer avec la clé de publication.')

    # 1. Compilation : APK universel puis APK par processeur.
    dist = DIST / args.version
    dist.mkdir(parents=True, exist_ok=True)
    if not args.skip_build:
        set_pubspec_version(args.version, build)
        common = ['--release', f'--build-name={args.version}', f'--build-number={build}']
        run(['flutter', 'build', 'apk', *common])
        shutil.move(OUT_APK / 'app-release.apk', dist / f'nhimmo-{args.version}-universal.apk')
        run(['flutter', 'build', 'apk', '--split-per-abi', *common])
        for variant, name in SPLITS.items():
            shutil.move(OUT_APK / name, dist / f'nhimmo-{args.version}-{variant}.apk')

    # 2. Envoi sur Storage.
    token = run(['gcloud', 'auth', 'print-access-token'], capture=True)
    files = {}
    for variant in ['universal', *SPLITS]:
        apk = dist / f'nhimmo-{args.version}-{variant}.apk'
        if not apk.exists():
            sys.exit(f'APK manquant : {apk}')
        path = f'releases/{args.version}/{apk.name}'
        files[variant] = {'path': path, 'size': apk.stat().st_size, 'sha256': sha256(apk)}
        upload(token, bucket, path, apk, project)
        print(f'  ✓ {variant:9} {files[variant]["size"] / 1048576:6.1f} Mo')

    # 3. Fiche de version dans Firestore (écriture avec les droits du compte gcloud).
    date = dt.datetime.fromisoformat(str(rel.get('date') or dt.date.today().isoformat()))
    doc = {
        'version': args.version, 'build': build, 'date': date, 'published': not args.draft,
        'minAndroid': rel.get('minAndroid', cfg['minAndroid']), 'notes': rel.get('notes', {}), 'files': files,
    }
    url = f'https://firestore.googleapis.com/v1/projects/{project}/databases/(default)/documents/releases/{args.version}'
    req = urllib.request.Request(url, json.dumps({'fields': encode(doc)['mapValue']['fields']}).encode(), method='PATCH',
                                 headers={'Authorization': f'Bearer {token}', 'Content-Type': 'application/json',
                                          'x-goog-user-project': project})
    urllib.request.urlopen(req, timeout=30).read()
    print(f"  ✓ Firestore : releases/{args.version} ({'brouillon' if args.draft else 'publiée'})")

    # 4. Copie locale des notes à jour (secours hors ligne du générateur de site).
    rel.update({'files': files, 'published': not args.draft, 'build': build, 'date': date.date().isoformat()})
    notes_path.write_text(json.dumps(rel, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')

    # 5. Redéploiement du site (pages pré-rendues, sitemap, données structurées).
    if not args.no_deploy and not args.draft:
        run(['firebase', 'deploy', '--only', 'hosting', f'--project={project}'])
    print('Terminé.')


if __name__ == '__main__':
    main()
