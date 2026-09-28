import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:myimmo/core/advance.dart';
import 'package:myimmo/data/database.dart';
import 'package:myimmo/data/repo.dart';
import 'package:myimmo/services/app_state.dart';
import 'package:myimmo/services/history_sheet.dart';
import 'package:myimmo/services/payment_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Moteur d\'imputation', () {
    // 400 000 versés d'avance le 01/09, puis la facture d'octobre : 100 000 de loyer + 8 000 de charges.
    final items = [DebtItem('oct', DateTime(2026, 10, 1), total: 10800000, rent: 10000000)];
    final advance = [MoneyEvent(DateTime(2026, 9, 1), 40000000)];

    test('Loyer et charges : l\'avance règle toute la facture', () {
      final l = AdvanceLedger.run(items, advance, AdvanceMode.all);
      expect(l.due, 0);
      expect(l.advance, 40000000 - 10800000);
    });

    test('Loyer uniquement : les charges restent dues, puis un paiement les règle', () {
      var l = AdvanceLedger.run(items, advance, AdvanceMode.rentOnly);
      expect(l.due, 800000);
      expect(l.advance, 30000000);
      expect(l.of('oct')!.applied, 10000000);

      l = AdvanceLedger.run(items, [...advance, MoneyEvent(DateTime(2026, 10, 5), 800000)], AdvanceMode.rentOnly);
      expect(l.due, 0, reason: 'le paiement règle les charges au lieu de grossir l\'avance');
      expect(l.advance, 30000000);
      expect(l.of('oct')!.settledOn, DateTime(2026, 10, 5));
    });

    test('Un paiement fait après la facture la règle en entier, quel que soit le mode', () {
      final l = AdvanceLedger.run(items, [MoneyEvent(DateTime(2026, 10, 3), 10800000)], AdvanceMode.rentOnly);
      expect(l.due, 0);
      expect(l.advance, 0);
    });
  });

  group('Réglage de l\'application et réglage par locataire', () {
    late AppDatabase db;
    late int a, b;

    setUpAll(() async {
      await initializeDateFormatting();
      driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
      db = AppDatabase(NativeDatabase.memory());
      App.db = db;
      await App.settings.load();
      final o = await db.into(db.owners).insert(OwnersCompanion.insert(name: 'P'));
      final bld = await db.into(db.buildings).insert(BuildingsCompanion.insert(ownerId: o, name: 'B'));
      Future<int> lease(String apt) async {
        final ap = await db.into(db.apartments).insert(ApartmentsCompanion.insert(buildingId: bld, name: apt));
        final t = await db.into(db.tenants).insert(TenantsCompanion.insert(fullName: 'T$apt'));
        final c = await db.into(db.contracts).insert(ContractsCompanion.insert(
            apartmentId: ap, tenantId: t, startDate: DateTime(2026, 7, 1), rent: 10000000));
        // Avance de 4 mois versée en septembre, puis facture d'octobre (loyer + 8 000 d'eau).
        await PaymentService.save(
            contractId: c, kind: PaymentKind.payment, date: DateTime(2026, 9, 1, 12), amount: 40000000, method: 'Espèces');
        final inv = await db.into(db.invoices).insert(InvoicesCompanion.insert(
            number: 'F202610-$c', contractId: c, period: 202610, issueDate: DateTime(2026, 10, 31),
            dueDate: DateTime(2026, 10, 10), total: 10800000));
        await db.into(db.invoiceLines).insert(InvoiceLinesCompanion.insert(invoiceId: inv, kind: 0, label: 'Loyer', ht: 10000000, ttc: 10000000));
        await db.into(db.invoiceLines).insert(InvoiceLinesCompanion.insert(invoiceId: inv, kind: 1, label: 'Eau', ht: 800000, ttc: 800000));
        return c;
      }

      a = await lease('A');
      b = await lease('B');
    });

    test('Par défaut (loyer et charges) : rien n\'est dû', () async {
      final cv = await Repo.contract(a);
      expect(cv.due, 0);
      expect(cv.advance, 29200000);
    });

    test('Réglage de l\'application « loyer uniquement » : les charges sont dues pour tous', () async {
      App.settings.advanceMode = AdvanceMode.rentOnly.index;
      for (final id in [a, b]) {
        final cv = await Repo.contract(id);
        expect(cv.due, 800000);
        expect(cv.advance, 30000000);
        expect(cv.balance, 800000 - 30000000, reason: 'le solde net ne change pas');
      }
      final inv = (await Repo.invoices(contractId: a)).single;
      expect(inv.status, PayStatus.partial);
      expect(inv.remaining, 800000);
      final sheet = await HistorySheet.build(a);
      expect(sheet.rows.single.paid, 10000000);
      expect(sheet.rows.single.settledOn, isNull);
    });

    test('Réglage propre à un locataire : les autres ne changent pas', () async {
      App.settings.advanceMode = AdvanceMode.rentOnly.index;
      await (db.update(db.contracts)..where((c) => c.id.equals(b)))
          .write(ContractsCompanion(advanceMode: Value(AdvanceMode.all.index)));
      expect((await Repo.contract(a)).due, 800000, reason: 'A suit le réglage de l\'application');
      expect((await Repo.contract(b)).due, 0, reason: 'B a son propre réglage');
      App.settings.advanceMode = AdvanceMode.all.index;
    });
  });
}
