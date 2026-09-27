import 'package:drift/drift.dart';

import '../core/billing_calc.dart';
import '../data/database.dart';
import 'app_state.dart';

/// Historique des tarifs des compteurs : le tarif d'un mois est le dernier entré en vigueur
/// avant (ou pendant) ce mois. Une facture d'un mois passé utilise donc toujours le tarif de l'époque.
class TariffService {
  static AppDatabase get db => App.db;

  static Tariff toTariff(UtilityTariff r) => Tariff(
        unitPrice: r.unitPrice,
        fixedFee: r.fixedFee,
        vatRate: r.vatRate,
        vatMode: VatMode.values[r.vatMode],
        vatOnFixedFee: r.vatOnFixedFee,
      );

  /// Tarifs d'un type, du plus ancien au plus récent.
  static Future<List<UtilityTariff>> history(int utilityTypeId) =>
      (db.select(db.utilityTariffs)
            ..where((t) => t.utilityTypeId.equals(utilityTypeId))
            ..orderBy([(t) => OrderingTerm.asc(t.fromPeriod)]))
          .get();

  /// Tarif en vigueur pour [period] à partir d'un historique trié.
  static UtilityTariff? pick(List<UtilityTariff> hist, int period) {
    UtilityTariff? found;
    for (final r in hist) {
      if (r.fromPeriod <= period) found = r;
    }
    // Période antérieure au premier tarif : on prend le plus ancien.
    return found ?? (hist.isEmpty ? null : hist.first);
  }

  /// Enregistre un tarif à partir de [fromPeriod] (remplace celui du même mois s'il existe)
  /// et met à jour le « tarif actuel » affiché du type.
  static Future<void> save(int utilityTypeId, int fromPeriod, Tariff t) => db.transaction(() async {
        final c = UtilityTariffsCompanion(
          utilityTypeId: Value(utilityTypeId),
          fromPeriod: Value(fromPeriod),
          unitPrice: Value(t.unitPrice),
          fixedFee: Value(t.fixedFee),
          vatRate: Value(t.vatRate),
          vatMode: Value(t.vatMode.index),
          vatOnFixedFee: Value(t.vatOnFixedFee),
        );
        final same = await (db.select(db.utilityTariffs)
              ..where((x) => x.utilityTypeId.equals(utilityTypeId) & x.fromPeriod.equals(fromPeriod)))
            .getSingleOrNull();
        if (same == null) {
          await db.into(db.utilityTariffs).insert(c);
        } else {
          await (db.update(db.utilityTariffs)..where((x) => x.id.equals(same.id))).write(c);
        }
        await syncCurrent(utilityTypeId);
      });

  static Future<void> delete(UtilityTariff r) => db.transaction(() async {
        await (db.delete(db.utilityTariffs)..where((x) => x.id.equals(r.id))).go();
        await syncCurrent(r.utilityTypeId);
      });

  /// Recopie le tarif le plus récent dans le type (affichage, compatibilité).
  static Future<void> syncCurrent(int utilityTypeId) async {
    final hist = await history(utilityTypeId);
    if (hist.isEmpty) return;
    final last = hist.last;
    await (db.update(db.utilityTypes)..where((x) => x.id.equals(utilityTypeId))).write(UtilityTypesCompanion(
      unitPrice: Value(last.unitPrice),
      fixedFee: Value(last.fixedFee),
      vatRate: Value(last.vatRate),
      vatMode: Value(last.vatMode),
      vatOnFixedFee: Value(last.vatOnFixedFee),
    ));
  }
}

/// Tarifs de tous les types, pour une facturation (évite une requête par ligne).
class TariffBook {
  final Map<int, List<UtilityTariff>> _byType;
  final Map<int, UtilityType> _types;
  TariffBook(this._byType, this._types);

  static Future<TariffBook> load() async {
    final db = App.db;
    final rows = await (db.select(db.utilityTariffs)..orderBy([(t) => OrderingTerm.asc(t.fromPeriod)])).get();
    final map = <int, List<UtilityTariff>>{};
    for (final r in rows) {
      map.putIfAbsent(r.utilityTypeId, () => []).add(r);
    }
    return TariffBook(map, {for (final t in await db.select(db.utilityTypes).get()) t.id: t});
  }

  /// Tarif d'un type pour un mois ; sans historique, le tarif enregistré sur le type.
  Tariff at(int utilityTypeId, int period) {
    final r = TariffService.pick(_byType[utilityTypeId] ?? const [], period);
    if (r != null) return TariffService.toTariff(r);
    final t = _types[utilityTypeId]!;
    return Tariff(
      unitPrice: t.unitPrice,
      fixedFee: t.fixedFee,
      vatRate: t.vatRate,
      vatMode: VatMode.values[t.vatMode],
      vatOnFixedFee: t.vatOnFixedFee,
    );
  }
}
