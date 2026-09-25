import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:myimmo/core/billing_calc.dart';
import 'package:myimmo/core/dates.dart';
import 'package:myimmo/data/database.dart';
import 'package:myimmo/data/repo.dart';
import 'package:myimmo/services/app_state.dart';
import 'package:myimmo/services/billing_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Calculs purs', () {
    const t = Tariff(unitPrice: 10000, fixedFee: 100000);
    test('exonération 100 % : toute la ligne', () {
      expect(Benefits.discount(BenefitMode.percent, lineTtc: 500000, value: 100), 500000);
    });
    test('unités gratuites : entretien et surplus restent dus', () {
      final line = BillingCalc.utility(50, t).ttc; // 50 × 100 + 1 000
      final d = Benefits.discount(BenefitMode.freeUnits, lineTtc: line, value: 30, consumption: 50, tariff: t);
      expect(d, 30 * 10000);
      expect(Benefits.discount(BenefitMode.freeUnits, lineTtc: line, value: 80, consumption: 50, tariff: t), 50 * 10000);
    });
    test('montant fixe plafonné à la ligne', () {
      expect(Benefits.discount(BenefitMode.fixedAmount, lineTtc: 3000, amount: 5000), 3000);
    });
    test('période de validité', () {
      expect(Benefits.activeIn(202609, 202607, null), isTrue);
      expect(Benefits.activeIn(202609, null, 202608), isFalse);
    });
    test('reconduction tacite : jamais d\'arrêt automatique', () {
      final start = DateTime(2024, 1, 1), end = DateTime(2025, 1, 1);
      expect(LeaseTerm.currentEnd(start, end, true, DateTime(2026, 9, 24)), DateTime(2027, 1, 1));
      expect(LeaseTerm.renewals(start, end, true, DateTime(2026, 9, 24)), 2);
      expect(LeaseTerm.currentEnd(start, end, false, DateTime(2026, 9, 24)), end);
      expect(LeaseTerm.currentEnd(start, end, true, DateTime(2024, 6, 1)), end);
    });
  });

  test('Facture : employé ENEO exonéré d\'électricité, puis avantage suspendu', () async {
    await initializeDateFormatting('fr_FR');
    driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
    final db = AppDatabase(NativeDatabase.memory());
    App.db = db;
    await App.settings.load();

    final elec = await (db.select(db.utilityTypes)..where((t) => t.name.equals('Électricité'))).getSingle();
    await (db.update(db.utilityTypes)..where((t) => t.id.equals(elec.id)))
        .write(const UtilityTypesCompanion(vatRate: Value(19.25), vatMode: Value(2), fixedFee: Value(100000)));
    final parking = await db.select(db.serviceTypes).getSingle();
    final o = await db.into(db.owners).insert(OwnersCompanion.insert(name: 'P'));
    final b = await db.into(db.buildings).insert(BuildingsCompanion.insert(ownerId: o, name: 'B'));
    final a = await db.into(db.apartments).insert(ApartmentsCompanion.insert(buildingId: b, name: 'A'));
    final m = await db.into(db.meters).insert(MetersCompanion.insert(apartmentId: a, utilityTypeId: elec.id, initialIndex: const Value(1000)));
    final t = await db.into(db.tenants).insert(TenantsCompanion.insert(fullName: 'Agent ENEO'));
    final c = await db.into(db.contracts).insert(ContractsCompanion.insert(
        apartmentId: a, tenantId: t, startDate: DateTime(2026, 1, 1), rent: 10000000,
        plannedEndDate: Value(DateTime(2027, 1, 1))));
    await db.into(db.contractServices).insert(ContractServicesCompanion.insert(
        contractId: c, serviceTypeId: parking.id, quantity: const Value(2), unitPrice: 500000));
    // Électricité offerte jusqu'en août ; parking à -50 %.
    await db.into(db.contractBenefits).insert(ContractBenefitsCompanion.insert(
        contractId: c, utilityTypeId: Value(elec.id), value: const Value(100), reason: const Value('Employé ENEO'), toPeriod: const Value(202608)));
    await db.into(db.contractBenefits).insert(ContractBenefitsCompanion.insert(
        contractId: c, serviceTypeId: Value(parking.id), value: const Value(50)));

    for (final (p, v) in [(202608, 1200.0), (202609, 1350.0)]) {
      await db.into(db.readings).insert(ReadingsCompanion.insert(meterId: m, period: Value(p), date: Period.lastDay(p), value: v));
      await BillingService.generateMonth(p);
    }

    final aug = (await Repo.invoices(period: 202608)).single;
    final augLines = await Repo.lines(aug.inv.id);
    final elecLine = augLines.firstWhere((l) => l.kind == 1);
    final elecBenefit = augLines.firstWhere((l) => l.kind == 5 && l.utilityTypeId == elec.id);
    expect(elecBenefit.ttc, -elecLine.ttc);
    expect(elecBenefit.vat, -elecLine.vat);
    expect(elecBenefit.label, contains('Employé ENEO'));
    final parkLine = augLines.firstWhere((l) => l.kind == 2);
    expect(augLines.firstWhere((l) => l.kind == 5 && l.utilityTypeId == null).ttc, -(parkLine.ttc ~/ 2));
    expect(aug.inv.total, 10000000 + parkLine.ttc ~/ 2); // loyer + demi-parking, électricité offerte

    final sep = (await Repo.invoices(period: 202609)).single;
    final sepLines = await Repo.lines(sep.inv.id);
    expect(sepLines.where((l) => l.kind == 5 && l.utilityTypeId == elec.id), isEmpty); // suspendu
    expect(sepLines.firstWhere((l) => l.kind == 1).quantity, 150);
  });
}
