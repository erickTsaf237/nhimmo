"""Génère le site vitrine NHimmo (FR + EN) dans website/public.

    python build.py            # génération complète
    python build.py --offline  # sans interroger Firestore (versions lues dans releases/*.json)

Les versions sont lues en priorité dans Firestore (collection « releases », lecture publique),
puis dans releases/*.json. Elles sont pré-rendues dans le HTML (référencement) et rafraîchies
en direct par le navigateur.
"""
from __future__ import annotations

import argparse
import datetime as dt
import hashlib
import io
import json
import shutil
import sys
import textwrap
import urllib.request
from pathlib import Path

# Console Windows : sortie en UTF-8 (accents, flèches).
if hasattr(sys.stdout, 'reconfigure'):
    sys.stdout.reconfigure(encoding='utf-8', errors='replace')

import qrcode
from jinja2 import Environment, FileSystemLoader, select_autoescape
from PIL import Image, ImageDraw, ImageFilter, ImageFont

ROOT = Path(__file__).resolve().parent
SRC = ROOT / 'src'
OUT = ROOT / 'public'
APP = ROOT.parent
LANGS = ['fr', 'en']

ROUTES = {
    'home': {'fr': '/', 'en': '/en/'},
    'download': {'fr': '/telecharger/', 'en': '/en/download/'},
    'versions': {'fr': '/versions/', 'en': '/en/releases/'},
    'contact': {'fr': '/contact/', 'en': '/en/contact/'},
    'privacy': {'fr': '/confidentialite/', 'en': '/en/privacy/'},
}
SCREENS = {
    'dashboard': '01-dashboard', 'rentals': '02-rentals', 'contract': '03-contract',
    'readings': '04-readings', 'reading_sheet': '05-reading-sheet', 'invoices': '06-invoices',
    'invoice': '07-invoice', 'pdf': '08-pdf', 'properties': '09-properties',
}
VARIANTS = ['universal', 'arm64', 'armv7', 'x86_64']
MONTHS = {
    'fr': ['janvier', 'février', 'mars', 'avril', 'mai', 'juin', 'juillet', 'août', 'septembre', 'octobre', 'novembre', 'décembre'],
    'en': ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'],
}
NAVY = (11, 27, 61)
GOLD = (227, 169, 63)


# ------------------------------------------------------------------ utilitaires

def log(msg: str) -> None:
    print(f'  {msg}')


def load_json(p: Path):
    return json.loads(p.read_text(encoding='utf-8'))


def date_display(iso: str, lang: str) -> str:
    d = dt.date.fromisoformat(iso[:10])
    return f'{d.day} {MONTHS[lang][d.month - 1]} {d.year}' if lang == 'fr' else f'{MONTHS[lang][d.month - 1]} {d.day}, {d.year}'


def size_display(size: int, lang: str) -> str:
    mb = f'{size / 1048576:.1f}'
    return f"{mb.replace('.', ',')} Mo" if lang == 'fr' else f'{mb} MB'


def font(bold: bool, size: int) -> ImageFont.FreeTypeFont:
    name = 'Roboto-Bold.ttf' if bold else 'Roboto-Regular.ttf'
    return ImageFont.truetype(str(APP / 'assets' / 'fonts' / name), size)


# ------------------------------------------------------------------ configuration

def load_config() -> dict:
    cfg = load_json(ROOT / 'site.config.json')
    rc = ROOT / '.firebaserc'
    if not cfg.get('projectId') and rc.exists():
        cfg['projectId'] = load_json(rc).get('projects', {}).get('default', '')
    if cfg.get('projectId') and not cfg.get('storageBucket'):
        cfg['storageBucket'] = f"{cfg['projectId']}.firebasestorage.app"
    if cfg.get('projectId') and cfg['siteUrl'].endswith('nhimmo.web.app') and cfg['projectId'] != 'nhimmo':
        cfg['siteUrl'] = f"https://{cfg['projectId']}.web.app"
    cfg['siteUrl'] = cfg['siteUrl'].rstrip('/')
    return cfg


# ------------------------------------------------------------------ versions

