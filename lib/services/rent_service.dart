import 'package:drift/drift.dart';

import '../data/database.dart';
import 'app_state.dart';

/// Historique des loyers : le loyer d'un mois est le dernier entré en vigueur avant (ou pendant)
/// ce mois. Changer le loyer ne modifie donc jamais la facturation des mois précédents.
class RentService {
  static AppDatabase get db => App.db;

  static Future<List<ContractRent>> history(int contractId) =>
      (db.select(db.contractRents)
            ..where((r) => r.contractId.equals(contractId))
            ..orderBy([(r) => OrderingTerm.asc(r.fromPeriod)]))
          .get();

  /// Loyer d'un contrat pour [period] ; sans historique, le loyer du contrat.
  static Future<int> rentAt(Contract c, int period) async {
    final hist = await history(c.id);
    int? found;
    for (final r in hist) {
      if (r.fromPeriod <= period) found = r.rent;
    }
    return found ?? (hist.isEmpty ? c.rent : hist.first.rent);
  }

  /// Enregistre un loyer à partir de [fromPeriod] (remplace celui du même mois s'il existe)
  /// et recopie le loyer le plus récent dans le contrat.
  static Future<void> save(int contractId, int fromPeriod, int rent) => db.transaction(() async {
        final same = await (db.select(db.contractRents)
              ..where((r) => r.contractId.equals(contractId) & r.fromPeriod.equals(fromPeriod)))
            .getSingleOrNull();
        if (same == null) {
          await db.into(db.contractRents).insert(
              ContractRentsCompanion.insert(contractId: contractId, fromPeriod: fromPeriod, rent: rent));
        } else {
          await (db.update(db.contractRents)..where((r) => r.id.equals(same.id)))
              .write(ContractRentsCompanion(rent: Value(rent)));
        }
        await _sync(contractId);
      });

  static Future<void> delete(ContractRent r) => db.transaction(() async {
        await (db.delete(db.contractRents)..where((x) => x.id.equals(r.id))).go();
        await _sync(r.contractId);
      });

  static Future<void> _sync(int contractId) async {
    final hist = await history(contractId);
    if (hist.isEmpty) return;
    await (db.update(db.contracts)..where((c) => c.id.equals(contractId)))
        .write(ContractsCompanion(rent: Value(hist.last.rent)));
  }
}
