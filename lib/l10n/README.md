# Ajouter une langue

1. Copier `app_en.arb` en `app_xx.arb` (`xx` = code ISO 639-1, par exemple `es`, `de`, `pt`).
2. Remplacer `"@@locale": "en"` par `"@@locale": "xx"`.
3. Traduire les valeurs sans toucher aux clés ni aux `{paramètres}`. `languageName` = nom de la langue dans cette langue (« Español »).
4. Lancer `flutter gen-l10n`, puis `flutter test` : le test `i18n_test.dart` signale toute clé manquante ou tout paramètre différent.

La langue apparaît alors automatiquement :
- dans Paramètres → Général → Langue de l'application ;
- dans la fiche locataire → Langue des documents ;
- dans les champs « Nom (…) » des types de compteurs et des services.

`app_fr.arb` est le fichier de référence : toute nouvelle clé s'y ajoute d'abord, puis dans chaque autre langue.
