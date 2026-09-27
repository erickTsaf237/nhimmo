import 'package:drift/drift.dart';

import '../core/dates.dart';
import '../data/database.dart';
import '../data/repo.dart';
import 'app_state.dart';
import 'payment_service.dart';

/// Relevé d'un compteur sur une ligne de la fiche.
class SheetMeter {
  final double? start;
  final double? end;
  final int amount;
  const SheetMeter(this.start, this.end, this.amount);
}

/// Une ligne de la fiche historique = une facture (mois ou sortie).
class SheetRow {
  final Invoice invoice;
  final Map<int, SheetMeter> meters; // par type de compteur
  final int rent;
  final int other; // services, avantages, dégâts, ajustements
  int penalty = 0;
  int paid = 0;
  DateTime? settledOn;
  DateTime? lastPaymentOn;
  SheetRow(this.invoice, this.meters, this.rent, this.other);

  int get expected => invoice.total + penalty;
  int get remaining => expected > paid ? expected - paid : 0;
  bool get settled => remaining == 0;
}

class HistorySheet {
  final ContractView cv;
  final List<UtilityType> types;
  final List<SheetRow> rows;
  final List<ContractRent> rents;
  HistorySheet(this.cv, this.types, this.rows, this.rents);

  /// Construit la fiche d'un contrat : chaque facture reçoit ses pénalités, puis les
  /// paiements sont imputés dans l'ordre chronologique aux montants attendus les plus anciens.
  static Future<HistorySheet> build(int contractId) async {
    final db = App.db;
    final cv = await Repo.contract(contractId);
    final invoices = await (db.select(db.invoices)
          ..where((i) => i.contractId.equals(contractId))
          ..orderBy([(i) => OrderingTerm.asc(i.period), (i) => OrderingTerm.asc(i.kind)]))
        .get();
    final allTypes = {for (final t in await db.select(db.utilityTypes).get()) t.id: t};
    final usedTypes = <int>{};
    final rows = <SheetRow>[];
    for (final inv in invoices) {
      final lines = await Repo.lines(inv.id);
      final meters = <int, SheetMeter>{};
      var rent = 0, utilities = 0;
      for (final l in lines) {
        if (l.kind == 0) rent += l.ttc;
        if (l.kind == 1 && l.utilityTypeId != null) {
          usedTypes.add(l.utilityTypeId!);
          final prev = meters[l.utilityTypeId!];
          meters[l.utilityTypeId!] = SheetMeter(
            prev?.start ?? l.startIndex,
            l.endIndex ?? prev?.end,
            (prev?.amount ?? 0) + l.ttc,
          );
          utilities += l.ttc;
        }
      }
      rows.add(SheetRow(inv, meters, rent, inv.total - rent - utilities));
    }

    final payments = await (db.select(db.payments)
          ..where((p) => p.contractId.equals(contractId))
          ..orderBy([(p) => OrderingTerm.asc(p.date), (p) => OrderingTerm.asc(p.id)]))
        .get();

    // Pénalités : rattachées à la dernière facture dont le mois précède (ou est) celui de la pénalité.
    for (final p in payments.where((p) => p.kind == PaymentKind.penalty)) {
      if (rows.isEmpty) break;
      final pp = Period.of(p.date);
      final target = rows.lastWhere((r) => r.invoice.period <= pp, orElse: () => rows.first);
      target.penalty += p.amount;
    }

    // Paiements (et caution imputée) : du plus ancien au plus récent, sur les montants attendus les plus anciens.
    for (final p in payments.where((p) => p.kind == PaymentKind.payment || p.kind == PaymentKind.depositApplied)) {
      var left = p.amount;
      for (final r in rows) {
        if (left <= 0) break;
        if (r.remaining == 0) continue;
        final take = left < r.remaining ? left : r.remaining;
        r.paid += take;
        r.lastPaymentOn = p.date;
        left -= take;
        if (r.remaining == 0) r.settledOn = p.date;
      }
    }

    final types = allTypes.values.where((t) => usedTypes.contains(t.id)).toList()..sort((a, b) => a.id.compareTo(b.id));
    final rents = await (db.select(db.contractRents)
          ..where((r) => r.contractId.equals(contractId))
          ..orderBy([(r) => OrderingTerm.asc(r.fromPeriod)]))
        .get();
    return HistorySheet(cv, types, rows, rents);
  }
}