def firestore_value(v):
    if 'stringValue' in v: return v['stringValue']
    if 'integerValue' in v: return int(v['integerValue'])
    if 'doubleValue' in v: return v['doubleValue']
    if 'booleanValue' in v: return v['booleanValue']
    if 'timestampValue' in v: return v['timestampValue']
    if 'arrayValue' in v: return [firestore_value(x) for x in v['arrayValue'].get('values', [])]
    if 'mapValue' in v: return {k: firestore_value(x) for k, x in v['mapValue'].get('fields', {}).items()}
    return None


def fetch_releases(cfg: dict, offline: bool) -> list[dict]:
    if cfg.get('projectId') and not offline:
        url = f"https://firestore.googleapis.com/v1/projects/{cfg['projectId']}/databases/(default)/documents:runQuery"
        body = json.dumps({'structuredQuery': {
            'from': [{'collectionId': 'releases'}],
            'where': {'fieldFilter': {'field': {'fieldPath': 'published'}, 'op': 'EQUAL', 'value': {'booleanValue': True}}},
        }}).encode()
        try:
            req = urllib.request.Request(url, body, {'Content-Type': 'application/json'})
            rows = json.load(urllib.request.urlopen(req, timeout=20))
            rels = [{k: firestore_value(v) for k, v in r['document'].get('fields', {}).items()} for r in rows if 'document' in r]
            if rels:
                log(f'{len(rels)} version(s) lue(s) dans Firestore')
                return rels
            log('Firestore : aucune version publiée, lecture de releases/*.json')
        except Exception as e:  # réseau, base pas encore créée...
            log(f'Firestore indisponible ({e}), lecture de releases/*.json')
    rels = [load_json(p) for p in sorted((ROOT / 'releases').glob('*.json'))]
    return [r for r in rels if r.get('published')]


def normalize(rels: list[dict], lang: str, cfg: dict) -> list[dict]:
    out = []
    bucket = cfg.get('storageBucket') or ''
    for r in sorted(rels, key=lambda r: (r.get('build', 0), str(r.get('date', ''))), reverse=True):
        notes = (r.get('notes') or {}).get(lang) or (r.get('notes') or {}).get('fr') or {}
        files = {}
        for k in VARIANTS:
            f = (r.get('files') or {}).get(k)
            if not f or not f.get('path'):
                continue
            files[k] = dict(f, size_display=size_display(int(f.get('size', 0)), lang),
                            url=f"https://firebasestorage.googleapis.com/v0/b/{bucket}/o/{urllib.request.quote(f['path'], safe='')}?alt=media")
        date = str(r.get('date', ''))[:10]
        out.append({
            'version': r['version'], 'build': r.get('build', 0), 'date': date,
            'date_display': date_display(date, lang) if date else '',
            'minAndroid': r.get('minAndroid', cfg['minAndroid']),
            'notes': {'summary': notes.get('summary', ''), 'added': notes.get('added', []),
                      'improved': notes.get('improved', []), 'fixed': notes.get('fixed', [])},
            'files': files,
        })
    return out


# ------------------------------------------------------------------ images

def rounded(im: Image.Image, radius: int) -> Image.Image:
    mask = Image.new('L', im.size, 0)
    ImageDraw.Draw(mask).rounded_rectangle((0, 0, *im.size), radius, fill=255)
    out = Image.new('RGBA', im.size)
    out.paste(im, (0, 0), mask)
    return out


def load_screen(lang: str, key: str) -> Image.Image:
    p = SRC / 'static' / 'img' / 'raw' / f'{lang}-{SCREENS[key]}.png'
    if not p.exists():
        p = SRC / 'static' / 'img' / 'raw' / f'fr-{SCREENS[key]}.png'
    im = Image.open(p).convert('RGB')
    # Retire la barre de navigation Android (bas de l'écran).
    w, h = im.size
    return im.crop((0, 0, w, int(h * 0.944)))


def build_screens(t: dict) -> dict:
    out = {}
    for lang in LANGS:
        out[lang] = {}
        for key in SCREENS:
            im = load_screen(lang, key)
            im = im.resize((600, round(600 * im.height / im.width)), Image.LANCZOS)
            rel = f'assets/img/screens/{lang}-{key}.webp'
            dest = OUT / rel
            dest.parent.mkdir(parents=True, exist_ok=True)
            im.save(dest, 'WEBP', quality=80, method=6)
            alt = t[lang]['common']['screenshot_of'].replace('{name}', t[lang]['screens'][key])
            out[lang][key] = {'src': '/' + rel, 'w': im.width, 'h': im.height, 'alt': alt}
    log(f'{len(SCREENS) * len(LANGS)} captures optimisées')
    return out


