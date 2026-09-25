import 'dart:convert';

import '../data/database.dart';
import '../l10n/app_localizations.dart';
import 'billing_calc.dart';
import 'dates.dart';
import 'i18n.dart';
import 'money.dart';

/// Traduction des données saisies ou enregistrées (noms, pièces, états, libellés de facture).
class Labels {
  // ------------------------------------------------------------ noms traduits

  static Map<String, dynamic> _json(String? s) {
    if (s == null || s.isEmpty) return {};
    try {
      return jsonDecode(s) as Map<String, dynamic>;
    } catch (_) {
      return {};
    }
  }

  static String utilityName(UtilityType t, [String? lang]) {
    final v = _json(t.translations)[lang ?? I18n.lang];
    return v is String && v.isNotEmpty ? v : t.name;
  }

  static String serviceName(ServiceType s, [String? lang]) {
    final v = _json(s.translations)[lang ?? I18n.lang];
    return v is Map && (v['name'] as String?)?.isNotEmpty == true ? v['name'] as String : s.name;
  }

  static String serviceUnit(ServiceType s, [String? lang]) {
    final v = _json(s.translations)[lang ?? I18n.lang];
    return v is Map && (v['unit'] as String?)?.isNotEmpty == true ? v['unit'] as String : s.unitLabel;
  }

  // ------------------------------------------------------------ listes fermées

  /// Pièces proposées (valeur enregistrée → libellé traduit).
  static const roomKeys = [
    'Salon', 'Salle à manger', 'Cuisine', 'Chambre 1', 'Chambre 2', 'Chambre 3',
    'Salle de bain', 'WC', 'Couloir', 'Balcon', 'Terrasse', 'Garage', 'Extérieur',
  ];

  static String room(AppLocalizations t, String stored) {
    final m = RegExp(r'^Chambre (\d+)$').firstMatch(stored);
    if (m != null) return t.roomBedroomN(m.group(1)!);
    return switch (stored) {
      'Salon' => t.roomLiving,
      'Salle à manger' => t.roomDining,
      'Cuisine' => t.roomKitchen,
      'Chambre' => t.roomBedroom,
      'Salle de bain' => t.roomBathroom,
      'WC' => t.roomToilet,
      'Couloir' => t.roomHallway,
      'Balcon' => t.roomBalcony,
      'Terrasse' => t.roomTerrace,
      'Garage' => t.roomGarage,
      'Extérieur' => t.roomOutside,
      _ => stored,
    };
  }

  static const conditionKeys = ['Neuf', 'Bon', 'Usé', 'Dégradé', 'Hors service'];

  static String condition(AppLocalizations t, String stored) => switch (stored) {
        'Neuf' => t.condNew,
        'Bon' => t.condGood,
        'Usé' => t.condWorn,
        'Dégradé' => t.condDamaged,
        'Hors service' => t.condBroken,
        _ => stored,
      };

  static const methodKeys = ['Espèces', 'Mobile Money', 'Virement', 'Chèque', 'Autre'];

  static String method(AppLocalizations t, String stored) => switch (stored) {
        'Espèces' => t.methodCash,
        'Mobile Money' => t.methodMobile,
        'Virement' => t.methodTransfer,
        'Chèque' => t.methodCheque,
        'Autre' => t.methodOther,
        'Caution' => t.methodDeposit,
        _ => stored,
      };

  static String vatMode(AppLocalizations t, VatMode m) => switch (m) {
        VatMode.none => t.vatNone,
        VatMode.included => t.vatIncluded,
        VatMode.added => t.vatAdded,
      };

  static String benefitMode(AppLocalizations t, BenefitMode m) => switch (m) {
        BenefitMode.percent => t.benefitModePercent,
        BenefitMode.freeUnits => t.benefitModeUnits,
        BenefitMode.fixedAmount => t.benefitModeAmount,
      };

  static String benefitSummary(AppLocalizations t, int mode, double value, int amount, String unit, [String? lang]) =>
      switch (BenefitMode.values[mode]) {
        BenefitMode.percent => value >= 100 ? t.benefitFull : t.benefitPercent(Num.format(value, lang: lang)),
        BenefitMode.freeUnits => t.benefitUnits(Num.format(value, lang: lang), unit),
        BenefitMode.fixedAmount => t.benefitAmount(Money.format(amount, lang: lang)),
      };
}

