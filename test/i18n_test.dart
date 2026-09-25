import 'dart:convert';
import 'dart:io';

import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:myimmo/core/dates.dart';
import 'package:myimmo/core/i18n.dart';
import 'package:myimmo/core/labels.dart';
import 'package:myimmo/core/money.dart';
import 'package:myimmo/data/database.dart';
import 'package:myimmo/data/repo.dart';
import 'package:myimmo/services/app_state.dart';
import 'package:myimmo/services/billing_service.dart';
import 'package:myimmo/services/pdf_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('Chaque langue contient toutes les clés et les mêmes paramètres', () {
    Map<String, dynamic> arb(String code) =>
        jsonDecode(File('lib/l10n/app_$code.arb').readAsStringSync()) as Map<String, dynamic>;
    final fr = arb('fr');
    final files = Directory('lib/l10n').listSync().whereType<File>().where((f) => f.path.endsWith('.arb'));
    for (final f in files) {
      final other = jsonDecode(f.readAsStringSync()) as Map<String, dynamic>;
      for (final k in fr.keys.where((k) => !k.startsWith('@'))) {
        expect(other.containsKey(k), isTrue, reason: '${f.path} : clé manquante $k');
        final ph = RegExp(r'\{(\w+)\}');
        expect(ph.allMatches(other[k] as String).map((m) => m[1]).toSet(),
            ph.allMatches(fr[k] as String).map((m) => m[1]).toSet(),
            reason: '${f.path} : paramètres différents pour $k');
      }
    }
  });

  test('Formats selon la langue', () async {
    await initializeDateFormatting();
    Money.currency = const Currency('XAF', 'FCFA');
    expect(Money.format(123456789, lang: 'fr'), '1 234 567,89 FCFA');
    expect(Money.format(123456789, lang: 'en'), '1,234,567.89 FCFA');
    expect(Period.label(202608, 'fr'), 'Août 2026');
    expect(Period.label(202608, 'en'), 'August 2026');
    expect(Money.parse('1,500.50'), 150050);
    expect(Money.parse('1.500,50'), 150050);
    expect(Money.parse('1500,5'), 150050);
  });

  test('Facture d\'un locataire anglophone produite en anglais', () async {
    await initializeDateFormatting();
    driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
    final db = AppDatabase(NativeDatabase.memory());
    App.db = db;
    await App.settings.load();
    I18n.lang = 'fr';

    final water = await (db.select(db.utilityTypes)..where((t) => t.name.equals('Eau'))).getSingle();
    final o = await db.into(db.owners).insert(OwnersCompanion.insert(name: 'P'));
    final b = await db.into(db.buildings).insert(BuildingsCompanion.insert(ownerId: o, name: 'B'));
    final a = await db.into(db.apartments).insert(ApartmentsCompanion.insert(buildingId: b, name: 'A'));
    final m = await db.into(db.meters).insert(MetersCompanion.insert(apartmentId: a, utilityTypeId: water.id));
    final tn = await db.into(db.tenants).insert(TenantsCompanion.insert(fullName: 'John Tabe', language: const Value('en')));
    final c = await db.into(db.contracts).insert(ContractsCompanion.insert(
        apartmentId: a, tenantId: tn, startDate: DateTime(2026, 8, 16), rent: 10000000));
    await db.into(db.contractBenefits).insert(ContractBenefitsCompanion.insert(
        contractId: c, utilityTypeId: Value(water.id), value: const Value(50)));
    await db.into(db.readings).insert(ReadingsCompanion.insert(meterId: m, period: const Value(202608), date: DateTime(2026, 8, 31), value: 12));
    await BillingService.generateMonth(202608);

    final inv = (await Repo.invoices(period: 202608)).single;
    final lines = await Repo.lines(inv.inv.id);
    final en = LineText(await NameBook.load(db), 'en');
    final fr = LineText(await NameBook.load(db), 'fr');
    final rent = lines.firstWhere((l) => l.kind == 0);
    expect(en.label(rent), 'Rent August 2026 (16/31 days)');
    expect(fr.label(rent), 'Loyer Août 2026 (16/31 jours)');
    final util = lines.firstWhere((l) => l.kind == 1);
    expect(en.label(util), 'Water');
    expect(en.details(util), contains('Meter 0 to 12'));
    final ben = lines.firstWhere((l) => l.kind == 5);
    expect(en.label(ben), 'Benefit Water');
    expect(en.details(ben), '50% discount');
    // Les lignes enregistrées gardent un repli dans la langue de l'app.
    expect(rent.label, 'Loyer Août 2026 (16/31 jours)');
    expect((await PdfService.invoice(inv.inv.id)).length, greaterThan(1000));
    expect(Labels.room(I18n.of('en'), 'Chambre 2'), 'Bedroom 2');
    expect(Labels.method(I18n.of('en'), 'Espèces'), 'Cash');
  });
}
