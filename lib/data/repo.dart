import 'package:drift/drift.dart';

import '../core/billing_calc.dart';
import '../core/dates.dart';
import '../services/app_state.dart';
import 'database.dart';

// ---------------------------------------------------------------------------
// Vues composées pour l'interface
// ---------------------------------------------------------------------------

class MeterView {
  final Meter meter;
  final UtilityType type;
  MeterView(this.meter, this.type);

  Tariff get tariff => Repo.tariffOf(type);
}

class ApartmentView {
  final Apartment apt;
  final Building building;
  final Owner owner;
  final Contract? contract;
  final Tenant? tenant;
  final List<MeterView> meters;
  ApartmentView(this.apt, this.building, this.owner, this.contract, this.tenant,
      this.meters);

  bool get occupied => contract != null;
  String get fullName => '${building.name} · ${apt.name}';
}

class ContractView {
  final Contract c;
  final Tenant tenant;
  final Apartment apt;
  final Building building;
  final int balance;
  ContractView(this.c, this.tenant, this.apt, this.building, this.balance);

  bool get active => c.status == 0;
  String get place => '${building.name} · ${apt.name}';
}

/// Statut de paiement (libellés traduits dans l'interface).
enum PayStatus { paid, partial, unpaid }

/// Affectation des paiements à une facture (ordre chronologique des factures).
class Allocation {
  final PayStatus status;
  final int remaining;

  /// Paiements / avance disponibles avant cette facture.
  final int creditBefore;

  /// Part de cette facture couverte par ces paiements.
  final int applied;
  const Allocation(this.status, this.remaining, this.creditBefore, this.applied);

  /// Avance restante après imputation de cette facture.
  int get creditAfter => creditBefore - applied;

  /// Utile à afficher : avance qui déborde sur la facture suivante, ou facture payée en partie.
  bool get showSettlement => creditBefore > 0 && (creditAfter > 0 || status == PayStatus.partial);
}

class InvoiceView {
  final Invoice inv;
  final ContractView cv;
  final Allocation alloc;
  final bool locked;
  InvoiceView(this.inv, this.cv, this.alloc, this.locked);

  PayStatus get status => alloc.status;
  int get remaining => alloc.remaining;

  bool get overdue =>
      status != PayStatus.paid && inv.dueDate.isBefore(DateTime.now());
}

class PaymentView {
  final Payment pay;
  final ContractView cv;
  PaymentView(this.pay, this.cv);
}

// ---------------------------------------------------------------------------
// Requêtes
// ---------------------------------------------------------------------------

class Repo {
  static AppDatabase get db => App.db;

  static Tariff tariffOf(UtilityType t) => Tariff(
        unitPrice: t.unitPrice,
        fixedFee: t.fixedFee,
        vatRate: t.vatRate,
        vatMode: VatMode.values[t.vatMode],
        vatOnFixedFee: t.vatOnFixedFee,
      );

  static Future<List<ApartmentView>> apartments(
      {bool includeArchived = false, int? ownerId, int? buildingId}) async {
    final q = db.select(db.apartments).join([
      innerJoin(db.buildings, db.buildings.id.equalsExp(db.apartments.buildingId)),
      innerJoin(db.owners, db.owners.id.equalsExp(db.buildings.ownerId)),
    ]);
    if (!includeArchived) q.where(db.apartments.archived.equals(false));
    if (ownerId != null) q.where(db.owners.id.equals(ownerId));
    if (buildingId != null) q.where(db.buildings.id.equals(buildingId));
    q.orderBy([OrderingTerm.asc(db.buildings.name), OrderingTerm.asc(db.apartments.name)]);
    final rows = await q.get();

    final active = await (db.select(db.contracts)..where((c) => c.status.equals(0))).get();
    final tenants = {for (final t in await db.select(db.tenants).get()) t.id: t};
    final meters = await activeMeters();

    return rows.map((r) {
      final a = r.readTable(db.apartments);
      final c = active.where((c) => c.apartmentId == a.id).firstOrNull;
      return ApartmentView(
        a,
        r.readTable(db.buildings),
        r.readTable(db.owners),
        c,
        c == null ? null : tenants[c.tenantId],
        meters.where((m) => m.meter.apartmentId == a.id).toList(),
      );
    }).toList();
  }

  static Future<ApartmentView> apartment(int id) async {
    final all = await apartments(includeArchived: true);
    return all.firstWhere((a) => a.apt.id == id);
  }

  static Future<List<MeterView>> activeMeters({int? apartmentId}) async {
    final q = db.select(db.meters).join([
      innerJoin(db.utilityTypes, db.utilityTypes.id.equalsExp(db.meters.utilityTypeId)),
    ])
      ..where(db.meters.active.equals(true));
    if (apartmentId != null) q.where(db.meters.apartmentId.equals(apartmentId));
    q.orderBy([OrderingTerm.asc(db.utilityTypes.id)]);
    final rows = await q.get();
    return rows
        .map((r) => MeterView(r.readTable(db.meters), r.readTable(db.utilityTypes)))
        .toList();
  }

