/// Imputation de l'avance du locataire (argent versé en plus de ce qui est dû).
///
/// - [AdvanceMode.all] : l'avance règle les factures suivantes en entier (loyer et charges) ;
/// - [AdvanceMode.rentOnly] : l'avance ne règle que le loyer des factures suivantes ;
///   les charges (consommations, services, pénalités…) restent dues jusqu'au prochain paiement.
enum AdvanceMode { all, rentOnly }

/// Une dette : facture (loyer + charges) ou pénalité (charges seules).
class DebtItem {
  final Object key;
  final DateTime date;
  final int rent;
  final int charges;
  DebtItem(this.key, this.date, {required int total, int rent = 0})
      : rent = total <= 0 ? 0 : rent.clamp(0, total),
        charges = total <= 0 ? total : total - rent.clamp(0, total);

  int get total => rent + charges;
}

/// Un mouvement d'argent : encaissement (> 0) ou remboursement au locataire (< 0).
class MoneyEvent {
  final DateTime date;
  final int amount;
  const MoneyEvent(this.date, this.amount);
}

/// Situation d'une dette après imputation.
class DebtState {
  final DebtItem item;
  int remainingRent;
  int remainingCharges;

  /// Avance disponible au moment de la facture, et part de la facture qu'elle a réglée.
  int creditBefore = 0;
  int applied = 0;
  DateTime? settledOn;
  DateTime? lastPaidOn;

  DebtState(this.item)
      : remainingRent = item.rent,
        remainingCharges = item.charges < 0 ? 0 : item.charges;

  int get remaining => remainingRent + remainingCharges;
  int get paid => (item.total < 0 ? 0 : item.total) - remaining;

  /// Règle [amount] (loyer d'abord) ; renvoie la somme réellement imputée.
  int pay(int amount, DateTime date, {bool rentOnly = false}) {
    var left = amount;
    final r = left < remainingRent ? left : remainingRent;
    remainingRent -= r;
    left -= r;
    if (!rentOnly) {
      final c = left < remainingCharges ? left : remainingCharges;
      remainingCharges -= c;
      left -= c;
    }
    final used = amount - left;
    if (used > 0) lastPaidOn = date;
    if (remaining == 0 && used > 0) settledOn = date;
    return used;
  }
}

class AdvanceLedger {
  final List<DebtState> debts;

  /// Avance encore disponible (argent versé non imputé).
  final int advance;
  AdvanceLedger(this.debts, this.advance);

  /// Reste dû sur l'ensemble des dettes.
  int get due => debts.fold(0, (s, d) => s + d.remaining);
  DebtState? of(Object key) => debts.where((d) => d.item.key == key).firstOrNull;

  /// Parcourt dettes et paiements dans l'ordre des dates (à date égale, la dette d'abord :
  /// un paiement du jour règle la facture du jour).
  static AdvanceLedger run(List<DebtItem> items, List<MoneyEvent> money, AdvanceMode mode) {
    DateTime day(DateTime d) => DateTime(d.year, d.month, d.day);
    final events = <(DateTime, int, int, Object)>[
      for (var i = 0; i < items.length; i++) (day(items[i].date), 0, i, items[i]),
      for (var i = 0; i < money.length; i++) (day(money[i].date), 1, i, money[i]),
    ]..sort((a, b) {
        final c = a.$1.compareTo(b.$1);
        if (c != 0) return c;
        final k = a.$2.compareTo(b.$2);
        return k != 0 ? k : a.$3.compareTo(b.$3);
      });

    final debts = <DebtState>[];
    var pool = 0;
    for (final (date, _, _, e) in events) {
      if (e is DebtItem) {
        final s = DebtState(e);
        debts.add(s);
        if (e.total < 0) {
          pool -= e.total; // avoir : s'ajoute à l'avance
          continue;
        }
        s.creditBefore = pool;
        if (pool > 0) {
          s.applied = s.pay(pool, date, rentOnly: mode == AdvanceMode.rentOnly);
          pool -= s.applied;
        }
        if (e.total == 0) s.settledOn = date;
      } else if (e is MoneyEvent) {
        if (e.amount >= 0) {
          var left = e.amount;
          for (final d in debts) {
            if (left <= 0) break;
            if (d.remaining > 0) left -= d.pay(left, date);
          }
          pool += left;
        } else {
          // Remboursement : pris sur l'avance ; au-delà, le locataire doit le trop-remboursé.
          pool += e.amount;
          if (pool < 0) {
            final s = DebtState(DebtItem(e, date, total: -pool));
            debts.add(s);
            pool = 0;
          }
        }
      }
    }
    return AdvanceLedger(debts, pool);
  }
}
