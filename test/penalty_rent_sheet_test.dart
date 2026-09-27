import 'dart:convert';

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
import 'package:myimmo/services/history_sheet.dart';
import 'package:myimmo/services/payment_service.dart';
import 'package:myimmo/services/pdf_service.dart';
import 'package:myimmo/services/rent_service.dart';
import 'package:myimmo/services/tariff_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late AppDatabase db;
  late int building, aptA, aptB, contractA, contractB, meterA;

  setUpAll(() async {
    await initializeDateFormatting();
    driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
    db = AppDatabase(NativeDatabase.memory());
    App.db = db;
    await App.settings.load();
    final water = (await db.select(db.utilityTypes).get()).firstWhere((t) => t.name == 'Eau');
    await TariffService.save(water.id, UtilityTariffs.origin, const Tariff(unitPrice: 50000));

    final o = await db.into(db.owners).insert(OwnersCompanion.insert(name: 'P'));
    building = await db.into(db.buildings).insert(BuildingsCompanion.insert(ownerId: o, name: 'B', latePenalty: const Value(500000)));
    aptA = await db.into(db.apartments).insert(ApartmentsCompanion.insert(buildingId: building, name: 'A'));
    aptB = await db.into(db.apartments).insert(ApartmentsCompanion.insert(buildingId: building, name: 'B'));
    meterA = await db.into(db.meters).insert(MetersCompanion.insert(apartmentId: aptA, utilityTypeId: water.id, initialIndex: const Value(10)));
    final t1 = await db.into(db.tenants).insert(TenantsCompanion.insert(fullName: 'T1'));
    final t2 = await db.into(db.tenants).insert(TenantsCompanion.insert(fullName: 'T2'));
    contractA = await db.into(db.contracts).insert(ContractsCompanion.insert(
        apartmentId: aptA, tenantId: t1, startDate: DateTime(2026, 6, 1), rent: 8000000));
    await RentService.save(contractA, UtilityTariffs.origin, 8000000);
    contractB = await db.into(db.contracts).insert(ContractsCompanion.insert(
        apartmentId: aptB, tenantId: t2, startDate: DateTime(2026, 6, 1), rent: 8000000));
  });

  test('Loyer : un nouveau loyer ne change pas les mois précédents', () async {
    for (final (p, v) in [(202606, 12.0), (202607, 14.0)]) {
      await db.into(db.readings).insert(ReadingsCompanion.insert(meterId: meterA, period: Value(p), date: Period.lastDay(p), value: v));
    }
    await RentService.save(contractA, 202607, 9000000); // hausse à 90 000 à partir de juillet
    expect((await Repo.contract(contractA)).c.rent, 9000000);
    await BillingService.generateMonth(202606);
    await BillingService.generateMonth(202607);
    Future<int> rentOf(int p) async =>
        (await Repo.lines((await Repo.invoices(period: p, contractId: contractA)).single.inv.id)).firstWhere((l) => l.kind == 0).ttc;
    expect(await rentOf(202606), 8000000);
    expect(await rentOf(202607), 9000000);
    // Un contrat sans historique garde son loyer.
    expect(await RentService.rentAt((await Repo.contract(contractB)).c, 202612), 8000000);
  });

  test('Pénalité : par défaut celle de l\'immeuble ; modifiée, elle ne vaut que pour l\'appartement', () async {
    var a = (await Repo.contract(contractA)).apt;
    final b = (await db.select(db.buildings)..where((x) => x.id.equals(building))).getSingle();
    expect(PaymentService.defaultPenalty(a, await b), 500000);

    final before = (await Repo.contract(contractA)).balance;
    await PaymentService.saveWithPenalty(
      apartment: a, building: await b, contractId: contractA, penalty: 300000,
      date: DateTime(2026, 7, 20), amount: before + 300000, method: 'Espèces');
    expect((await Repo.contract(contractA)).balance, 0, reason: 'le paiement couvre le solde + la pénalité');

    a = (await Repo.contract(contractA)).apt;
    expect(a.latePenalty, 300000);
    final other = (await Repo.contract(contractB)).apt;
    expect(PaymentService.defaultPenalty(other, await b), 500000, reason: 'les autres appartements gardent la pénalité de l\'immeuble');
    final pays = await Repo.payments(contractId: contractA);
    expect(pays.where((p) => p.pay.kind == PaymentKind.penalty).single.pay.amount, 300000);
  });

  test('Fiche historique : pénalité, montant attendu, payé et date de règlement', () async {
    final sheet = await HistorySheet.build(contractA);
    expect(sheet.rows.length, 2);
    final jun = sheet.rows[0], jul = sheet.rows[1];
    expect(jun.meters.values.single.start, 10);
    expect(jun.meters.values.single.end, 12);
    expect(jul.penalty, 300000, reason: 'pénalité rattachée à la dernière facture émise avant elle');
    expect(jul.expected, jul.invoice.total + 300000);
    expect(jun.settled && jul.settled, isTrue);
    expect(jul.settledOn, DateTime(2026, 7, 20));
    expect((await PdfService.historySheet(contractA)).length, greaterThan(2000));
  });

  test('Premier loyer : forfait avec commentaire, dû à la signature ; ensuite le 10', () async {
    final t = await db.into(db.tenants).insert(TenantsCompanion.insert(fullName: 'T3'));
    final apt = await db.into(db.apartments).insert(ApartmentsCompanion.insert(buildingId: building, name: 'C'));
    final c = await db.into(db.contracts).insert(ContractsCompanion.insert(
        apartmentId: apt, tenantId: t, startDate: DateTime(2026, 8, 20), rent: 6000000,
        firstRentMode: const Value(2), firstRentAmount: const Value(4000000), firstRentNote: const Value('entrée le 20')));
    await BillingService.generateEntryInvoice(c);
    final entry = (await Repo.invoices(period: 202608, contractId: c)).single.inv;
    expect(entry.dueDate, DateTime(2026, 8, 20), reason: "le mois d'entrée se paie à la signature");
    final rent = (await Repo.lines(entry.id)).firstWhere((l) => l.kind == 0);
    expect(rent.ttc, 4000000);
    expect(jsonDecode(rent.meta!)['note'], 'entrée le 20');
    expect(BillingService.dueDateFor(202609, (await Repo.contract(c)).c), DateTime(2026, 9, 10));

    // Mois complet : pas de prorata malgré l'entrée en cours de mois.
    await (db.update(db.contracts)..where((x) => x.id.equals(c))).write(const ContractsCompanion(firstRentMode: Value(1)));
    final full = await BillingService.monthLines((await Repo.contract(c)).c, 202608);
    expect(full.first.ttc, 6000000);
    await (db.update(db.contracts)..where((x) => x.id.equals(c))).write(const ContractsCompanion(firstRentMode: Value(0)));
    expect((await PdfService.signingSlip(c)).length, greaterThan(2000));
    final pro = await BillingService.monthLines((await Repo.contract(c)).c, 202608);
    expect(pro.first.ttc, BillingCalc.prorata(6000000, 12, 31));
  });
}
