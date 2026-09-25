import 'package:intl/intl.dart';

import 'i18n.dart';

/// Une période de facturation = un mois, codé yyyymm (ex. 202609).
class Period {
  static int of(DateTime d) => d.year * 100 + d.month;
  static int current() => of(DateTime.now());
  static int year(int p) => p ~/ 100;
  static int month(int p) => p % 100;
  static DateTime firstDay(int p) => DateTime(year(p), month(p), 1);
  static DateTime lastDay(int p) => DateTime(year(p), month(p) + 1, 0);
  static int daysIn(int p) => lastDay(p).day;

  static int add(int p, int months) {
    final d = DateTime(year(p), month(p) + months, 1);
    return of(d);
  }

  static List<int> range(int from, int to) {
    final out = <int>[];
    for (var p = from; p <= to; p = add(p, 1)) {
      out.add(p);
    }
    return out;
  }

  static String label(int p, [String? lang]) {
    final s = DateFormat('MMMM yyyy', lang ?? I18n.lang).format(firstDay(p));
    return s[0].toUpperCase() + s.substring(1);
  }

  /// Mois tel qu'écrit dans une phrase : « août 2026 » (fr), « August 2026 » (en).
  static String inline(int p, [String? lang]) => DateFormat('MMMM yyyy', lang ?? I18n.lang).format(firstDay(p));

  static String short(int p, [String? lang]) {
    final s = DateFormat('MMM yy', lang ?? I18n.lang).format(firstDay(p));
    return s[0].toUpperCase() + s.substring(1);
  }
}

class Dates {
  static String d(DateTime? v, [String? lang]) =>
      v == null ? '—' : DateFormat.yMd(lang ?? I18n.lang).format(v);
  static String long(DateTime? v, [String? lang]) =>
      v == null ? '—' : DateFormat.yMMMMd(lang ?? I18n.lang).format(v);
  static String dt(DateTime? v, [String? lang]) =>
      v == null ? '—' : '${DateFormat.yMd(lang ?? I18n.lang).format(v)} ${DateFormat.Hm(lang ?? I18n.lang).format(v)}';
  static DateTime dayOnly(DateTime v) => DateTime(v.year, v.month, v.day);
}
