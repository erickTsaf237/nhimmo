import 'dart:math' as math;

import 'dates.dart';

/// Mode de TVA d'un type de compteur (eau, électricité, gaz...).
/// Libellés traduits : voir Labels.vatMode.
enum VatMode { none, included, added }

/// Tarif générique, identique pour tous les fluides.
class Tariff {
  /// Prix d'une unité (m³, kWh...) en centimes.
  final int unitPrice;

  /// Frais fixes mensuels (entretien / location du compteur) en centimes.
  final int fixedFee;
  final double vatRate;
  final VatMode vatMode;
  final bool vatOnFixedFee;

  const Tariff({
    required this.unitPrice,
    this.fixedFee = 0,
    this.vatRate = 0,
    this.vatMode = VatMode.none,
    this.vatOnFixedFee = false,
  });
}

class Charge {
  final int ht;
  final int vat;
  final int ttc;
  const Charge(this.ht, this.vat, this.ttc);
  static const zero = Charge(0, 0, 0);
}

class BillingCalc {
  /// Calcul unique pour eau, électricité, gaz... : consommation × prix + frais, TVA selon le mode.
  static Charge utility(double consumption, Tariff t) {
    final variable = (consumption * t.unitPrice).round();
    final fixed = t.fixedFee;
    final rate = t.vatMode == VatMode.none ? 0.0 : t.vatRate;
    if (rate <= 0) return Charge(variable + fixed, 0, variable + fixed);

    switch (t.vatMode) {
      case VatMode.none:
        return Charge(variable + fixed, 0, variable + fixed);
      case VatMode.added:
        final base = variable + (t.vatOnFixedFee ? fixed : 0);
        final vat = (base * rate / 100).round();
        final ht = variable + fixed;
        return Charge(ht, vat, ht + vat);
      case VatMode.included:
        // Les prix saisis sont TTC : on extrait la TVA.
        final taxed = variable + (t.vatOnFixedFee ? fixed : 0);
        final taxedHt = (taxed / (1 + rate / 100)).round();
        final vat = taxed - taxedHt;
        final ttc = variable + fixed;
        return Charge(ttc - vat, vat, ttc);
    }
  }

  /// Montant pour une partie du mois : jours occupés / jours du mois.
  static int prorata(int monthlyAmount, int days, int daysInMonth) {
    if (days >= daysInMonth) return monthlyAmount;
    if (days <= 0) return 0;
    return (monthlyAmount * days / daysInMonth).round();
  }

  /// Nombre de jours occupés dans la période [p] entre [from] et [to] inclus.
  static int occupiedDays(int p, DateTime from, DateTime? to) {
    final first = Period.firstDay(p);
    final last = Period.lastDay(p);
    final start = from.isAfter(first) ? Dates.dayOnly(from) : first;
    final end = (to != null && to.isBefore(last)) ? Dates.dayOnly(to) : last;
    if (end.isBefore(start)) return 0;
    // En UTC pour ne pas être faussé par les changements d'heure.
    final s = DateTime.utc(start.year, start.month, start.day);
    final e = DateTime.utc(end.year, end.month, end.day);
    return e.difference(s).inDays + 1;
  }

  /// Quantité facturée au-delà de la franchise (ex. véhicules au-delà de la limite autorisée).
  static int billableQuantity(int quantity, int included) =>
      math.max(0, quantity - included);
}

/// Avantage accordé sur une charge (compteur ou service).
/// Libellés traduits : voir Labels.benefitMode.
enum BenefitMode { percent, freeUnits, fixedAmount }

class Benefits {
  /// Montant (positif) à déduire d'une ligne facturée [lineTtc].
  /// Pour [BenefitMode.freeUnits], [consumption] et [tariff] sont nécessaires.
  static int discount(BenefitMode mode, {required int lineTtc, double value = 0, int amount = 0, double? consumption, Tariff? tariff}) {
    if (lineTtc <= 0) return 0;
    int d;
    switch (mode) {
      case BenefitMode.percent:
        d = (lineTtc * value.clamp(0, 100) / 100).round();
      case BenefitMode.freeUnits:
        if (consumption == null || tariff == null) return 0;
        final billed = consumption - value;
        final reduced = BillingCalc.utility(billed < 0 ? 0 : billed, tariff).ttc;
        d = lineTtc - reduced;
      case BenefitMode.fixedAmount:
        d = amount;
    }
    return d.clamp(0, lineTtc);
  }

  static bool activeIn(int period, int? from, int? to) =>
      (from == null || period >= from) && (to == null || period <= to);
}

/// Échéances d'un bail à reconduction tacite.
class LeaseTerm {
  /// Fin de la période en cours à la date [today]. Sans reconduction, reste la fin initiale.
  static DateTime? currentEnd(DateTime start, DateTime? initialEnd, bool tacit, DateTime today) {
    if (initialEnd == null) return null;
    if (!tacit || !today.isAfter(initialEnd)) return initialEnd;
    final months = (initialEnd.year - start.year) * 12 + initialEnd.month - start.month;
    if (months <= 0) return initialEnd;
    var end = initialEnd;
    var k = 1;
    while (!end.isAfter(today)) {
      k++;
      end = DateTime(initialEnd.year, initialEnd.month + months * (k - 1), initialEnd.day);
    }
    return end;
  }

  /// Nombre de reconductions déjà intervenues.
  static int renewals(DateTime start, DateTime? initialEnd, bool tacit, DateTime today) {
    if (initialEnd == null || !tacit || !today.isAfter(initialEnd)) return 0;
    final months = (initialEnd.year - start.year) * 12 + initialEnd.month - start.month;
    if (months <= 0) return 0;
    final end = currentEnd(start, initialEnd, tacit, today)!;
    return ((end.year - initialEnd.year) * 12 + end.month - initialEnd.month) ~/ months;
  }
}
