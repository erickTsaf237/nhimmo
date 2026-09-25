import 'dart:convert';

import 'package:drift/drift.dart';

import '../core/billing_calc.dart';
import '../core/dates.dart';
import '../core/i18n.dart';
import '../core/labels.dart';
import '../data/database.dart';
import '../data/repo.dart';
import 'app_state.dart';

/// Ligne de facture avant enregistrement.
class LineDraft {
  final int kind;

  /// Libellés dans la langue de l'app (repli) ; les documents les reconstruisent depuis [meta].
  String label;
  String? details;
  final double quantity;
  final String? unit;
  final int unitPrice;
  final int ht;
  final int vat;
  final int ttc;
  final int? meterId;
  final int? utilityTypeId;
  final double? startIndex;
  final double? endIndex;

  /// Non enregistré : sert à retrouver les avantages applicables à un service.
  final int? serviceTypeId;

  /// Données structurées pour traduire la ligne (voir LineText).
  final Map<String, Object?>? meta;

  LineDraft({
    required this.kind,
    required this.label,
    this.details,
    this.quantity = 1,
    this.unit,
    this.unitPrice = 0,
    required this.ht,
    this.vat = 0,
    required this.ttc,
    this.meterId,
    this.utilityTypeId,
    this.startIndex,
    this.endIndex,
    this.serviceTypeId,
    this.meta,
  });

  InvoiceLine toLine() => InvoiceLine(
        id: 0, invoiceId: 0, position: 0, kind: kind, label: label, details: details,
        quantity: quantity, unit: unit, unitPrice: unitPrice, ht: ht, vat: vat, ttc: ttc,
        meterId: meterId, utilityTypeId: utilityTypeId, startIndex: startIndex, endIndex: endIndex,
        meta: meta == null ? null : jsonEncode(meta));

  InvoiceLinesCompanion toCompanion(int invoiceId, int position) =>
      InvoiceLinesCompanion.insert(
        invoiceId: invoiceId,
        position: Value(position),
        kind: kind,
        label: label,
        details: Value(details),
        quantity: Value(quantity),
        unit: Value(unit),
        unitPrice: Value(unitPrice),
        ht: ht,
        vat: Value(vat),
        ttc: ttc,
        meterId: Value(meterId),
        utilityTypeId: Value(utilityTypeId),
        startIndex: Value(startIndex),
        endIndex: Value(endIndex),
        meta: Value(meta == null ? null : jsonEncode(meta)),
      );
}

class GenerationReport {
  int created = 0;
  int updated = 0;
  int locked = 0;
  final warnings = <String>[];
}

class ExitInput {
  final DateTime exitDate;
  final bool prorata;
  final Map<int, double> exitIndexes;
  final Map<int, String?> exitPhotos;
  final int damages;
  final String? notes;

  ExitInput({
    required this.exitDate,
    required this.prorata,
    required this.exitIndexes,
    this.exitPhotos = const {},
    required this.damages,
    this.notes,
  });
}

class ExitPreview {
  final List<LineDraft> lines;
  final int previousBalance;
  final int depositPaid;
  final List<String> warnings;
  ExitPreview(this.lines, this.previousBalance, this.depositPaid, this.warnings);

  int get exitTotal => lines.fold(0, (s, l) => s + l.ttc);

  /// > 0 : le locataire doit payer ; < 0 : à lui rembourser.
  int get finalBalance => previousBalance + exitTotal - depositPaid;
}

class BillingService {
  static AppDatabase get db => App.db;

  static String _monthlyNumber(int period, int contractId) =>
      'F$period-${contractId.toString().padLeft(3, '0')}';

  static String _exitNumber(int period, int contractId) =>
      'S$period-${contractId.toString().padLeft(3, '0')}';

  static DateTime dueDateFor(int period) {
    final day = App.settings.dueDay.clamp(1, Period.daysIn(period));
    return DateTime(Period.year(period), Period.month(period), day);
  }

