<p align="center">
  <img src="assets/icon/icon_full.png" alt="NHimmo" width="112">
</p>

<h1 align="center">NHimmo</h1>

<p align="center">
  Application Android de gestion locative, 100 % hors ligne.<br>
  <a href="https://nhimmo.web.app"><b>nhimmo.web.app</b></a> · <a href="https://nhimmo.web.app/telecharger/">Télécharger</a> · <a href="https://nhimmo.web.app/versions/">Versions</a>
</p>

---

Appartements, locataires, relevés d'eau et d'électricité, factures, paiements, cautions et fins de bail :
NHimmo réunit tout le suivi locatif sur le téléphone du gestionnaire, sans compte ni serveur.

## Fonctionnalités

- Propriétaires, immeubles, appartements, compteurs, locataires et contrats (prorata, reconduction tacite).
- Relevés mensuels avec photo du compteur et détection des consommations anormales.
- Calcul générique des charges (eau, électricité, gaz…) : prix unitaire, entretien, TVA incluse ou en sus.
- Facturation automatique : loyer, consommations, services (parking…), avantages locataires (exonérations).
- Paiements, avances imputées automatiquement, quittances, cautions incomplètes.
- Fin de bail : état des lieux pièce par pièce, dégâts déduits de la caution, décompte de sortie.
- Documents PDF signés (Ed25519) vérifiables par QR code dans l'application.
- Tableaux de bord, exports Excel / CSV, sauvegarde et restauration complètes.
- Interface en français et en anglais ; documents dans la langue de chaque locataire.

## Technologies

| Partie | Technologies |
|---|---|
| Application | Flutter / Dart, SQLite (Drift), `pdf`, `mobile_scanner`, `cryptography` |
| Site vitrine | HTML / CSS / JavaScript générés en Python (Jinja2) — [website/](website/) |
| Services | Firebase Hosting, Firestore, Storage, Cloud Functions (Node.js) — [functions/](functions/) |

## Développement

```bash
flutter pub get
dart run build_runner build --delete-conflicting-outputs   # code Drift (base de données)
flutter gen-l10n                                            # traductions (lib/l10n/*.arb)
flutter test
flutter run
```

Ajouter une langue : voir [lib/l10n/README.md](lib/l10n/README.md).

### Signature des versions publiées

Les builds `release` sont signés avec la clé définie dans `android/key.properties` (non versionné) :

```properties
storePassword=…
keyPassword=…
keyAlias=nhimmo
storeFile=D:/chemin/vers/nhimmo-release.jks
```

Sans ce fichier, la clé de débogage est utilisée (tests uniquement). La clé et ses mots de passe doivent être
sauvegardés hors du dépôt : sans eux, aucune mise à jour ne peut être installée par-dessus une version existante.

### Publier une version

```bash
python website/tools/publish_release.py 1.1.0
```

Compile l'APK universel et les APK par processeur, les envoie sur Firebase Storage, crée la fiche de version
dans Firestore et redéploie le site. Détails : [website/README.md](website/README.md).

## Licence

Code source public en consultation uniquement — tous droits réservés. Voir [LICENSE](LICENSE).

Conçu et développé par **Erick Tsafack Nteudem** · [GitHub](https://github.com/erickTsaf237) · [LinkedIn](https://www.linkedin.com/in/erick-tsafack-40037423a)
