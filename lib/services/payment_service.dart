import 'package:drift/drift.dart';

import '../data/database.dart';
import '../data/repo.dart';
import 'app_state.dart';

/// Types de versement (colonne payments.kind).
class PaymentKind {
  static const payment = 0;
  static const depositApplied = 1;
  static const refund = 2;
  static const depositReceived = 3;
}

/// Enregistrement, modification et suppression des versements.
/// Un complément de caution (kind 3) met aussi à jour la caution versée du contrat.
class PaymentService {
  static AppDatabase get db => App.db;

  static String _prefix(int kind) => switch (kind) {
        PaymentKind.refund => 'R',
        PaymentKind.depositReceived => 'C',
        _ => 'Q',
      };

  /// Modifiable / supprimable : le plus récent du contrat, et pas une caution imputée automatiquement.
  static Future<bool> canEdit(Payment p) async =>
      p.kind != PaymentKind.depositApplied && await Repo.lastPaymentId(p.contractId) == p.id;

  static Future<void> _adjustDeposit(int contractId, int delta) async {
    if (delta == 0) return;
    final c = await (db.select(db.contracts)..where((x) => x.id.equals(contractId))).getSingle();
    await (db.update(db.contracts)..where((x) => x.id.equals(contractId)))
        .write(ContractsCompanion(depositPaid: Value(c.depositPaid + delta)));
  }

  /// Crée ou met à jour un versement ; renvoie son id.
  static Future<int> save({
    Payment? existing,
    required int contractId,
    required int kind,
    required DateTime date,
    required int amount,
    required String method,
    String? reference,
    String? note,
  }) =>
      db.transaction(() async {
        final c = PaymentsCompanion(
          contractId: Value(contractId),
          kind: Value(kind),
          date: Value(date),
          amount: Value(amount),
          method: Value(method),
          reference: Value(reference),
          note: Value(note),
        );
        if (existing == null) {
          final number = await Repo.nextReceiptNumber(date, prefix: _prefix(kind));
          final id = await db.into(db.payments).insert(c.copyWith(receiptNumber: Value(number)));
          if (kind == PaymentKind.depositReceived) await _adjustDeposit(contractId, amount);
          return id;
        }
        await (db.update(db.payments)..where((x) => x.id.equals(existing.id))).write(c);
        if (kind == PaymentKind.depositReceived) await _adjustDeposit(contractId, amount - existing.amount);
        return existing.id;
      });

  static Future<void> delete(Payment p) => db.transaction(() async {
        await (db.delete(db.payments)..where((x) => x.id.equals(p.id))).go();
        if (p.kind == PaymentKind.depositReceived) await _adjustDeposit(p.contractId, -p.amount);
      });
}
