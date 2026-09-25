import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'core/i18n.dart';
import 'l10n/app_localizations.dart';
import 'services/app_state.dart';
import 'ui/shell.dart';
import 'ui/theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting();
  await App.init();
  runApp(const NHimmoApp());
}

class NHimmoApp extends StatelessWidget {
  const NHimmoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: App.settings,
      builder: (context, _) {
        final code = App.settings.appLanguage;
        return MaterialApp(
          onGenerateTitle: (c) => c.t.appTitle,
          debugShowCheckedModeBanner: false,
          theme: AppTheme.light(),
          darkTheme: AppTheme.dark(),
          locale: code == 'system' ? null : Locale(code),
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          // Langue du téléphone si elle est traduite, sinon français.
          localeResolutionCallback: (device, supported) =>
              supported.firstWhere((l) => l.languageCode == device?.languageCode,
                  orElse: () => const Locale('fr')),
          builder: (context, child) {
            I18n.lang = Localizations.localeOf(context).languageCode;
            // Toute l'app reste au-dessus de la barre de navigation Android
            // (boutons retour / accueil) : aucun bouton ne peut se retrouver dessous.
            return ColoredBox(
              color: Theme.of(context).scaffoldBackgroundColor,
              child: SafeArea(top: false, left: false, right: false, child: child!),
            );
          },
          // Après une restauration, toute l'interface est reconstruite.
          home: ValueListenableBuilder<int>(
            valueListenable: App.generation,
            builder: (_, gen, __) => HomeShell(key: ValueKey('$gen-$code')),
          ),
        );
      },
    );
  }
}
