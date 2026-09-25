import 'dart:io';

import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../core/money.dart';
import '../data/database.dart';

/// Point d'accès unique à la base et aux paramètres.
class App {
  static late AppDatabase db;
  static late Directory docsDir;
  static AppSettings settings = AppSettings();

  /// Incrémenté après une restauration pour reconstruire toute l'interface.
  static final generation = ValueNotifier<int>(0);

  static Directory get photosDir => Directory(p.join(docsDir.path, 'photos'));
  static Directory get backupsDir => Directory(p.join(docsDir.path, 'backups'));
  static Directory get exportsDir => Directory(p.join(docsDir.path, 'exports'));

  static Future<void> init() async {
    docsDir = await getApplicationDocumentsDirectory();
    for (final d in [photosDir, backupsDir, exportsDir]) {
      if (!await d.exists()) await d.create(recursive: true);
    }
    db = await AppDatabase.open();
    await settings.load();
  }

  static Future<void> reopen() async {
    db = await AppDatabase.open();
    await settings.load();
    generation.value++;
  }
}

class AppSettings extends ChangeNotifier {
  String businessName = 'Ma gestion locative';
  String address = '';
  String phone = '';
  String email = '';
  String currencyCode = 'XAF';
  String currencySymbol = 'FCFA';
  bool symbolBefore = false;
  int dueDay = 5;
  String invoiceFooter = '';

  /// 'system' ou un code de langue ('fr', 'en'...).
  String appLanguage = 'system';

  Future<void> load() async {
    final rows = await App.db.select(App.db.settings).get();
    final m = {for (final r in rows) r.key: r.value};
    businessName = m['businessName'] ?? businessName;
    address = m['address'] ?? '';
    phone = m['phone'] ?? '';
    email = m['email'] ?? '';
    currencyCode = m['currencyCode'] ?? 'XAF';
    currencySymbol = m['currencySymbol'] ?? 'FCFA';
    symbolBefore = m['symbolBefore'] == '1';
    dueDay = int.tryParse(m['dueDay'] ?? '') ?? 5;
    invoiceFooter = m['invoiceFooter'] ?? '';
    appLanguage = m['appLanguage'] ?? 'system';
    _apply();
  }

  Future<void> save() async {
    final values = {
      'businessName': businessName,
      'address': address,
      'phone': phone,
      'email': email,
      'currencyCode': currencyCode,
      'currencySymbol': currencySymbol,
      'symbolBefore': symbolBefore ? '1' : '0',
      'dueDay': '$dueDay',
      'invoiceFooter': invoiceFooter,
      'appLanguage': appLanguage,
    };
    await App.db.batch((b) {
      for (final e in values.entries) {
        b.insert(App.db.settings, SettingsCompanion.insert(key: e.key, value: e.value),
            mode: InsertMode.insertOrReplace);
      }
    });
    _apply();
  }

  void _apply() {
    Money.currency =
        Currency(currencyCode, currencySymbol, symbolBefore: symbolBefore);
    notifyListeners();
  }

  static Future<String?> getRaw(String key) async {
    final r = await (App.db.select(App.db.settings)
          ..where((t) => t.key.equals(key)))
        .getSingleOrNull();
    return r?.value;
  }

  static Future<void> setRaw(String key, String value) =>
      App.db.into(App.db.settings).insert(
          SettingsCompanion.insert(key: key, value: value),
          mode: InsertMode.insertOrReplace);
}