  /// Solde de chaque contrat : factures − paiements − caution imputée + remboursements.
  static Future<Map<int, int>> balances() async {
    final out = <int, int>{};
    final inv = await db.customSelect(
      'SELECT contract_id AS c, SUM(total) AS s FROM invoices GROUP BY contract_id',
      readsFrom: {db.invoices},
    ).get();
    for (final r in inv) {
      out[r.read<int>('c')] = r.read<int>('s');
    }
    final pay = await db.customSelect(
      'SELECT contract_id AS c, SUM(CASE WHEN kind = 2 THEN -amount WHEN kind = 3 THEN 0 ELSE amount END) AS s '
      'FROM payments GROUP BY contract_id',
      readsFrom: {db.payments},
    ).get();
    for (final r in pay) {
      final c = r.read<int>('c');
      out[c] = (out[c] ?? 0) - r.read<int>('s');
    }
    return out;
  }

  static Future<List<ContractView>> contracts({int? status, int? apartmentId, int? tenantId}) async {
    final q = db.select(db.contracts).join([
      innerJoin(db.tenants, db.tenants.id.equalsExp(db.contracts.tenantId)),
      innerJoin(db.apartments, db.apartments.id.equalsExp(db.contracts.apartmentId)),
      innerJoin(db.buildings, db.buildings.id.equalsExp(db.apartments.buildingId)),
    ]);
    if (status != null) q.where(db.contracts.status.equals(status));
    if (apartmentId != null) q.where(db.contracts.apartmentId.equals(apartmentId));
    if (tenantId != null) q.where(db.contracts.tenantId.equals(tenantId));
    q.orderBy([OrderingTerm.desc(db.contracts.startDate)]);
    final rows = await q.get();
    final bal = await balances();
    return rows.map((r) {
      final c = r.readTable(db.contracts);
      return ContractView(c, r.readTable(db.tenants), r.readTable(db.apartments),
          r.readTable(db.buildings), bal[c.id] ?? 0);
    }).toList();
  }

  static Future<ContractView> contract(int id) async {
    final q = db.select(db.contracts).join([
      innerJoin(db.tenants, db.tenants.id.equalsExp(db.contracts.tenantId)),
      innerJoin(db.apartments, db.apartments.id.equalsExp(db.contracts.apartmentId)),
      innerJoin(db.buildings, db.buildings.id.equalsExp(db.apartments.buildingId)),
    ])
      ..where(db.contracts.id.equals(id));
    final r = await q.getSingle();
    final bal = await balances();
    return ContractView(r.readTable(db.contracts), r.readTable(db.tenants),
        r.readTable(db.apartments), r.readTable(db.buildings), bal[id] ?? 0);
  }

  /// Affecte les paiements aux factures les plus anciennes (FIFO).
  static Map<int, Allocation> allocate(List<Invoice> invoices, int credit) {
    final sorted = [...invoices]
      ..sort((a, b) {
        final c = a.period.compareTo(b.period);
        return c != 0 ? c : a.kind.compareTo(b.kind);
      });
    final out = <int, Allocation>{};
    var left = credit;
    for (final i in sorted) {
      final before = left < 0 ? 0 : left;
      if (i.total <= 0) {
        left -= i.total;
        out[i.id] = Allocation(PayStatus.paid, 0, before, 0);
      } else if (left >= i.total) {
        out[i.id] = Allocation(PayStatus.paid, 0, before, i.total);
        left -= i.total;
      } else if (left > 0) {
        out[i.id] = Allocation(PayStatus.partial, i.total - left, before, left);
        left = 0;
      } else {
        out[i.id] = Allocation(PayStatus.unpaid, i.total, 0, 0);
      }
    }
    return out;
  }

  static Future<int> credit(int contractId) async {
    final r = await db.customSelect(
      'SELECT COALESCE(SUM(CASE WHEN kind = 2 THEN -amount WHEN kind = 3 THEN 0 ELSE amount END), 0) AS s '
      'FROM payments WHERE contract_id = ?',
      variables: [Variable.withInt(contractId)],
      readsFrom: {db.payments},
    ).getSingle();
    return r.read<int>('s');
  }

  static Future<List<InvoiceView>> invoices({int? period, int? contractId, int? from, int? to}) async {
    final q = db.select(db.invoices);
    if (period != null) q.where((i) => i.period.equals(period));
    if (contractId != null) q.where((i) => i.contractId.equals(contractId));
    if (from != null) q.where((i) => i.period.isBiggerOrEqualValue(from));
    if (to != null) q.where((i) => i.period.isSmallerOrEqualValue(to));
    q.orderBy([(i) => OrderingTerm.desc(i.period), (i) => OrderingTerm.asc(i.number)]);
    final list = await q.get();
    if (list.isEmpty) return [];

    final contractIds = list.map((i) => i.contractId).toSet();
    final cvs = {for (final c in await contracts()) c.c.id: c};
    final result = <InvoiceView>[];
    for (final cid in contractIds) {
      final all = await (db.select(db.invoices)..where((i) => i.contractId.equals(cid))).get();
      final alloc = allocate(all, await credit(cid));
      final maxPeriod = all.where((i) => i.kind == 0).fold<int>(0, (m, i) => i.period > m ? i.period : m);
      final cv = cvs[cid]!;
      for (final inv in list.where((i) => i.contractId == cid)) {
        final locked = inv.kind == 1 || !cv.active || inv.period < maxPeriod;
        result.add(InvoiceView(inv, cv, alloc[inv.id]!, locked));
      }
    }
    result.sort((a, b) {
      final c = b.inv.period.compareTo(a.inv.period);
      return c != 0 ? c : a.cv.place.compareTo(b.cv.place);
    });
    return result;
  }