def build_icons(cfg: dict) -> None:
    full = Image.open(APP / 'assets' / 'icon' / 'icon_full.png').convert('RGBA')
    fg = Image.open(APP / 'assets' / 'icon' / 'icon_foreground.png').convert('RGBA')
    img = OUT / 'assets' / 'img'
    img.mkdir(parents=True, exist_ok=True)
    rnd = lambda size: rounded(full.resize((size, size), Image.LANCZOS), int(size * 0.22))
    rnd(192).save(img / 'icon-192.png', optimize=True)
    rnd(512).save(img / 'icon-512.png', optimize=True)
    rnd(96).save(img / 'logo-96.png', optimize=True)
    full.resize((180, 180), Image.LANCZOS).convert('RGB').save(OUT / 'apple-touch-icon.png', optimize=True)
    rnd(64).save(OUT / 'favicon.ico', sizes=[(16, 16), (32, 32), (48, 48)])
    # Icône « maskable » (PWA / Android) : motif centré sur fond bleu nuit.
    mask = Image.new('RGBA', (512, 512), (*NAVY, 255))
    mf = fg.resize((512, 512), Image.LANCZOS)
    mask.alpha_composite(mf)
    mask.convert('RGB').save(img / 'icon-maskable-512.png', optimize=True)
    log('icônes et favicon générés')