  /// Index de départ d'un compteur pour un contrat : dernière facture, sinon
  /// relevé d'entrée, sinon dernier index connu avant l'entrée, sinon index initial.
  static Future<double> startIndex(Contract c, Meter m, {int? beforePeriod}) async {
    final q = db.select(db.invoiceLines).join([
      innerJoin(db.invoices, db.invoices.id.equalsExp(db.invoiceLines.invoiceId)),
    ])
      ..where(db.invoices.contractId.equals(c.id) &
          db.invoiceLines.meterId.equals(m.id) &
          db.invoiceLines.endIndex.isNotNull());
    if (beforePeriod != null) q.where(db.invoices.period.isSmallerThanValue(beforePeriod));
    q
      ..orderBy([OrderingTerm.desc(db.invoices.period)])
      ..limit(1);
    final last = await q.getSingleOrNull();
    if (last != null) return last.readTable(db.invoiceLines).endIndex!;

    final entry = await (db.select(db.readings)
          ..where((r) => r.meterId.equals(m.id) & r.contractId.equals(c.id) & r.kind.equals(1))
          ..limit(1))
        .getSingleOrNull();
    if (entry != null) return entry.value;

    final before = await (db.select(db.readings)
          ..where((r) =>
              r.meterId.equals(m.id) &
              r.date.isSmallerOrEqualValue(c.startDate.add(const Duration(days: 1))))
          ..orderBy([(r) => OrderingTerm.desc(r.date)])
          ..limit(1))
        .getSingleOrNull();
    return before?.value ?? m.initialIndex;
  }

  static LineDraft utilityLine(MeterView mv, double start, double end) {
    final t = mv.type;
    final cons = end - start;
    final charge = BillingCalc.utility(cons < 0 ? 0 : cons, mv.tariff);
    return LineDraft(
      kind: 1,
      label: t.name,
      quantity: cons,
      unit: t.unit,
      unitPrice: t.unitPrice,
      ht: charge.ht,
      vat: charge.vat,
      ttc: charge.ttc,
      meterId: mv.meter.id,
      utilityTypeId: t.id,
      startIndex: start,
      endIndex: end,
      meta: {'t': 'util', 'uid': t.id, 'fee': t.fixedFee, 'vr': t.vatRate, 'vm': t.vatMode},
    );
  }

  /// Libellés des lignes dans la langue de l'application.
  static Future<List<LineDraft>> localize(List<LineDraft> lines) async {
    final text = LineText(await NameBook.load(db), I18n.lang);
    for (final l in lines) {
      final line = l.toLine();
      l.label = text.label(line);
      l.details = text.details(line);
    }
    return lines;
  }

  static Future<List<(ContractService, ServiceType)>> contractServices(int contractId) async {
    final rows = await (db.select(db.contractServices).join([
      innerJoin(db.serviceTypes, db.serviceTypes.id.equalsExp(db.contractServices.serviceTypeId)),
    ])
          ..where(db.contractServices.contractId.equals(contractId)))
        .get();
    return rows
        .map((r) => (r.readTable(db.contractServices), r.readTable(db.serviceTypes)))
        .toList();
  }

  static Future<List<ContractBenefit>> benefits(int contractId) =>
      (db.select(db.contractBenefits)..where((b) => b.contractId.equals(contractId))).get();

  /// Ajoute après chaque charge concernée une ligne négative « Avantage ».
  static Future<List<LineDraft>> applyBenefits(Contract c, int period, List<LineDraft> lines) async {
    final list = (await benefits(c.id)).where((b) => Benefits.activeIn(period, b.fromPeriod, b.toPeriod)).toList();
    if (list.isEmpty) return lines;
    final tariffs = {for (final t in await db.select(db.utilityTypes).get()) t.id: Repo.tariffOf(t)};
    final out = <LineDraft>[];
    for (final l in lines) {
      out.add(l);
      if (l.kind != 1 && l.kind != 2) continue;
      var remaining = l.ttc;
      for (final b in list) {
        final match = l.kind == 1 ? b.utilityTypeId != null && b.utilityTypeId == l.utilityTypeId : b.serviceTypeId != null && b.serviceTypeId == l.serviceTypeId;
        if (!match || remaining <= 0) continue;
        final mode = BenefitMode.values[b.mode];
        final t = l.utilityTypeId == null ? null : tariffs[l.utilityTypeId];
        final d = Benefits.discount(mode,
            lineTtc: remaining, value: b.value, amount: b.amount,
            consumption: l.kind == 1 ? l.quantity : null, tariff: t);
        if (d <= 0) continue;
        remaining -= d;
        final vat = l.ttc == 0 ? 0 : (l.vat * d / l.ttc).round();
        out.add(LineDraft(
          kind: 5,
          label: '',
          ht: -(d - vat),
          vat: -vat,
          ttc: -d,
          utilityTypeId: l.utilityTypeId,
          meta: {
            't': 'ben', 'uid': b.utilityTypeId, 'sid': b.serviceTypeId,
            'm': b.mode, 'v': b.value, 'a': b.amount, 'r': b.reason,
          },
        ));
      }
    }
    return out;
  }