  static Future<InvoiceView> invoice(int id) async {
    final inv = await (db.select(db.invoices)..where((i) => i.id.equals(id))).getSingle();
    final list = await invoices(contractId: inv.contractId);
    return list.firstWhere((v) => v.inv.id == id);
  }

  static Future<List<InvoiceLine>> lines(int invoiceId) =>
      (db.select(db.invoiceLines)
            ..where((l) => l.invoiceId.equals(invoiceId))
            ..orderBy([(l) => OrderingTerm.asc(l.position)]))
          .get();

  static Future<List<PaymentView>> payments({int? contractId, DateTime? from, DateTime? to}) async {
    final q = db.select(db.payments);
    if (contractId != null) q.where((p) => p.contractId.equals(contractId));
    if (from != null) q.where((p) => p.date.isBiggerOrEqualValue(from));
    if (to != null) q.where((p) => p.date.isSmallerThanValue(to));
    q.orderBy([(p) => OrderingTerm.desc(p.date), (p) => OrderingTerm.desc(p.id)]);
    final list = await q.get();
    final cvs = {for (final c in await contracts()) c.c.id: c};
    return list.map((p) => PaymentView(p, cvs[p.contractId]!)).toList();
  }

  static Future<PaymentView> payment(int id) async {
    final p = await (db.select(db.payments)..where((x) => x.id.equals(id))).getSingle();
    return PaymentView(p, await contract(p.contractId));
  }

  // ------------------------------------------------------------------ relevés

  static Future<Reading?> monthlyReading(int meterId, int period) =>
      (db.select(db.readings)
            ..where((r) => r.meterId.equals(meterId) & r.period.equals(period) & r.kind.equals(0)))
          .getSingleOrNull();

  /// Dernier index connu avant la période (tout type de relevé), sinon index initial.
  static Future<double> previousIndex(Meter m, int period) async {
    final last = Period.lastDay(period).add(const Duration(days: 1));
    final r = await (db.select(db.readings)
          ..where((r) =>
              r.meterId.equals(m.id) &
              r.date.isSmallerThanValue(last) &
              (r.kind.equals(0) & r.period.isSmallerThanValue(period) | r.kind.isIn([1, 2])))
          ..orderBy([(r) => OrderingTerm.desc(r.date), (r) => OrderingTerm.desc(r.id)])
          ..limit(1))
        .getSingleOrNull();
    return r?.value ?? m.initialIndex;
  }

  /// Consommation moyenne des 3 derniers mois (pour détecter les anomalies).
  static Future<double?> averageConsumption(int meterId, int beforePeriod) async {
    final rs = await (db.select(db.invoiceLines).join([
      innerJoin(db.invoices, db.invoices.id.equalsExp(db.invoiceLines.invoiceId)),
    ])
          ..where(db.invoiceLines.meterId.equals(meterId) &
              db.invoices.period.isSmallerThanValue(beforePeriod) &
              db.invoices.kind.equals(0))
          ..orderBy([OrderingTerm.desc(db.invoices.period)])
          ..limit(3))
        .get();
    if (rs.isEmpty) return null;
    final vals = rs.map((r) => r.readTable(db.invoiceLines).quantity).toList();
    return vals.reduce((a, b) => a + b) / vals.length;
  }

  static Future<bool> readingLocked(int meterId, int period) async {
    final later = await (db.select(db.readings)
          ..where((r) => r.meterId.equals(meterId) & r.kind.equals(0) & r.period.isBiggerThanValue(period))
          ..limit(1))
        .getSingleOrNull();
    return later != null;
  }

  /// Seul le versement le plus récent d'un contrat peut être modifié ou supprimé.
  static Future<int?> lastPaymentId(int contractId) async {
    final p = await (db.select(db.payments)
          ..where((x) => x.contractId.equals(contractId))
          ..orderBy([(x) => OrderingTerm.desc(x.date), (x) => OrderingTerm.desc(x.id)])
          ..limit(1))
        .getSingleOrNull();
    return p?.id;
  }

  static Future<String> nextReceiptNumber(DateTime date, {String prefix = 'Q'}) async {
    final base = '$prefix${date.year}-';
    final rows = await (db.select(db.payments)..where((p) => p.receiptNumber.like('$base%'))).get();
    var max = 0;
    for (final r in rows) {
      final n = int.tryParse(r.receiptNumber.substring(base.length)) ?? 0;
      if (n > max) max = n;
    }
    return '$base${(max + 1).toString().padLeft(4, '0')}';
  }
}
