import 'package:drift/drift.dart' hide Column;
import 'package:flutter/services.dart' show rootBundle;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../core/advance.dart';
import '../core/dates.dart';
import '../core/i18n.dart';
import '../core/labels.dart';
import '../core/money.dart';
import '../data/database.dart';
import '../data/repo.dart';
import '../l10n/app_localizations.dart';
import 'app_state.dart';
import 'history_sheet.dart';
import 'signature_service.dart';

/// Langue d'un document : celle du locataire, sinon celle de l'application.
class _Lang {
  final String code;
  final AppLocalizations t;
  final LineText text;
  _Lang(this.code, this.text) : t = I18n.of(code);

  static Future<_Lang> forTenant(Tenant tenant) async {
    final code = tenant.language != null && I18n.codes.contains(tenant.language) ? tenant.language! : I18n.lang;
    return _Lang(code, LineText(await NameBook.load(App.db), code));
  }

  String money(int cents) => Money.format(cents, lang: code);
  String date(DateTime? d) => Dates.d(d, code);
}

class PdfService {
  static pw.ThemeData? _theme;
  static const _primary = PdfColor.fromInt(0xFF0E7C7B);
  static const _muted = PdfColor.fromInt(0xFF6B7280);
  static const _light = PdfColor.fromInt(0xFFF1F5F4);

  static Future<pw.ThemeData> _loadTheme() async {
    if (_theme != null) return _theme!;
    final regular = pw.Font.ttf(await rootBundle.load('assets/fonts/Roboto-Regular.ttf'));
    final bold = pw.Font.ttf(await rootBundle.load('assets/fonts/Roboto-Bold.ttf'));
    return _theme = pw.ThemeData.withFont(base: regular, bold: bold);
  }

  static Future<pw.Document> _doc() async => pw.Document(
        theme: await _loadTheme(),
        title: 'NHimmo',
        author: App.settings.businessName,
      );

  // ------------------------------------------------------------ éléments communs

