import 'package:flutter_test/flutter_test.dart';
import 'package:myimmo/core/billing_calc.dart';
import 'package:myimmo/core/money.dart';

void main() {
  group('BillingCalc.utility — calcul commun eau / électricité / gaz', () {
    test('sans TVA : consommation × prix + entretien', () {
      final c = BillingCalc.utility(12.5, const Tariff(unitPrice: 50000, fixedFee: 100000));
      expect(c.ht, 12.5 * 50000 + 100000);
      expect(c.vat, 0);
      expect(c.ttc, c.ht);
    });

    test('TVA en sus, hors entretien', () {
      final c = BillingCalc.utility(10, const Tariff(unitPrice: 10000, fixedFee: 5000, vatRate: 19.25, vatMode: VatMode.added));
      expect(c.ht, 105000);
      expect(c.vat, 19250); // 19,25 % de 100 000 seulement
      expect(c.ttc, 124250);
    });

    test('TVA en sus, entretien inclus dans la base', () {
      final c = BillingCalc.utility(10, const Tariff(unitPrice: 10000, fixedFee: 5000, vatRate: 20, vatMode: VatMode.added, vatOnFixedFee: true));
      expect(c.vat, 21000);
      expect(c.ttc, 126000);
    });

    test('TVA incluse dans le prix : le total ne change pas, la TVA est extraite', () {
      final c = BillingCalc.utility(10, const Tariff(unitPrice: 12000, vatRate: 20, vatMode: VatMode.included));
      expect(c.ttc, 120000);
      expect(c.ht, 100000);
      expect(c.vat, 20000);
    });

    test('mode TVA avec un taux nul = pas de TVA', () {
      final c = BillingCalc.utility(3, const Tariff(unitPrice: 1000, vatMode: VatMode.added));
      expect(c.vat, 0);
      expect(c.ttc, 3000);
    });
  });

  group('Prorata', () {
    test('jours occupés dans le mois', () {
      expect(BillingCalc.occupiedDays(202609, DateTime(2026, 9, 16), null), 15);
      expect(BillingCalc.occupiedDays(202609, DateTime(2026, 1, 1), DateTime(2026, 9, 10)), 10);
      expect(BillingCalc.occupiedDays(202603, DateTime(2026, 1, 1), null), 31); // changement d'heure
      expect(BillingCalc.occupiedDays(202609, DateTime(2026, 10, 2), null), 0);
    });

    test('montant au prorata', () {
      expect(BillingCalc.prorata(30000000, 15, 30), 15000000);
      expect(BillingCalc.prorata(30000000, 31, 30), 30000000);
    });

    test('véhicules au-delà de la limite autorisée', () {
      expect(BillingCalc.billableQuantity(3, 1), 2);
      expect(BillingCalc.billableQuantity(1, 2), 0);
    });
  });

  group('Money', () {
    test('format et parse', () {
      Money.currency = const Currency('XAF', 'FCFA');
      expect(Money.format(123456789), '1 234 567,89 FCFA');
      expect(Money.format(-500), '-5,00 FCFA');
      expect(Money.parse('1 500,5'), 150050);
      expect(Money.parse('1500.25'), 150025);
      expect(Money.parse('abc'), isNull);
      Money.currency = const Currency('USD', '\$', symbolBefore: true);
      expect(Money.format(1000), '\$ 10,00');
    });
  });
}