  /// Loyer + services pour un mois donné, avec prorata éventuel.
  static Future<List<LineDraft>> rentAndServices(
      Contract c, int period, int days, bool prorata) async {
    final dim = Period.daysIn(period);
    final full = days >= dim || !prorata;
    final d = full ? dim : days;
    final rent = full ? c.rent : BillingCalc.prorata(c.rent, days, dim);
    final out = <LineDraft>[
      LineDraft(
        kind: 0,
        label: '',
        unitPrice: c.rent,
        ht: rent,
        ttc: rent,
        meta: {'t': 'rent', 'p': period, 'd': d, 'n': dim},
      ),
    ];
    for (final (cs, st) in await contractServices(c.id)) {
      final qty = BillingCalc.billableQuantity(cs.quantity, cs.includedQuantity);
      if (qty == 0) continue;
      final monthly = qty * cs.unitPrice;
      final amount = full ? monthly : BillingCalc.prorata(monthly, days, dim);
      out.add(LineDraft(
        kind: 2,
        label: st.name,
        quantity: qty.toDouble(),
        unit: st.unitLabel,
        unitPrice: cs.unitPrice,
        ht: amount,
        ttc: amount,
        serviceTypeId: st.id,
        meta: {'t': 'svc', 'sid': st.id, 'q': cs.quantity, 'i': cs.includedQuantity, 'b': qty, 'd': d, 'n': dim},
      ));
    }
    return out;
  }

  /// Génère (ou régénère si non verrouillées) les factures du mois pour tous les contrats actifs.
  static Future<GenerationReport> generateMonth(int period) async {
    final report = GenerationReport();
    final active = await Repo.contracts(status: 0);
    for (final cv in active) {
      final c = cv.c;
      if (Period.of(c.startDate) > period) continue;

      final existing = await (db.select(db.invoices)
            ..where((i) => i.contractId.equals(c.id) & i.period.equals(period) & i.kind.equals(0)))
          .getSingleOrNull();
      if (existing != null) {
        final later = await (db.select(db.invoices)
              ..where((i) => i.contractId.equals(c.id) & i.period.isBiggerThanValue(period))
              ..limit(1))
            .getSingleOrNull();
        if (later != null) {
          report.locked++;
          continue;
        }
      }

      final days = BillingCalc.occupiedDays(period, c.startDate, null);
      final isEntryMonth = Period.of(c.startDate) == period;
      final lines = await rentAndServices(c, period, days, isEntryMonth && c.entryProrata);

      for (final mv in await Repo.activeMeters(apartmentId: c.apartmentId)) {
        final r = await Repo.monthlyReading(mv.meter.id, period);
        if (r == null) {
          report.warnings.add(I18n.ui.warnMissingReading(cv.place, Labels.utilityName(mv.type)));
          continue;
        }
        final start = await startIndex(c, mv.meter, beforePeriod: period);
        if (r.value < start) {
          report.warnings.add(I18n.ui.warnIndexLower(cv.place, Labels.utilityName(mv.type)));
        }
        lines.add(utilityLine(mv, start, r.value));
      }

      final billed = await localize(await applyBenefits(c, period, lines));
      final total = billed.fold<int>(0, (s, l) => s + l.ttc);
      await db.transaction(() async {
        int invoiceId;
        if (existing != null) {
          invoiceId = existing.id;
          await (db.delete(db.invoiceLines)..where((l) => l.invoiceId.equals(invoiceId))).go();
          await (db.update(db.invoices)..where((i) => i.id.equals(invoiceId))).write(
              InvoicesCompanion(total: Value(total), issueDate: Value(DateTime.now())));
          report.updated++;
        } else {
          invoiceId = await db.into(db.invoices).insert(InvoicesCompanion.insert(
                number: _monthlyNumber(period, c.id),
                contractId: c.id,
                period: period,
                issueDate: DateTime.now(),
                dueDate: dueDateFor(period),
                total: total,
              ));
          report.created++;
        }
        for (var i = 0; i < billed.length; i++) {
          await db.into(db.invoiceLines).insert(billed[i].toCompanion(invoiceId, i));
        }
      });
    }
    return report;
  }

  static Future<void> deleteInvoice(int invoiceId) => db.transaction(() async {
        await (db.delete(db.invoiceLines)..where((l) => l.invoiceId.equals(invoiceId))).go();
        await (db.delete(db.invoices)..where((i) => i.id.equals(invoiceId))).go();
      });

  // --------------------------------------------------------------- sortie

