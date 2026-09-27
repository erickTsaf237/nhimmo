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
import 'package:myimmo/services/tariff_service.dart';

/// Électricité 100 F TVA incluse jusqu'en juillet 2026, puis 110 F à partir d'août ;
/// eau 368 F/m³ + TVA 19,25 % en sus + 200 F d'entretien.
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late AppDatabase db;
  late int elecId, waterId, waterMeter, elecMeter;

  setUpAll(() async {
    await initializeDateFormatting();
    driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
    db = AppDatabase(NativeDatabase.memory());
    App.db = db;
    await App.settings.load();

    final types = await db.select(db.utilityTypes).get();
    waterId = types.firstWhere((t) => t.name == 'Eau').id;
    elecId = types.firstWhere((t) => t.name == 'Électricité').id;
    await TariffService.save(elecId, UtilityTariffs.origin,
        const Tariff(unitPrice: 10000, vatRate: 19.25, vatMode: VatMode.included));
    await TariffService.save(elecId, 202608,
        const Tariff(unitPrice: 11000, vatRate: 19.25, vatMode: VatMode.included));

    final o = await db.into(db.owners).insert(OwnersCompanion.insert(name: 'P'));
    final b = await db.into(db.buildings).insert(BuildingsCompanion.insert(ownerId: o, name: 'B'));
    final a = await db.into(db.apartments).insert(ApartmentsCompanion.insert(buildingId: b, name: 'A'));
    waterMeter = await db.into(db.meters).insert(MetersCompanion.insert(apartmentId: a, utilityTypeId: waterId, initialIndex: const Value(100)));
    elecMeter = await db.into(db.meters).insert(MetersCompanion.insert(apartmentId: a, utilityTypeId: elecId, initialIndex: const Value(1000)));
    final t = await db.into(db.tenants).insert(TenantsCompanion.insert(fullName: 'T'));
    await db.into(db.contracts).insert(ContractsCompanion.insert(
        apartmentId: a, tenantId: t, startDate: DateTime(2026, 7, 1), rent: 8000000));
  });

  Future<void> read(int p, double water, double elec) async {
    for (final (m, v) in [(waterMeter, water), (elecMeter, elec)]) {
      await db.into(db.readings).insert(ReadingsCompanion.insert(meterId: m, period: Value(p), date: Period.lastDay(p), value: v));
    }
  }

  Future<List<InvoiceLine>> linesOf(int p) async =>
      Repo.lines((await Repo.invoices(period: p)).single.inv.id);

  test('Les nouveaux comptes démarrent avec les tarifs réels par défaut', () async {
    final fresh = AppDatabase(NativeDatabase.memory());
    final types = await fresh.select(fresh.utilityTypes).get();
    final hist = await fresh.select(fresh.utilityTariffs).get();
    final water = types.firstWhere((t) => t.name == 'Eau');
    expect(water.unitPrice, 36800);
    expect(hist.length, 2);
    // Barème du cahier : 1 m³ = 368 × 1,1925 + 200 ≈ 638,84 F.
    final one = BillingCalc.utility(1, TariffService.toTariff(hist.firstWhere((h) => h.utilityTypeId == water.id)));
    expect(one.ttc, 63884);
    await fresh.close();
  });

  test("Migration : chaque type existant reçoit son tarif actuel comme tarif d'origine", () async {
    final old = AppDatabase(NativeDatabase.memory());
    await old.delete(old.utilityTariffs).go(); // état d'une base v3 : pas d'historique
    await (old.update(old.utilityTypes)..where((t) => t.name.equals('Eau')))
        .write(const UtilityTypesCompanion(unitPrice: Value(45000), fixedFee: Value(0)));
    await old.backfillTariffs();
    await old.backfillTariffs(); // idempotent
    final hist = await old.select(old.utilityTariffs).get();
    expect(hist.length, 2);
    final water = (await old.select(old.utilityTypes).get()).firstWhere((t) => t.name == 'Eau');
    final w = hist.firstWhere((h) => h.utilityTypeId == water.id);
    expect(w.fromPeriod, UtilityTariffs.origin);
    expect(w.unitPrice, 45000);
    await old.close();
  });

  test('Chaque mois est facturé au tarif en vigueur ce mois-là', () async {
    await read(202607, 102, 1050); // juillet : 50 kWh à 100 F
    await BillingService.generateMonth(202607);
    await read(202608, 104, 1100); // août : 50 kWh à 110 F
    await BillingService.generateMonth(202608);

    final jul = (await linesOf(202607)).firstWhere((l) => l.utilityTypeId == elecId);
    final aug = (await linesOf(202608)).firstWhere((l) => l.utilityTypeId == elecId);
    expect(jul.ttc, 500000);
    expect(jul.unitPrice, 10000);
    expect(aug.ttc, 550000);
    expect(aug.unitPrice, 11000);
    // TVA incluse : extraite du montant, pas ajoutée.
    expect(aug.vat, 550000 - (550000 / 1.1925).round());
  });

  test('Recalculer un ancien mois garde l\'ancien tarif', () async {
    // Juillet n'est plus modifiable (août existe) ; on supprime août pour pouvoir recalculer juillet.
    final aug = (await Repo.invoices(period: 202608)).single;
    await BillingService.deleteInvoice(aug.inv.id);
    await BillingService.generateMonth(202607);
    final jul = (await linesOf(202607)).firstWhere((l) => l.utilityTypeId == elecId);
    expect(jul.ttc, 500000, reason: 'le tarif de juillet (100 F) doit être conservé malgré le passage à 110 F');
  });

  test('Tarif affiché = dernier tarif ; suppression d\'un tarif', () async {
    var elec = await (db.select(db.utilityTypes)..where((t) => t.id.equals(elecId))).getSingle();
    expect(elec.unitPrice, 11000);
    final hist = await TariffService.history(elecId);
    expect(hist.map((h) => h.fromPeriod), [UtilityTariffs.origin, 202608]);
    await TariffService.delete(hist.last);
    elec = await (db.select(db.utilityTypes)..where((t) => t.id.equals(elecId))).getSingle();
    expect(elec.unitPrice, 10000);
    // Corriger le tarif d'une même date le remplace au lieu d'en ajouter un.
    await TariffService.save(elecId, UtilityTariffs.origin, const Tariff(unitPrice: 10500, vatMode: VatMode.none));
    expect((await TariffService.history(elecId)).length, 1);
  });
}
