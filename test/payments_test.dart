import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:myimmo/core/dates.dart';
import 'package:myimmo/data/database.dart';
import 'package:myimmo/data/repo.dart';
import 'package:myimmo/services/app_state.dart';
import 'package:myimmo/services/billing_service.dart';
import 'package:myimmo/services/payment_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late AppDatabase db;
  late int contractId;

  setUpAll(() async {
    await initializeDateFormatting();
    driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
    db = AppDatabase(NativeDatabase.memory());
    App.db = db;
    await App.settings.load();
    final o = await db.into(db.owners).insert(OwnersCompanion.insert(name: 'P'));
    final b = await db.into(db.buildings).insert(BuildingsCompanion.insert(ownerId: o, name: 'B'));
    final a = await db.into(db.apartments).insert(ApartmentsCompanion.insert(buildingId: b, name: 'A'));
    final t = await db.into(db.tenants).insert(TenantsCompanion.insert(fullName: 'T'));
    // Loyer 100 000, caution exigée 200 000 dont 50 000 seulement versés.
    contractId = await db.into(db.contracts).insert(ContractsCompanion.insert(
        apartmentId: a, tenantId: t, startDate: DateTime(2026, 6, 1), rent: 10000000,
        deposit: const Value(20000000), depositPaid: const Value(5000000)));
  });

  Future<int> pay(int amount, DateTime date, {int kind = PaymentKind.payment}) => PaymentService.save(
      contractId: contractId, kind: kind, date: date, amount: amount, method: 'Espèces');

  test('Complément de caution : met à jour la caution, sans toucher au compte locatif', () async {
    final id = await pay(15000000, DateTime(2026, 6, 2), kind: PaymentKind.depositReceived);
    var c = await Repo.contract(contractId);
    expect(c.c.depositPaid, 20000000);
    expect(c.balance, 0);
    expect((await Repo.payment(id)).pay.receiptNumber, startsWith('C2026-'));
    // Modification puis suppression : la caution suit.
    await PaymentService.save(existing: (await Repo.payment(id)).pay, contractId: contractId,
        kind: PaymentKind.depositReceived, date: DateTime(2026, 6, 2), amount: 10000000, method: 'Espèces');
    c = await Repo.contract(contractId);
    expect(c.c.depositPaid, 15000000);
    await PaymentService.delete((await Repo.payment(id)).pay);
    c = await Repo.contract(contractId);
    expect(c.c.depositPaid, 5000000);
  });

  test('Avance de 250 000 imputée sur les factures successives', () async {
    await pay(25000000, DateTime(2026, 6, 1));
    for (final p in [202606, 202607, 202608]) {
      await BillingService.generateMonth(p);
    }
    final byPeriod = {for (final v in await Repo.invoices(contractId: contractId)) v.inv.period: v};
    final jun = byPeriod[202606]!, jul = byPeriod[202607]!, aug = byPeriod[202608]!;
    expect(jun.alloc.creditBefore, 25000000);
    expect(jun.alloc.applied, 10000000);
    expect(jun.alloc.creditAfter, 15000000);
    expect(jun.status, PayStatus.paid);
    expect(jul.alloc.creditBefore, 15000000);
    expect(jul.alloc.creditAfter, 5000000);
    // Août : 50 000 d'avance restante, 50 000 à payer.
    expect(aug.alloc.creditBefore, 5000000);
    expect(aug.alloc.applied, 5000000);
    expect(aug.status, PayStatus.partial);
    expect(aug.remaining, 5000000);
  });

  test('Seul le versement le plus récent est modifiable', () async {
    final older = await pay(1000000, DateTime(2026, 8, 5));
    final newer = await pay(2000000, DateTime(2026, 8, 20));
    expect(await PaymentService.canEdit((await Repo.payment(older)).pay), isFalse);
    expect(await PaymentService.canEdit((await Repo.payment(newer)).pay), isTrue);
    await PaymentService.delete((await Repo.payment(newer)).pay);
    expect(await PaymentService.canEdit((await Repo.payment(older)).pay), isTrue);
    expect(Period.of(DateTime(2026, 8, 5)), 202608);
  });
}
