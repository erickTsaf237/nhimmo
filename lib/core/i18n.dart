import 'package:flutter/widgets.dart';

import '../l10n/app_localizations.dart';

/// Langues : l'interface suit le réglage de l'app, les documents suivent la langue du locataire.
/// Ajouter une langue = ajouter lib/l10n/app_xx.arb (traduction de app_en.arb), rien d'autre.
class I18n {
  /// Langue actuelle de l'interface (code ISO 639-1).
  static String lang = 'fr';

  static List<String> get codes =>
      AppLocalizations.supportedLocales.map((l) => l.languageCode).toList();

  static AppLocalizations of(String? code) =>
      lookupAppLocalizations(Locale(code != null && codes.contains(code) ? code : lang));

  static AppLocalizations get ui => of(lang);

  /// Nom de la langue dans sa propre langue (« Français », « English »...).
  static String nativeName(String code) => of(code).languageName;
}

extension L10nContext on BuildContext {
  AppLocalizations get t => AppLocalizations.of(this);
}
