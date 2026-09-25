import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:myimmo/core/billing_calc.dart';
import 'package:myimmo/core/dates.dart';
import 'package:myimmo/data/database.dart';
import 'package:myimmo/data/repo.dart';
import 'package:myimmo/services/app_state.dart';
import 'package:myimmo/services/billing_service.dart';
import 'package:myimmo/services/export_service.dart';
import 'package:myimmo/services/pdf_service.dart';
import 'package:myimmo/services/signature_service.dart';
import 'package:intl/date_symbol_data_local.dart';

/// Scénario complet : entrée en cours de mois, relevés, factures, paiement, sortie.
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late AppDatabase db;
  late int contractId, waterMeter, elecMeter;

  setUpAll(() async {
    await initializeDateFormatting('fr_FR');
    db = AppDatabase(NativeDatabase.memory());
    App.db = db;
    await App.settings.load();
    driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;

    final water = await (db.select(db.utilityTypes)..where((t) => t.name.equals('Eau'))).getSingle();
    final elec = await (db.select(db.utilityTypes)..where((t) => t.name.equals('Électricité'))).getSingle();
    // Électricité : TVA 19,25 % en sus + entretien 1 000.
    await (db.update(db.utilityTypes)..where((t) => t.id.equals(elec.id))).write(const UtilityTypesCompanion(
        fixedFee: Value(100000), vatRate: Value(19.25), vatMode: Value(2)));
    final parking = await db.select(db.serviceTypes).getSingle();

    final owner = await db.into(db.owners).insert(OwnersCompanion.insert(name: 'M. Propriétaire'));
    final building = await db.into(db.buildings).insert(BuildingsCompanion.insert(ownerId: owner, name: 'Résidence A'));
    final apt = await db.into(db.apartments).insert(ApartmentsCompanion.insert(buildingId: building, name: 'A1'));
    waterMeter = await db.into(db.meters).insert(MetersCompanion.insert(apartmentId: apt, utilityTypeId: water.id));
    elecMeter = await db.into(db.meters).insert(MetersCompanion.insert(apartmentId: apt, utilityTypeId: elec.id));
    final tenant = await db.into(db.tenants).insert(TenantsCompanion.insert(fullName: 'Jean Locataire'));

    contractId = await db.into(db.contracts).insert(ContractsCompanion.insert(
      apartmentId: apt,
      tenantId: tenant,
      startDate: DateTime(2026, 7, 16),
      rent: 10000000, // 100 000,00
      deposit: const Value(20000000),
      depositPaid: const Value(20000000),
    ));
    // 2 véhicules dont 1 autorisé → 1 facturé à 5 000.
    await db.into(db.contractServices).insert(ContractServicesCompanion.insert(
        contractId: contractId, serviceTypeId: parking.id, quantity: const Value(2), includedQuantity: const Value(1), unitPrice: 500000));
    for (final (m, v) in [(waterMeter, 100.0), (elecMeter, 1000.0)]) {
      await db.into(db.readings).insert(ReadingsCompanion.insert(
          meterId: m, contractId: Value(contractId), kind: const Value(1), date: DateTime(2026, 7, 16), value: v));
    }
  });

  Future<void> read(int meter, int period, double v) => db.into(db.readings).insert(ReadingsCompanion.insert(
      meterId: meter, period: Value(period), date: Period.lastDay(period), value: v));

  test('Juillet : entrée le 16, loyer et parking au prorata, consommations depuis l\'index d\'entrée', () async {
    await read(waterMeter, 202607, 105);
    await read(elecMeter, 202607, 1100);
    final r = await BillingService.generateMonth(202607);
    expect(r.created, 1);
    expect(r.warnings, isEmpty);

    final inv = (await Repo.invoices(period: 202607)).single;
    final lines = await Repo.lines(inv.inv.id);
    final rent = lines.firstWhere((l) => l.kind == 0);
    expect(rent.ttc, BillingCalc.prorata(10000000, 16, 31));
    final park = lines.firstWhere((l) => l.kind == 2);
    expect(park.ttc, BillingCalc.prorata(500000, 16, 31));
    final water = lines.firstWhere((l) => l.label == 'Eau');
    expect(water.quantity, 5);
    expect(water.ttc, 5 * 50000);
    final elec = lines.firstWhere((l) => l.label == 'Électricité');
    expect(elec.quantity, 100);
    expect(elec.ht, 100 * 10000 + 100000);
    expect(elec.vat, (1000000 * 0.1925).round()); // TVA hors entretien
    expect(inv.inv.total, lines.fold<int>(0, (s, l) => s + l.ttc));
    expect(inv.locked, isFalse);
  });

  test('Août : consommation depuis la facture précédente, juillet devient verrouillé', () async {
    await read(waterMeter, 202608, 112);
    await read(elecMeter, 202608, 1250);
    await BillingService.generateMonth(202608);
    final aug = (await Repo.invoices(period: 202608)).single;
    final lines = await Repo.lines(aug.inv.id);
    expect(lines.firstWhere((l) => l.kind == 0).ttc, 10000000);
    expect(lines.firstWhere((l) => l.label == 'Eau').quantity, 7);
    expect(lines.firstWhere((l) => l.label == 'Électricité').quantity, 150);

    final jul = (await Repo.invoices(period: 202607)).single;
    expect(jul.locked, isTrue);
    final again = await BillingService.generateMonth(202607);
    expect(again.locked, 1);

    // Régénération d'août (non verrouillé) : même numéro, pas de doublon.
    await BillingService.generateMonth(202608);
    expect((await Repo.invoices(period: 202608)).length, 1);
  });

  test('Paiement partiel : affectation FIFO', () async {
    final jul = (await Repo.invoices(period: 202607)).single;
    await db.into(db.payments).insert(PaymentsCompanion.insert(
        contractId: contractId, date: DateTime(2026, 8, 5), amount: jul.inv.total + 1000000, receiptNumber: 'Q2026-0001'));
    final all = await Repo.invoices(contractId: contractId);
    expect(all.firstWhere((v) => v.inv.period == 202607).status, PayStatus.paid);
    final aug = all.firstWhere((v) => v.inv.period == 202608);
    expect(aug.status, PayStatus.partial);
    expect(aug.remaining, aug.inv.total - 1000000);
  });

  test('Sortie le 10 septembre au prorata, caution insuffisante', () async {
    final c = (await Repo.contract(contractId)).c;
    final input = ExitInput(
      exitDate: DateTime(2026, 9, 10),
      prorata: true,
      exitIndexes: {waterMeter: 115, elecMeter: 1300},
      damages: 25000000, // 250 000 > caution de 200 000
    );
    final p = await BillingService.previewExit(c, input);
    expect(p.warnings, isEmpty);
    expect(p.lines.firstWhere((l) => l.kind == 0).ttc, BillingCalc.prorata(10000000, 10, 30));
    expect(p.lines.firstWhere((l) => l.label == 'Eau').quantity, 3);
    expect(p.lines.firstWhere((l) => l.label == 'Électricité').quantity, 50);
    expect(p.lines.firstWhere((l) => l.kind == 3).ttc, 25000000);
    expect(p.finalBalance, greaterThan(0));

    await BillingService.closeContract(c, input);
    final after = await Repo.contract(contractId);
    expect(after.active, isFalse);
    expect(after.balance, p.finalBalance);
    expect(after.c.damagesAmount, 25000000);
  });

  test('Mois complet quand le mois de sortie est déjà facturé : pas de déduction', () async {
    // Contrat séparé pour tester l'autre option.
    final c2 = await db.into(db.contracts).insert(ContractsCompanion.insert(
        apartmentId: 1, tenantId: 1, startDate: DateTime(2026, 10, 1), rent: 9000000));
    await read(waterMeter, 202610, 120);
    await read(elecMeter, 202610, 1400);
    await BillingService.generateMonth(202610);
    final c = (await Repo.contract(c2)).c;
    final keep = await BillingService.previewExit(c,
        ExitInput(exitDate: DateTime(2026, 10, 20), prorata: false, exitIndexes: {waterMeter: 121, elecMeter: 1410}, damages: 0));
    expect(keep.lines.where((l) => l.kind == 0 || l.kind == 4), isEmpty);
    final pro = await BillingService.previewExit(c,
        ExitInput(exitDate: DateTime(2026, 10, 20), prorata: true, exitIndexes: {waterMeter: 121, elecMeter: 1410}, damages: 0));
    final credit = pro.lines.firstWhere((l) => l.kind == 4);
    expect(credit.ttc, BillingCalc.prorata(9000000, 20, 31) - 9000000);
  });

  test('PDF signés, QR vérifiable, falsification détectée, exports', () async {
    final inv = (await Repo.invoices(period: 202608)).single;
    final pdf = await PdfService.invoice(inv.inv.id);
    expect(pdf.length, greaterThan(1000));
    expect((await PdfService.exitStatement(contractId)).length, greaterThan(1000));
    final pay = (await Repo.payments(contractId: contractId)).firstWhere((p) => p.pay.kind == 0);
    expect((await PdfService.receipt(pay.pay.id)).length, greaterThan(1000));

    final qr = await SignatureService.qrData(DocType.invoice, inv.inv.id, inv.inv.number, inv.inv.total);
    final parsed = SignatureService.parse(qr)!;
    expect(await SignatureService.verify(parsed), isTrue);
    final forged = SignatureService.parse(qr.replaceFirst('|${inv.inv.total}|', '|1|'))!;
    expect(await SignatureService.verify(forged), isFalse);

    final readings = await ExportService.readings(202607, 202610);
    expect(readings['Relevés']!.length, greaterThan(8));
    final billing = await ExportService.billing(202607, 202610);
    expect(billing.keys, containsAll(['Factures', 'Lignes', 'Paiements', 'Soldes']));
    final all = await ExportService.everything();
    expect(all.keys, contains('invoices'));
  });
}