/// Noms nécessaires pour traduire des lignes de facture.
class NameBook {
  final Map<int, UtilityType> utilities;
  final Map<int, ServiceType> services;
  NameBook(this.utilities, this.services);

  static Future<NameBook> load(AppDatabase db) async => NameBook(
        {for (final u in await db.select(db.utilityTypes).get()) u.id: u},
        {for (final s in await db.select(db.serviceTypes).get()) s.id: s},
      );
}

/// Libellé et détail d'une ligne de facture dans une langue donnée.
/// Les lignes anciennes (sans données structurées) gardent le texte enregistré.
class LineText {
  final NameBook book;
  final String lang;
  final AppLocalizations t;
  LineText(this.book, this.lang) : t = I18n.of(lang);

  Map<String, dynamic> _meta(InvoiceLine l) => Labels._json(l.meta);

  String label(InvoiceLine l) {
    final m = _meta(l);
    switch (m['t']) {
      case 'rent':
        final base = t.lineRent(Period.label(m['p'] as int, lang));
        return m['d'] == m['n'] ? base : '$base (${t.lineProrata('${m['d']}', '${m['n']}')})';
      case 'svc':
        final s = book.services[m['sid']];
        final name = s == null ? l.label : Labels.serviceName(s, lang);
        return m['d'] == m['n'] ? name : '$name (${t.lineProrata('${m['d']}', '${m['n']}')})';
      case 'util':
        final u = book.utilities[m['uid']];
        return u == null ? l.label : Labels.utilityName(u, lang);
      case 'dmg':
        return t.lineDamages;
      case 'credit':
        return t.lineCredit('${m['days']}');
      case 'ben':
        final target = m['uid'] != null
            ? (book.utilities[m['uid']] == null ? '' : Labels.utilityName(book.utilities[m['uid']]!, lang))
            : (book.services[m['sid']] == null ? '' : Labels.serviceName(book.services[m['sid']]!, lang));
        final reason = m['r'] as String?;
        return '${t.lineBenefit(target)}${reason == null ? '' : ' – $reason'}';
      default:
        return l.label;
    }
  }

  String? details(InvoiceLine l) {
    final m = _meta(l);
    switch (m['t']) {
      case 'svc':
        final s = book.services[m['sid']];
        final unit = s == null ? '' : Labels.serviceUnit(s, lang);
        return (m['i'] as int) > 0
            ? t.lineServiceIncluded('${m['q']}', unit, '${m['i']}', '${m['b']}')
            : (m['b'] as int) > 1
                ? t.lineServiceQty('${m['b']}', unit)
                : null;
      case 'util':
        final u = book.utilities[m['uid']];
        final unit = u?.unit ?? l.unit ?? '';
        final vm = VatMode.values[(m['vm'] as int?) ?? 0];
        final rate = ((m['vr'] as num?) ?? 0).toDouble();
        return [
          t.lineIndex(Num.format(l.startIndex ?? 0, lang: lang), Num.format(l.endIndex ?? 0, lang: lang)),
          t.lineConsumption(Num.format(l.quantity, lang: lang), unit, Money.format(l.unitPrice, lang: lang)),
          if (((m['fee'] as int?) ?? 0) > 0) t.lineMaintenance(Money.format(m['fee'] as int, lang: lang)),
          if (vm != VatMode.none && rate > 0)
            t.lineVat(Num.format(rate, lang: lang), vm == VatMode.included ? t.vatIncludedShort : t.vatAddedShort),
        ].join(' · ');
      case 'ben':
        final u = book.utilities[m['uid']];
        final s = book.services[m['sid']];
        final unit = u?.unit ?? (s == null ? '' : Labels.serviceUnit(s, lang));
        return Labels.benefitSummary(t, m['m'] as int, ((m['v'] as num?) ?? 0).toDouble(), (m['a'] as int?) ?? 0, unit, lang);
      case 'rent' || 'dmg' || 'credit':
        return null;
      default:
        return l.details;
    }
  }
}