def phone_frame(screen: Image.Image, width: int) -> Image.Image:
    s = screen.resize((width, round(width * screen.height / screen.width)), Image.LANCZOS)
    pad = max(6, width // 36)
    frame = Image.new('RGBA', (s.width + pad * 2, s.height + pad * 2), (0, 0, 0, 0))
    ImageDraw.Draw(frame).rounded_rectangle((0, 0, *frame.size), int(width * 0.13), fill=(10, 19, 40, 255))
    frame.alpha_composite(rounded(s.convert('RGBA'), int(width * 0.1)), (pad, pad))
    return frame


def build_og(cfg: dict, t: dict, lang: str, key: str, title: str, subtitle: str, shots: list[str]) -> str:
    W, H = 1200, 630
    img = Image.new('RGB', (W, H), NAVY)
    # Dégradé bleu nuit + halo doré.
    grad = Image.new('RGB', (W, H))
    gd = ImageDraw.Draw(grad)
    for y in range(H):
        k = y / H
        gd.line([(0, y), (W, y)], fill=(int(11 + 8 * k), int(27 + 14 * k), int(61 + 18 * k)))
    img = grad
    halo = Image.new('RGBA', (W, H), (0, 0, 0, 0))
    ImageDraw.Draw(halo).ellipse((760, -260, 1400, 380), fill=(*GOLD, 70))
    img.paste(halo.filter(ImageFilter.GaussianBlur(120)), (0, 0), halo.filter(ImageFilter.GaussianBlur(120)))
    img = img.convert('RGBA')

    # Téléphones à droite.
    x = 760
    for i, key_shot in enumerate(shots):
        ph = phone_frame(load_screen(lang, key_shot), 235)
        ph = ph.rotate(-5 if i else 5, resample=Image.BICUBIC, expand=True)
        img.alpha_composite(ph, (x + i * 160, 70 - i * 30))

    d = ImageDraw.Draw(img)
    logo = rounded(Image.open(APP / 'assets' / 'icon' / 'icon_full.png').convert('RGBA').resize((84, 84), Image.LANCZOS), 20)
    img.alpha_composite(logo, (64, 60))
    d.text((166, 72), cfg['appName'], font=font(True, 46), fill='white')
    d.text((168, 124), t['seo']['tagline'], font=font(False, 20), fill=(245, 201, 106))

    y = 210
    for line in textwrap.wrap(title, 26)[:3]:
        d.text((64, y), line, font=font(True, 52), fill='white')
        y += 64
    y += 12
    for line in textwrap.wrap(subtitle, 48)[:3]:
        d.text((64, y), line, font=font(False, 25), fill=(210, 218, 235))
        y += 34
    # Bandeau bas.
    d.rounded_rectangle((64, 540, 64 + 330, 588), 24, fill=GOLD)
    d.text((88, 550), t['common']['download_cta'], font=font(True, 22), fill=NAVY)

    rel = f'assets/og/{lang}-{key}.jpg'
    dest = OUT / rel
    dest.parent.mkdir(parents=True, exist_ok=True)
    img.convert('RGB').save(dest, 'JPEG', quality=84, optimize=True, progressive=True)
    return f"{cfg['siteUrl']}/{rel}"


def build_qr(url: str, lang: str) -> str:
    q = qrcode.QRCode(border=1, box_size=10, error_correction=qrcode.constants.ERROR_CORRECT_M)
    q.add_data(url)
    q.make(fit=True)
    im = q.make_image(fill_color=(11, 27, 61), back_color='white').convert('RGB')
    rel = f'assets/img/qr-{lang}.png'
    im.resize((328, 328), Image.NEAREST).save(OUT / rel, optimize=True)
    return '/' + rel


# ------------------------------------------------------------------ données structurées (JSON-LD)

def person(cfg: dict, lang: str) -> dict:
    dev = cfg['developer']
    return {
        '@type': 'Person', '@id': f"{cfg['siteUrl']}/#developer", 'name': dev['name'],
        'jobTitle': dev['jobTitle'] if lang == 'fr' else dev['jobTitleEn'],
        'email': f"mailto:{cfg['contactEmail']}", 'telephone': dev['phones'][0].replace(' ', ''),
        'address': {'@type': 'PostalAddress', 'addressLocality': dev['city'], 'addressCountry': dev['country']},
        'sameAs': [dev['github'], dev['linkedin']],
    }


def app_ld(cfg, t, lang, latest, screens, page_url) -> dict:
    su = cfg['siteUrl']
    ld = {
        '@context': 'https://schema.org', '@type': 'SoftwareApplication', '@id': f'{su}/#app',
        'name': cfg['appName'], 'description': t['home']['description'], 'url': page_url,
        'applicationCategory': 'BusinessApplication', 'applicationSubCategory': 'Property management',
        'operatingSystem': f"Android {cfg['minAndroid']}+",
        'softwareRequirements': f"Android {cfg['minAndroid']}",
        'downloadUrl': su + ROUTES['download'][lang], 'installUrl': su + ROUTES['download'][lang],
        'image': f'{su}/assets/img/icon-512.png',
        'screenshot': [su + s['src'] for s in screens[lang].values()][:6],
        'inLanguage': ['fr', 'en'],
        'featureList': [f['title'] for f in t['home']['features']],
        'offers': {'@type': 'Offer', 'price': '0', 'priceCurrency': 'XAF', 'availability': 'https://schema.org/InStock'},
        'author': person(cfg, lang), 'publisher': {'@id': f'{su}/#developer'},
    }
    if latest:
        ld['softwareVersion'] = latest['version']
        ld['datePublished'] = latest['date']
        uni = latest['files'].get('universal')
        if uni:
            ld['fileSize'] = size_display(int(uni['size']), 'en')
    return ld


def breadcrumbs(cfg, t, lang, key) -> dict:
    su = cfg['siteUrl']
    names = {'download': t['nav']['download'], 'versions': t['nav']['versions'], 'contact': t['nav']['contact'], 'privacy': t['footer']['legal']}
    return {'@context': 'https://schema.org', '@type': 'BreadcrumbList', 'itemListElement': [
        {'@type': 'ListItem', 'position': 1, 'name': t['nav']['home'], 'item': su + ROUTES['home'][lang]},
        {'@type': 'ListItem', 'position': 2, 'name': names[key], 'item': su + ROUTES[key][lang]},
    ]}


# ------------------------------------------------------------------ génération

def main() -> None:
    ap = argparse.ArgumentParser()
    ap.add_argument('--offline', action='store_true')
    args = ap.parse_args()

    cfg = load_config()
    print(f"NHimmo — génération du site ({cfg['siteUrl']})")
    t = {l: load_json(SRC / 'i18n' / f'{l}.json') for l in LANGS}
    raw_releases = fetch_releases(cfg, args.offline)

    if OUT.exists():
        shutil.rmtree(OUT)
    OUT.mkdir()

    # Fichiers statiques (CSS / JS) avec empreinte pour le cache.
    hashes = {}
    for sub in ('css', 'js'):
        for f in (SRC / 'static' / sub).glob('*'):
            dest = OUT / 'assets' / sub / f.name
            dest.parent.mkdir(parents=True, exist_ok=True)
            shutil.copy2(f, dest)
            hashes[f'{sub}/{f.name}'] = hashlib.sha1(f.read_bytes()).hexdigest()[:10]
    # Les modules JS importés entre eux doivent partager la même version : empreinte globale.
    js_hash = hashlib.sha1(''.join(sorted(v for k, v in hashes.items() if k.startswith('js/'))).encode()).hexdigest()[:10]
    asset = lambda p: f"/assets/{p}?v={js_hash if p.startswith('js/') else hashes[p]}"

    build_icons(cfg)
    screens = build_screens(t)

    env = Environment(loader=FileSystemLoader(SRC / 'templates'), autoescape=select_autoescape(['html']),
                      trim_blocks=False, lstrip_blocks=False)
    su = cfg['siteUrl']
    today = dt.date.today().isoformat()
    sitemap = []

    for lang in LANGS:
        other = 'en' if lang == 'fr' else 'fr'
        tl = t[lang]
        rels = normalize(raw_releases, lang, cfg)
        latest = rels[0] if rels else None
        r = {k: v[lang] for k, v in ROUTES.items()}
        strings = {**tl['common'], **tl['versions'], **tl['contact'],
                   **{k: tl['download'][k] for k in ('recommended_optimized', 'recommended_universal', 'button', 'whats_new')},
                   'variants': {k: v['name'] for k, v in tl['download']['variants'].items()}}
        client = {'lang': lang, 'projectId': cfg.get('projectId', ''), 'storageBucket': cfg.get('storageBucket', ''),
                  'contactEmail': cfg['contactEmail'], 'strings': strings}
        qr_src = build_qr(su + ROUTES['download'][lang], lang)

        for key, tpl in [('home', 'home.html'), ('download', 'download.html'), ('versions', 'versions.html'),
                         ('contact', 'contact.html'), ('privacy', 'privacy.html')]:
            sec = tl[key]
            url = su + ROUTES[key][lang]
            shots = {'home': ['contract', 'dashboard'], 'download': ['dashboard', 'invoice'],
                     'versions': ['invoices', 'pdf'], 'contact': ['dashboard', 'rentals'],
                     'privacy': ['properties', 'dashboard']}[key]
            og = build_og(cfg, tl, lang, key, sec['og_title'], sec['og_description'], shots)
            jsonld = []
            if key == 'home':
                jsonld = [
                    {'@context': 'https://schema.org', '@type': 'WebSite', '@id': f'{su}/#website', 'name': cfg['appName'],
                     'url': url, 'inLanguage': lang, 'publisher': {'@id': f'{su}/#developer'}},
                    app_ld(cfg, tl, lang, latest, screens, url),
                    {'@context': 'https://schema.org', '@type': 'FAQPage', 'mainEntity': [
                        {'@type': 'Question', 'name': f['q'], 'acceptedAnswer': {'@type': 'Answer', 'text': f['a']}}
                        for f in tl['home']['faq']]},
                ]
            else:
                jsonld = [breadcrumbs(cfg, tl, lang, key)]
                if key == 'download':
                    jsonld.append(app_ld(cfg, tl, lang, latest, screens, url))
                if key == 'contact':
                    jsonld.append({'@context': 'https://schema.org', '@type': 'ContactPage', 'url': url,
                                   'name': sec['title'], 'about': {'@id': f'{su}/#app'}, 'mainEntity': person(cfg, lang)})
            page = {
                'key': key, 'url': url, 'canonical': True, 'robots': 'index, follow, max-image-preview:large',
                'title': sec['title'] if key == 'home' else f"{sec['title']} | {cfg['appName']}",
                'description': sec['description'], 'og_title': sec['og_title'], 'og_description': sec['og_description'],
                'og_image': og, 'og_type': 'website', 'jsonld': jsonld,
                'alternates': {l: su + ROUTES[key][l] for l in LANGS},
            }
            html = env.get_template(tpl).render(
                t=tl, cfg=cfg, page=page, r=r, asset=asset, screens=screens[lang], latest=latest, releases=rels,
                client_config=client, year=dt.date.today().year, qr_src=qr_src, today=today,
                today_display=date_display(today, lang),
                other={'lang': other, 'locale': t[other]['locale'], 'path': ROUTES[key][other]},
            )
            dest = OUT / ROUTES[key][lang].strip('/') / 'index.html'
            dest.parent.mkdir(parents=True, exist_ok=True)
            dest.write_text(html, encoding='utf-8')
            sitemap.append((key, lang))

    # Page 404 (français, avec lien vers l'anglais).
    tl = t['fr']
    html = env.get_template('404.html').render(
        t=tl, cfg=cfg, asset=asset, screens=screens['fr'], year=dt.date.today().year,
        r={k: v['fr'] for k, v in ROUTES.items()},
        client_config={'lang': 'fr', 'strings': {}},
        page={'key': '404', 'url': su + '/404.html', 'canonical': False, 'robots': 'noindex', 'title': tl['notfound']['title'],
              'description': tl['home']['description'], 'og_title': tl['home']['og_title'],
              'og_description': tl['home']['og_description'], 'og_image': f'{su}/assets/og/fr-home.jpg', 'og_type': 'website', 'jsonld': []},
        other={'lang': 'en', 'locale': 'en_US', 'path': '/en/', 'home': '/en/',
               'notfound_h1': t['en']['notfound']['h1'], 'back_home': t['en']['common']['back_home']},
    )
    (OUT / '404.html').write_text(html, encoding='utf-8')

    # Sitemap avec alternatives de langue.
    lines = ['<?xml version="1.0" encoding="UTF-8"?>',
             '<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9" xmlns:xhtml="http://www.w3.org/1999/xhtml">']
    for key, lang in sitemap:
        lines.append('  <url>')
        lines.append(f'    <loc>{su}{ROUTES[key][lang]}</loc>')
        lines.append(f'    <lastmod>{today}</lastmod>')
        lines.append(f"    <changefreq>{'weekly' if key in ('download', 'versions') else 'monthly'}</changefreq>")
        lines.append(f"    <priority>{'1.0' if key == 'home' else '0.8' if key in ('download', 'versions') else '0.5'}</priority>")
        for l in LANGS:
            lines.append(f'    <xhtml:link rel="alternate" hreflang="{l}" href="{su}{ROUTES[key][l]}"/>')
        lines.append(f'    <xhtml:link rel="alternate" hreflang="x-default" href="{su}{ROUTES[key]["fr"]}"/>')
        lines.append('  </url>')
    lines.append('</urlset>')
    (OUT / 'sitemap.xml').write_text('\n'.join(lines) + '\n', encoding='utf-8')
    (OUT / 'robots.txt').write_text(f'User-agent: *\nAllow: /\n\nSitemap: {su}/sitemap.xml\n', encoding='utf-8')

    manifest = {
        'name': f"{cfg['appName']} — {t['fr']['seo']['tagline']}", 'short_name': cfg['appName'],
        'description': t['fr']['home']['description'], 'lang': 'fr', 'start_url': '/', 'scope': '/',
        'display': 'standalone', 'background_color': '#0B1B3D', 'theme_color': cfg['themeColor'],
        'icons': [
            {'src': '/assets/img/icon-192.png', 'sizes': '192x192', 'type': 'image/png'},
            {'src': '/assets/img/icon-512.png', 'sizes': '512x512', 'type': 'image/png'},
            {'src': '/assets/img/icon-maskable-512.png', 'sizes': '512x512', 'type': 'image/png', 'purpose': 'maskable'},
        ],
        'related_applications': [{'platform': 'webapp', 'url': f'{su}/manifest.webmanifest'}],
    }
    (OUT / 'manifest.webmanifest').write_text(json.dumps(manifest, ensure_ascii=False, indent=2), encoding='utf-8')

    total = sum(f.stat().st_size for f in OUT.rglob('*') if f.is_file())
    print(f'Site généré dans {OUT} ({len(sitemap)} pages, {total / 1e6:.1f} Mo)')


if __name__ == '__main__':
    sys.exit(main())