  static Future<ExitPreview> previewExit(Contract c, ExitInput input) async {
    final warnings = <String>[];
    final lines = <LineDraft>[];
    final exitPeriod = Period.of(input.exitDate);

    final monthly = await (db.select(db.invoices)
          ..where((i) => i.contractId.equals(c.id) & i.kind.equals(0)))
        .get();
    final billed = monthly.map((i) => i.period).toSet();
    final startPeriod = Period.of(c.startDate);
    final lastBilled = billed.isEmpty ? null : billed.reduce((a, b) => a > b ? a : b);

    // Mois non encore facturés avant le mois de sortie.
    final from = lastBilled == null ? startPeriod : Period.add(lastBilled, 1);
    for (var p = from; p < exitPeriod; p = Period.add(p, 1)) {
      final days = BillingCalc.occupiedDays(p, c.startDate, null);
      lines.addAll(await applyBenefits(c, p, await rentAndServices(c, p, days, p == startPeriod && c.entryProrata)));
    }

    // Mois de sortie.
    final days = BillingCalc.occupiedDays(exitPeriod, c.startDate, input.exitDate);
    final dim = Period.daysIn(exitPeriod);
    if (billed.contains(exitPeriod)) {
      if (input.prorata && days < dim) {
        // Le mois a déjà été facturé en entier : on rembourse les jours non occupés.
        int sum(List<LineDraft> l) => l.fold(0, (s, x) => s + x.ttc);
        final paid = sum(await applyBenefits(c, exitPeriod, await rentAndServices(c, exitPeriod, dim, false)));
        final due = sum(await applyBenefits(c, exitPeriod, await rentAndServices(c, exitPeriod, days, true)));
        final credit = due - paid;
        if (credit != 0) {
          lines.add(LineDraft(
            kind: 4,
            label: '',
            ht: credit,
            ttc: credit,
            meta: {'t': 'credit', 'days': dim - days},
          ));
        }
      }
    } else if (exitPeriod >= startPeriod) {
      lines.addAll(await applyBenefits(c, exitPeriod, await rentAndServices(c, exitPeriod, days, input.prorata)));
    }

    // Consommations jusqu'à l'index de sortie.
    final utilities = <LineDraft>[];
    for (final mv in await Repo.activeMeters(apartmentId: c.apartmentId)) {
      final end = input.exitIndexes[mv.meter.id];
      if (end == null) {
        warnings.add(I18n.ui.warnExitIndexMissing(Labels.utilityName(mv.type)));
        continue;
      }
      final start = await startIndex(c, mv.meter);
      if (end < start) warnings.add(I18n.ui.warnExitIndexLower(Labels.utilityName(mv.type)));
      utilities.add(utilityLine(mv, start, end));
    }
    lines.addAll(await applyBenefits(c, exitPeriod, utilities));

    if (input.damages > 0) {
      lines.add(LineDraft(
        kind: 3,
        label: '',
        meta: const {'t': 'dmg'},
        ht: input.damages,
        ttc: input.damages,
      ));
    }

    final previous = (await Repo.balances())[c.id] ?? 0;
    return ExitPreview(await localize(lines), previous, c.depositPaid, warnings);
  }

  /// Clôture : relevés de sortie, facture de sortie, imputation de la caution.
  static Future<int> closeContract(Contract c, ExitInput input) async {
    final preview = await previewExit(c, input);
    final exitPeriod = Period.of(input.exitDate);
    return db.transaction(() async {
      for (final e in input.exitIndexes.entries) {
        await db.into(db.readings).insert(ReadingsCompanion.insert(
              meterId: e.key,
              contractId: Value(c.id),
              kind: const Value(2),
              date: input.exitDate,
              value: e.value,
              photoPath: Value(input.exitPhotos[e.key]),
            ));
      }
      final invoiceId = await db.into(db.invoices).insert(InvoicesCompanion.insert(
            number: _exitNumber(exitPeriod, c.id),
            contractId: c.id,
            period: exitPeriod,
            kind: const Value(1),
            issueDate: DateTime.now(),
            dueDate: input.exitDate,
            total: preview.exitTotal,
            notes: Value(input.notes),
          ));
      for (var i = 0; i < preview.lines.length; i++) {
        await db.into(db.invoiceLines).insert(preview.lines[i].toCompanion(invoiceId, i));
      }
      await (db.update(db.contracts)..where((x) => x.id.equals(c.id))).write(ContractsCompanion(
        status: const Value(1),
        exitDate: Value(input.exitDate),
        exitProrata: Value(input.prorata),
        damagesAmount: Value(input.damages),
        exitNotes: Value(input.notes),
      ));
      if (c.depositPaid > 0) {
        await db.into(db.payments).insert(PaymentsCompanion.insert(
              contractId: c.id,
              date: input.exitDate,
              amount: c.depositPaid,
              kind: const Value(1),
              method: const Value('Caution'),
              note: const Value('Caution imputée sur le solde de sortie'),
              receiptNumber: 'CAU-${c.id.toString().padLeft(3, '0')}',
            ));
      }
      return invoiceId;
    });
  }
}
