import 'package:intl/intl.dart';

import 'i18n.dart';

/// Montants stockés en centimes (entiers) pour éviter toute erreur d'arrondi.
/// La devise est un simple libellé d'affichage configurable (FCFA, €, $...).
class Currency {
  final String code;
  final String symbol;
  final bool symbolBefore;

  const Currency(this.code, this.symbol, {this.symbolBefore = false});

  static const presets = <Currency>[
    Currency('XAF', 'FCFA'),
    Currency('XOF', 'FCFA'),
    Currency('EUR', '€'),
    Currency('USD', '\$', symbolBefore: true),
    Currency('GBP', '£', symbolBefore: true),
    Currency('CAD', '\$ CA'),
    Currency('CHF', 'CHF'),
    Currency('MAD', 'DH'),
  ];
}

/// Espaces insécables produits par intl, remplacés par des espaces simples (compatibles PDF).
final _nbsp = RegExp('[  ]');

class Money {
  static Currency currency = Currency.presets.first;

  /// 123456 -> "1 234,56 FCFA" (fr) / "1,234.56 FCFA" (en). [lang] : langue du document.
  static String format(int cents, {bool withSymbol = true, String? lang}) {
    final number = _number(cents / 100, '#,##0.00', lang);
    if (!withSymbol) return number;
    return currency.symbolBefore ? '${currency.symbol} $number' : '$number ${currency.symbol}';
  }

  /// Format compact pour les tableaux de bord : 1,2 M / 350 k.
  static String compact(int cents, {String? lang}) {
    final v = cents / 100;
    final a = v.abs();
    String n;
    if (a >= 1e9) {
      n = '${_number(v / 1e9, '#,##0.#', lang)} Md';
    } else if (a >= 1e6) {
      n = '${_number(v / 1e6, '#,##0.#', lang)} M';
    } else if (a >= 1e4) {
      n = '${_number(v / 1e3, '#,##0.#', lang)} k';
    } else {
      n = format(cents, withSymbol: false, lang: lang);
    }
    return currency.symbolBefore ? '${currency.symbol} $n' : '$n ${currency.symbol}';
  }

  static String _number(double v, String pattern, String? lang) =>
      NumberFormat(pattern, lang ?? I18n.lang).format(v).replaceAll(_nbsp, ' ');

  /// Texte saisi -> centimes. Accepte "1 500,5", "1500.50", "1,500.50", "1.500,50".
  static int? parse(String input) {
    final v = Num.parse(input);
    return v == null ? null : (v * 100).round();
  }

  /// Centimes -> texte éditable ("1500,50" en français, "1500.50" en anglais).
  static String toInput(int cents) {
    if (cents % 100 == 0) return (cents ~/ 100).toString();
    return (cents / 100).toStringAsFixed(2).replaceAll('.', Num.decimalSep());
  }
}

/// Index de compteur, taux... : nombre décimal saisi librement.
class Num {
  static double? parse(String input) {
    var s = input.trim().replaceAll(RegExp(r'\s'), '').replaceAll(_nbsp, '');
    if (s.isEmpty) return null;
    final lastComma = s.lastIndexOf(','), lastDot = s.lastIndexOf('.');
    if (lastComma >= 0 && lastDot >= 0) {
      // Les deux présents : le dernier est le séparateur décimal.
      final comma = lastComma > lastDot;
      s = s.replaceAll(comma ? '.' : ',', '');
      if (comma) s = s.replaceAll(',', '.');
    } else {
      s = s.replaceAll(',', '.');
    }
    return double.tryParse(s);
  }

  static String format(double v, {int maxDecimals = 3, String? lang}) =>
      NumberFormat('0.${'#' * maxDecimals}', lang ?? I18n.lang).format(v);

  static String decimalSep([String? lang]) =>
      NumberFormat.decimalPattern(lang ?? I18n.lang).symbols.DECIMAL_SEP;
}