  static pw.Widget _header(_Lang l, String title, String number, String qr, List<String> meta) {
    final s = App.settings;
    return pw.Row(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Expanded(
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(s.businessName,
                  style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold, color: _primary)),
              if (s.address.isNotEmpty) pw.Text(s.address, style: const pw.TextStyle(fontSize: 9, color: _muted)),
              if (s.phone.isNotEmpty || s.email.isNotEmpty)
                pw.Text([s.phone, s.email].where((e) => e.isNotEmpty).join(' · '),
                    style: const pw.TextStyle(fontSize: 9, color: _muted)),
              pw.SizedBox(height: 18),
              pw.Text(title.toUpperCase(),
                  style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold, letterSpacing: 1)),
              pw.Text(l.t.pdfNumber(number), style: const pw.TextStyle(fontSize: 11, color: _muted)),
              pw.SizedBox(height: 4),
              ...meta.map((m) => pw.Text(m, style: const pw.TextStyle(fontSize: 10))),
            ],
          ),
        ),
        pw.Column(children: [
          pw.BarcodeWidget(barcode: pw.Barcode.qrCode(), data: qr, width: 92, height: 92, drawText: false),
          pw.SizedBox(height: 3),
          pw.Text(l.t.pdfDigitalSignature, style: const pw.TextStyle(fontSize: 7, color: _muted)),
        ]),
      ],
    );
  }

  static pw.Widget _party(String label, List<String> lines) => pw.Container(
        padding: const pw.EdgeInsets.all(10),
        decoration: pw.BoxDecoration(color: _light, borderRadius: pw.BorderRadius.circular(6)),
        child: pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text(label.toUpperCase(), style: const pw.TextStyle(fontSize: 8, color: _muted)),
            pw.SizedBox(height: 3),
            pw.Text(lines.first, style: pw.TextStyle(fontSize: 11, fontWeight: pw.FontWeight.bold)),
            ...lines.skip(1).where((l) => l.isNotEmpty).map((l) => pw.Text(l, style: const pw.TextStyle(fontSize: 9))),
          ],
        ),
      );

  static pw.Widget _landlord(_Lang l) =>
      _party(l.t.pdfLandlord, [App.settings.businessName, App.settings.address, App.settings.phone]);

  static pw.Widget _linesTable(_Lang l, List<InvoiceLine> lines) {
    final hasVat = lines.any((x) => x.vat != 0);
    final headers = [l.t.pdfDesignation, if (hasVat) l.t.pdfExclTax, if (hasVat) l.t.vat, l.t.pdfAmount];
    return pw.TableHelper.fromTextArray(
      headers: headers,
      data: lines.map((x) {
        final label = l.text.label(x);
        final details = l.text.details(x);
        return [
          details == null ? label : '$label\n$details',
          if (hasVat) l.money(x.ht),
          if (hasVat) l.money(x.vat),
          l.money(x.ttc),
        ];
      }).toList(),
      border: null,
      headerStyle: pw.TextStyle(fontSize: 9, fontWeight: pw.FontWeight.bold, color: PdfColors.white),
      headerDecoration: const pw.BoxDecoration(color: _primary),
      cellStyle: const pw.TextStyle(fontSize: 9),
      cellAlignments: {
        0: pw.Alignment.centerLeft,
        for (var i = 1; i < headers.length; i++) i: pw.Alignment.centerRight,
      },
      columnWidths: {0: const pw.FlexColumnWidth(4)},
      rowDecoration: const pw.BoxDecoration(
          border: pw.Border(bottom: pw.BorderSide(color: PdfColors.grey300, width: .5))),
      cellPadding: const pw.EdgeInsets.symmetric(horizontal: 6, vertical: 5),
    );
  }

  static pw.Widget _totalRow(_Lang l, String label, int amount, {bool strong = false, PdfColor? color}) =>
      pw.Padding(
        padding: const pw.EdgeInsets.symmetric(vertical: 2),
        child: pw.Row(mainAxisAlignment: pw.MainAxisAlignment.end, children: [
          pw.Text(label, style: pw.TextStyle(fontSize: strong ? 12 : 10, fontWeight: strong ? pw.FontWeight.bold : null)),
          pw.SizedBox(width: 20),
          pw.SizedBox(
            width: 120,
            child: pw.Text(l.money(amount),
                textAlign: pw.TextAlign.right,
                style: pw.TextStyle(
                    fontSize: strong ? 13 : 10, fontWeight: strong ? pw.FontWeight.bold : null, color: color)),
          ),
        ]),
      );

  static pw.Widget Function(pw.Context) _footer(_Lang l) => (ctx) {
        final thanks = App.settings.invoiceFooter.isEmpty ? l.t.pdfDefaultThanks : App.settings.invoiceFooter;
        return pw.Container(
          alignment: pw.Alignment.center,
          margin: const pw.EdgeInsets.only(top: 12),
          child: pw.Text(
            '$thanks  ·  ${l.t.pdfFooter}  ·  ${l.t.pdfPage('${ctx.pageNumber}', '${ctx.pagesCount}')}',
            style: const pw.TextStyle(fontSize: 7, color: _muted),
          ),
        );
      };

  static List<String> _tenantLines(ContractView cv) => [
        cv.tenant.fullName,
        cv.place,
        cv.tenant.phone ?? '',
        cv.tenant.email ?? '',
      ];

  static pw.Widget _sectionTitle(String s) =>
      pw.Text(s, style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold, color: _primary));

  // ------------------------------------------------------------ facture

  static Future<List<pw.Widget>> _invoiceContent(InvoiceView v) async {
    final l = await _Lang.forTenant(v.cv.tenant);
    final t = l.t;
    final lines = await Repo.lines(v.inv.id);
    final qr = await SignatureService.qrData(DocType.invoice, v.inv.id, v.inv.number, v.inv.total);
    final ht = lines.fold<int>(0, (s, x) => s + x.ht);
    final vat = lines.fold<int>(0, (s, x) => s + x.vat);
    final exit = v.inv.kind == 1;
    return [
      _header(l, exit ? t.exitInvoice : t.docInvoice, v.inv.number, qr, [
        t.pdfPeriod(Period.label(v.inv.period, l.code)),
        t.pdfIssuedDue(l.date(v.inv.issueDate), l.date(v.inv.dueDate)),
      ]),
      pw.SizedBox(height: 16),
      pw.Row(children: [
        pw.Expanded(child: _landlord(l)),
        pw.SizedBox(width: 12),
        pw.Expanded(child: _party(t.pdfTenant, _tenantLines(v.cv))),
      ]),
      pw.SizedBox(height: 16),
      _linesTable(l, lines),
      pw.SizedBox(height: 10),
      if (vat != 0) _totalRow(l, t.pdfTotalExclTax, ht),
      if (vat != 0) _totalRow(l, t.vat, vat),
      _totalRow(l, t.pdfTotalDue, v.inv.total, strong: true, color: _primary),
      // Avance ou paiements antérieurs imputés sur cette facture.
      if (v.alloc.showSettlement) ...[
        pw.SizedBox(height: 8),
        _totalRow(l, t.creditAvailable, v.alloc.creditBefore),
        _totalRow(l, t.creditApplied, -v.alloc.applied),
        _totalRow(l, t.remainingToPay, v.remaining, strong: true, color: v.remaining > 0 ? PdfColors.red700 : PdfColors.green700),
        if (v.alloc.creditAfter > 0) _totalRow(l, t.creditRemaining, v.alloc.creditAfter),
        if (v.cv.advanceMode == AdvanceMode.rentOnly)
          pw.Align(
            alignment: pw.Alignment.centerRight,
            child: pw.Text(t.pdfAdvanceRentOnly, style: const pw.TextStyle(fontSize: 8.5, color: _muted)),
          ),
      ],
      if (v.status == PayStatus.paid)
        pw.Align(
          alignment: pw.Alignment.centerRight,
          child: pw.Container(
            margin: const pw.EdgeInsets.only(top: 6),
            padding: const pw.EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: pw.BoxDecoration(border: pw.Border.all(color: PdfColors.green700), borderRadius: pw.BorderRadius.circular(4)),
            child: pw.Text(t.pdfPaidStamp, style: pw.TextStyle(color: PdfColors.green700, fontWeight: pw.FontWeight.bold)),
          ),
        ),
      if (v.inv.notes != null && v.inv.notes!.isNotEmpty) ...[
        pw.SizedBox(height: 12),
        pw.Text(t.pdfNotes(v.inv.notes!), style: const pw.TextStyle(fontSize: 9)),
      ],
    ];
  }

  static Future<Uint8List> invoice(int invoiceId) async {
    final doc = await _doc();
    final v = await Repo.invoice(invoiceId);
    final l = await _Lang.forTenant(v.cv.tenant);
    final content = await _invoiceContent(v);
    doc.addPage(pw.MultiPage(pageFormat: PdfPageFormat.a4, margin: const pw.EdgeInsets.all(32), footer: _footer(l), build: (_) => content));
    return doc.save();
  }

  /// Toutes les factures d'une liste dans un seul PDF, chacune dans la langue de son locataire.
  static Future<Uint8List> invoices(List<InvoiceView> list) async {
    final doc = await _doc();
    for (final v in list) {
      final l = await _Lang.forTenant(v.cv.tenant);
      final content = await _invoiceContent(v);
      doc.addPage(pw.MultiPage(pageFormat: PdfPageFormat.a4, margin: const pw.EdgeInsets.all(32), footer: _footer(l), build: (_) => content));
    }
    return doc.save();
  }

  // ------------------------------------------------------------ quittance

  static Future<Uint8List> receipt(int paymentId) async {
    final doc = await _doc();
    final pv = await Repo.payment(paymentId);
    final l = await _Lang.forTenant(pv.cv.tenant);
    final t = l.t;
    final p = pv.pay;
    final qr = await SignatureService.qrData(DocType.receipt, p.id, p.receiptNumber, p.amount);
    final refund = p.kind == 2;
    final deposit = p.kind == 3;
    final method = Labels.method(t, p.method);
    final ref = p.reference == null || p.reference!.isEmpty ? '' : ' (${t.pdfReference(p.reference!)})';
    doc.addPage(pw.Page(
      pageFormat: PdfPageFormat.a5.landscape,
      margin: const pw.EdgeInsets.all(24),
      build: (ctx) => pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          _header(l, refund ? t.refundReceipt : deposit ? t.depositReceipt : t.docReceipt, p.receiptNumber, qr, [t.pdfDate(Dates.long(p.date, l.code))]),
          pw.SizedBox(height: 14),
          pw.Text(
            refund
                ? t.pdfRefundText(App.settings.businessName, pv.cv.tenant.fullName)
                : deposit
                    ? t.pdfDepositReceivedText(pv.cv.tenant.fullName, pv.cv.place)
                    : t.pdfReceivedText(pv.cv.tenant.fullName, pv.cv.place),
            style: const pw.TextStyle(fontSize: 11),
          ),
          pw.SizedBox(height: 8),
          pw.Container(
            width: double.infinity,
            padding: const pw.EdgeInsets.all(12),
            decoration: pw.BoxDecoration(color: _light, borderRadius: pw.BorderRadius.circular(6)),
            child: pw.Text(l.money(p.amount),
                style: pw.TextStyle(fontSize: 22, fontWeight: pw.FontWeight.bold, color: _primary)),
          ),
          pw.SizedBox(height: 8),
          pw.Text('${t.pdfPaymentMethod(method)}$ref', style: const pw.TextStyle(fontSize: 10)),
          if (p.note != null && p.note!.isNotEmpty) pw.Text(t.pdfNote(p.note!), style: const pw.TextStyle(fontSize: 10)),
          pw.SizedBox(height: 4),
          pw.Text(
            deposit
                ? t.depositIncompleteDetail(l.money(pv.cv.c.depositPaid), l.money(pv.cv.c.deposit))
                : [
                    t.pdfBalanceAfter(l.money(pv.cv.due > 0 || pv.cv.advance == 0 ? pv.cv.due : -pv.cv.advance)),
                    if (pv.cv.due > 0 && pv.cv.advance > 0) t.advanceOnRent(l.money(pv.cv.advance)),
                  ].join(' · '),
            style: const pw.TextStyle(fontSize: 10, color: _muted),
          ),
          pw.Spacer(),
          pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [
            pw.Text(t.pdfDoneOn(l.date(DateTime.now())), style: const pw.TextStyle(fontSize: 9, color: _muted)),
            pw.Text(App.settings.businessName, style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold)),
          ]),
        ],
      ),
    ));
    return doc.save();
  }

  // ------------------------------------------------------------ fin de contrat

  static Future<Uint8List> exitStatement(int contractId) async {
    final doc = await _doc();
    final cv = await Repo.contract(contractId);
    final l = await _Lang.forTenant(cv.tenant);
    final t = l.t;
    final c = cv.c;
    final db = App.db;
    final invs = await Repo.invoices(contractId: contractId);
    final exitInv = invs.where((i) => i.inv.kind == 1).firstOrNull;
    final lines = exitInv == null ? <InvoiceLine>[] : await Repo.lines(exitInv.inv.id);
    final pays = await (db.select(db.payments)..where((p) => p.contractId.equals(contractId))).get();
    final totalInvoiced = invs.fold<int>(0, (s, i) => s + i.inv.total);
    final paidByTenant = pays.where((p) => p.kind == 0).fold<int>(0, (s, p) => s + p.amount);
    final deposit = pays.where((p) => p.kind == 1).fold<int>(0, (s, p) => s + p.amount);
    final refunds = pays.where((p) => p.kind == 2).fold<int>(0, (s, p) => s + p.amount);
    final balance = cv.balance;

    final inspection = await (db.select(db.inspections)
          ..where((i) => i.contractId.equals(contractId) & i.kind.equals(1))
          ..orderBy([(i) => OrderingTerm.desc(i.date)])
          ..limit(1))
        .getSingleOrNull();
    final damageItems = inspection == null
        ? <InspectionItem>[]
        : (await (db.select(db.inspectionItems)..where((x) => x.inspectionId.equals(inspection.id))).get())
            .where((x) => x.cost > 0)
            .toList();

    final number = exitInv?.inv.number ?? 'S-${c.id}';
    final qr = await SignatureService.qrData(DocType.exit, c.id, number, balance);

    final (verdict, verdictColor) = balance > 0
        ? (t.pdfTenantOwes, PdfColors.red700)
        : balance < 0
            ? (t.pdfToRefund, PdfColors.green700)
            : (t.pdfSettled, _primary);

    doc.addPage(pw.MultiPage(
      pageFormat: PdfPageFormat.a4,
      margin: const pw.EdgeInsets.all(32),
      footer: _footer(l),
      build: (ctx) => [
        _header(l, t.pdfExitTitle, number, qr, [
          t.pdfMoveInOut(l.date(c.startDate), l.date(c.exitDate)),
          c.exitProrata == true ? t.pdfLastMonthProrata : t.pdfLastMonthFull,
        ]),
        pw.SizedBox(height: 16),
        pw.Row(children: [
          pw.Expanded(child: _landlord(l)),
          pw.SizedBox(width: 12),
          pw.Expanded(child: _party(t.pdfOutgoingTenant, _tenantLines(cv))),
        ]),
        pw.SizedBox(height: 16),
        _sectionTitle(t.pdfSectionExitInvoice),
        pw.SizedBox(height: 6),
        lines.isEmpty ? pw.Text(t.pdfNoLine) : _linesTable(l, lines),
        if (exitInv != null) _totalRow(l, t.exitInvoiceTotal, exitInv.inv.total, strong: true),
        if (damageItems.isNotEmpty) ...[
          pw.SizedBox(height: 14),
          _sectionTitle(t.pdfSectionDamages),
          pw.SizedBox(height: 6),
          pw.TableHelper.fromTextArray(
            headers: [t.pdfRoom, t.pdfItem, t.pdfCondition, t.pdfComment, t.pdfCost],
            data: damageItems
                .map((d) => [
                      Labels.room(t, d.room),
                      d.element,
                      Labels.condition(t, d.condition),
                      d.comment ?? '',
                      l.money(d.cost),
                    ])
                .toList(),
            headerStyle: pw.TextStyle(fontSize: 9, fontWeight: pw.FontWeight.bold, color: PdfColors.white),
            headerDecoration: const pw.BoxDecoration(color: _primary),
            cellStyle: const pw.TextStyle(fontSize: 9),
            border: null,
            cellAlignments: {4: pw.Alignment.centerRight},
          ),
        ],
        pw.SizedBox(height: 14),
        _sectionTitle(t.pdfSectionSummary(damageItems.isNotEmpty ? '3' : '2')),
        pw.SizedBox(height: 6),
        _totalRow(l, t.pdfTotalLease, totalInvoiced),
        _totalRow(l, t.pdfTotalTenantPaid, -paidByTenant),
        _totalRow(l, t.pdfDepositApplied, -deposit),
        if (c.damagesAmount > 0) _totalRow(l, t.pdfDamagesFromDeposit, c.damagesAmount),
        if (refunds > 0) _totalRow(l, t.pdfRefundsDone, refunds),
        pw.Divider(color: PdfColors.grey400),
        pw.Container(
          padding: const pw.EdgeInsets.all(12),
          decoration: pw.BoxDecoration(border: pw.Border.all(color: verdictColor, width: 1.5), borderRadius: pw.BorderRadius.circular(6)),
          child: pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [
            pw.Text(verdict, style: pw.TextStyle(fontSize: 13, fontWeight: pw.FontWeight.bold, color: verdictColor)),
            pw.Text(l.money(balance.abs()), style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold, color: verdictColor)),
          ]),
        ),
        if (balance > 0 && deposit > 0 && c.damagesAmount > 0)
          pw.Padding(
            padding: const pw.EdgeInsets.only(top: 6),
            child: pw.Text(t.pdfDepositNotEnough, style: const pw.TextStyle(fontSize: 9)),
          ),
        if (c.exitNotes != null && c.exitNotes!.isNotEmpty) ...[
          pw.SizedBox(height: 10),
          pw.Text(t.pdfObservations(c.exitNotes!), style: const pw.TextStyle(fontSize: 9)),
        ],
        pw.SizedBox(height: 24),
        pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [
          pw.Text(t.pdfManagerSign, style: const pw.TextStyle(fontSize: 10)),
          pw.Text(t.pdfTenantSign, style: const pw.TextStyle(fontSize: 10)),
        ]),
      ],
    ));
    return doc.save();
  }
  // ------------------------------------------------------------ bordereau de signature

  /// Bordereau remis au locataire à la signature : trace des conditions convenues
  /// (le bail lui-même n'est pas rédigé dans l'application).
  static Future<Uint8List> signingSlip(int contractId) async {
    final doc = await _doc();
    final db = App.db;
    final cv = await Repo.contract(contractId);
    final l = await _Lang.forTenant(cv.tenant);
    final t = l.t;
    final c = cv.c;
    final number = 'B-${c.id.toString().padLeft(4, '0')}';
    final qr = await SignatureService.qrData(DocType.signing, c.id, number, c.rent);

    final svcTypes = {for (final s in await db.select(db.serviceTypes).get()) s.id: s};
    final services = await (db.select(db.contractServices)..where((s) => s.contractId.equals(c.id))).get();
    final meters = {for (final m in await Repo.activeMeters(apartmentId: c.apartmentId)) m.meter.id: m};
    final readings = await (db.select(db.readings)
          ..where((r) => r.contractId.equals(c.id) & r.kind.equals(1)))
        .get();
    final entryInv = (await Repo.invoices(period: Period.of(c.startDate), contractId: c.id))
        .where((i) => i.inv.kind == 0)
        .firstOrNull;
    final depositLeft = c.deposit > c.depositPaid ? c.deposit - c.depositPaid : 0;
    final penalty = cv.apt.latePenalty ?? cv.building.latePenalty;

    final firstRent = switch (c.firstRentMode) {
      1 => t.fullMonth,
      2 => '${t.firstRentFlat} · ${l.money(c.firstRentAmount ?? 0)}${c.firstRentNote == null ? '' : ' (${c.firstRentNote})'}',
      _ => t.prorated,
    };

    pw.Widget row(String k, String v) => pw.Padding(
          padding: const pw.EdgeInsets.symmetric(vertical: 2.5),
          child: pw.Row(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
            pw.SizedBox(width: 190, child: pw.Text(k, style: const pw.TextStyle(fontSize: 10, color: _muted))),
            pw.Expanded(child: pw.Text(v, style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold))),
          ]),
        );

    pw.Widget table(List<String> headers, List<List<String>> data) => pw.TableHelper.fromTextArray(
          headers: headers,
          data: data,
          border: null,
          headerStyle: pw.TextStyle(fontSize: 9, fontWeight: pw.FontWeight.bold, color: PdfColors.white),
          headerDecoration: const pw.BoxDecoration(color: _primary),
          cellStyle: const pw.TextStyle(fontSize: 9),
          cellAlignments: {for (var i = 1; i < headers.length; i++) i: pw.Alignment.centerRight},
          cellAlignment: pw.Alignment.centerLeft,
          headerAlignments: {for (var i = 0; i < headers.length; i++) i: i == 0 ? pw.Alignment.centerLeft : pw.Alignment.centerRight},
          rowDecoration: const pw.BoxDecoration(
              border: pw.Border(bottom: pw.BorderSide(color: PdfColors.grey300, width: .5))),
        );

    doc.addPage(pw.MultiPage(
      pageFormat: PdfPageFormat.a4,
      margin: const pw.EdgeInsets.all(32),
      footer: _footer(l),
      build: (ctx) => [
        _header(l, t.signSlip, number, qr, [t.pdfDate(Dates.long(c.startDate, l.code))]),
        pw.SizedBox(height: 16),
        pw.Row(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
          pw.Expanded(child: _landlord(l)),
          pw.SizedBox(width: 12),
          pw.Expanded(
              child: _party(t.pdfTenant, [
            cv.tenant.fullName,
            if (cv.tenant.idNumber != null && cv.tenant.idNumber!.isNotEmpty) '${t.idNumber} : ${cv.tenant.idNumber}',
            cv.tenant.phone ?? '',
            cv.tenant.email ?? '',
          ])),
        ]),
        pw.SizedBox(height: 14),
        _sectionTitle(t.bsHousing),
        pw.SizedBox(height: 4),
        row(t.bsHousing, [cv.place, if (cv.apt.floor != null && cv.apt.floor!.isNotEmpty) cv.apt.floor!].join(' · ')),
        if (cv.building.address != null && cv.building.address!.isNotEmpty) row(t.address, cv.building.address!),
        pw.SizedBox(height: 12),
        _sectionTitle(t.bsTerms),
        pw.SizedBox(height: 4),
        row(t.bsSigningDate, l.date(c.startDate)),
        if (c.plannedEndDate != null) row(t.bsPlannedEnd, l.date(c.plannedEndDate)),
        if (c.plannedEndDate != null && c.tacitRenewal) row(t.tacitRenewal, t.yes),
        row(t.monthlyRent, l.money(c.rent)),
        row(t.depositRequired, l.money(c.deposit)),
        row(t.depositPaid, l.money(c.depositPaid)),
        row(t.firstRent, firstRent),
        if (penalty > 0) row(t.latePenalty, l.money(penalty)),
        pw.Padding(
          padding: const pw.EdgeInsets.only(top: 4),
          child: pw.Text(t.bsDueRule('${App.settings.dueDay}'), style: const pw.TextStyle(fontSize: 9.5)),
        ),
        pw.SizedBox(height: 12),
        _sectionTitle(t.services),
        pw.SizedBox(height: 4),
        if (services.isEmpty)
          pw.Text(t.bsNoService, style: const pw.TextStyle(fontSize: 9.5, color: _muted))
        else
          table([t.services, t.unitPrice, t.pdfAmount], [
            for (final s in services)
              [
                svcTypes[s.serviceTypeId] == null ? '' : Labels.serviceName(svcTypes[s.serviceTypeId]!, l.code),
                l.money(s.unitPrice),
                l.money(s.unitPrice * (s.quantity - s.includedQuantity).clamp(0, 1 << 30)),
              ]
          ]),
        if (readings.isNotEmpty) ...[
          pw.SizedBox(height: 12),
          _sectionTitle(t.entryReadings),
          pw.SizedBox(height: 4),
          table([t.bsMeter, t.bsIndex], [
            for (final r in readings)
              [
                meters[r.meterId] == null ? '' : Labels.utilityName(meters[r.meterId]!.type, l.code),
                Num.format(r.value),
              ]
          ]),
        ],
        pw.SizedBox(height: 12),
        _sectionTitle(t.bsAtSigning),
        pw.SizedBox(height: 4),
        if (entryInv != null) _totalRow(l, t.bsFirstInvoice(entryInv.inv.number), entryInv.inv.total),
        if (depositLeft > 0) _totalRow(l, t.bsDepositLeft, depositLeft),
        _totalRow(l, t.bsRemaining, (entryInv?.remaining ?? 0) + depositLeft, strong: true, color: _primary),
        pw.SizedBox(height: 14),
        pw.Text(t.bsDisclaimer, style: const pw.TextStyle(fontSize: 9, color: _muted)),
        pw.SizedBox(height: 10),
        pw.Text(t.pdfDoneOn(l.date(c.startDate)), style: const pw.TextStyle(fontSize: 10)),
        pw.SizedBox(height: 30),
        pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [
          pw.Text(t.pdfManagerSign, style: const pw.TextStyle(fontSize: 10)),
          pw.Text(t.pdfTenantSign, style: const pw.TextStyle(fontSize: 10)),
        ]),
        pw.SizedBox(height: 50),
      ],
    ));
    return doc.save();
  }

  // ------------------------------------------------------------ fiche historique

  /// Fiche historique d'un bail, au format du cahier : un mois par ligne avec index, montants,
  /// loyer, pénalité, montant attendu, montant payé et date de règlement.
  static Future<Uint8List> historySheet(int contractId) async {
    final doc = await _doc();
    final sheet = await HistorySheet.build(contractId);
    final cv = sheet.cv;
    final l = await _Lang.forTenant(cv.tenant);
    final t = l.t;
    String n(double? v) => v == null ? '—' : Num.format(v, lang: l.code);
    String m(int v) => v == 0 ? '—' : Money.format(v, withSymbol: false, lang: l.code);

    final headers = <String>[
      t.hsMonth,
      for (final u in sheet.types) ...['${Labels.utilityName(u, l.code)} ${t.hsNew}', t.hsOld, t.hsAmount],
      t.hsRent, t.hsOther, t.hsPenalty, t.hsExpected, t.hsPaid, t.hsSettled, t.hsRemarks,
    ];
    final data = <List<String>>[];
    var totRent = 0, totOther = 0, totPen = 0, totExp = 0, totPaid = 0;
    final totMeters = {for (final u in sheet.types) u.id: 0};
    for (final r in sheet.rows) {
      final inv = r.invoice;
      totRent += r.rent;
      totOther += r.other;
      totPen += r.penalty;
      totExp += r.expected;
      totPaid += r.paid;
      final remark = r.settled
          ? t.hsPaidFull
          : r.paid > 0
              ? t.hsPartial(Money.format(r.remaining, lang: l.code))
              : t.hsUnpaid;
      data.add([
        '${Period.label(inv.period, l.code)}${inv.kind == 1 ? ' (${t.hsExit})' : ''}',
        for (final u in sheet.types) ...() {
          final mt = r.meters[u.id];
          totMeters[u.id] = totMeters[u.id]! + (mt?.amount ?? 0);
          return [n(mt?.end), n(mt?.start), m(mt?.amount ?? 0)];
        }(),
        m(r.rent),
        m(r.other),
        m(r.penalty),
        Money.format(r.expected, withSymbol: false, lang: l.code),
        m(r.paid),
        r.settledOn == null ? (r.lastPaymentOn == null ? '—' : l.date(r.lastPaymentOn)) : l.date(r.settledOn),
        remark,
      ]);
    }
    data.add([
      t.hsTotals,
      for (final u in sheet.types) ...['', '', m(totMeters[u.id]!)],
      m(totRent), m(totOther), m(totPen), Money.format(totExp, withSymbol: false, lang: l.code), m(totPaid), '', '',
    ]);

    final rentLines = sheet.rents.length <= 1
        ? <String>[]
        : [
            for (final r in sheet.rents)
              '${r.fromPeriod == UtilityTariffs.origin ? t.rentFromStart : t.rentSince(Period.label(r.fromPeriod, l.code))} : ${l.money(r.rent)}',
          ];

    doc.addPage(pw.MultiPage(
      pageFormat: PdfPageFormat.a4.landscape,
      margin: const pw.EdgeInsets.all(24),
      footer: (ctx) => pw.Container(
        alignment: pw.Alignment.centerRight,
        child: pw.Text('${t.hsPrinted(l.date(DateTime.now()))}  ·  ${t.pdfPage('${ctx.pageNumber}', '${ctx.pagesCount}')}',
            style: const pw.TextStyle(fontSize: 7, color: _muted)),
      ),
      build: (ctx) => [
        pw.Row(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
          pw.Expanded(
            child: pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
              pw.Text(App.settings.businessName, style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold, color: _primary)),
              pw.SizedBox(height: 4),
              pw.Text(t.hsTitle.toUpperCase(), style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold)),
              pw.Text('${cv.place}  ·  ${cv.tenant.fullName}${cv.tenant.phone == null ? '' : '  ·  ${cv.tenant.phone}'}',
                  style: const pw.TextStyle(fontSize: 10)),
              pw.Text(t.hsLease(l.date(cv.c.startDate), cv.c.exitDate == null ? t.ongoing : l.date(cv.c.exitDate)),
                  style: const pw.TextStyle(fontSize: 9, color: _muted)),
            ]),
          ),
          pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.end, children: [
            pw.Text('${t.monthlyRent} : ${l.money(cv.c.rent)}', style: const pw.TextStyle(fontSize: 9)),
            pw.Text('${t.depositPaidShort} : ${l.money(cv.c.depositPaid)} / ${l.money(cv.c.deposit)}', style: const pw.TextStyle(fontSize: 9)),
            ...rentLines.map((x) => pw.Text(x, style: const pw.TextStyle(fontSize: 8, color: _muted))),
          ]),
        ]),
        pw.SizedBox(height: 10),
        pw.TableHelper.fromTextArray(
          headers: headers,
          data: data,
          border: pw.TableBorder.all(color: PdfColors.grey400, width: .4),
          headerStyle: pw.TextStyle(fontSize: 7, fontWeight: pw.FontWeight.bold, color: PdfColors.white),
          headerDecoration: const pw.BoxDecoration(color: _primary),
          cellStyle: const pw.TextStyle(fontSize: 7),
          cellPadding: const pw.EdgeInsets.symmetric(horizontal: 3, vertical: 3),
          cellAlignments: {
            for (var i = 1; i < headers.length - 2; i++) i: pw.Alignment.centerRight,
          },
          columnWidths: {
            0: const pw.FlexColumnWidth(1.6),
            headers.length - 1: const pw.FlexColumnWidth(1.4),
          },
          oddRowDecoration: const pw.BoxDecoration(color: _light),
        ),
        pw.SizedBox(height: 8),
        pw.Text(t.hsBalance(l.money(cv.due > 0 || cv.advance == 0 ? cv.due : -cv.advance)),
            style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold, color: cv.due > 0 ? PdfColors.red700 : _primary)),
        if (cv.due > 0 && cv.advance > 0)
          pw.Text(t.advanceOnRent(l.money(cv.advance)), style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold, color: _primary)),
      ],
    ));
    return doc.save();
  }
}
