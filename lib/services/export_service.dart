import 'dart:convert';
import 'dart:io';

import 'package:archive/archive.dart';
import 'package:drift/drift.dart';
import 'package:excel/excel.dart' hide Border;
import 'package:intl/intl.dart';
import 'package:path/path.dart' as p;

import '../core/dates.dart';
import '../core/i18n.dart';
import '../core/labels.dart';
import '../core/money.dart';
import '../data/repo.dart';
import 'app_state.dart';

enum ExportFormat { excel, csv }

typedef Rows = List<List<Object?>>;

/// Exports à trois niveaux : relevés, facturation, données complètes.
class ExportService {

  static double _amount(int cents) => cents / 100;

  // --------------------------------------------------------------- relevés

  static Future<Map<String, Rows>> readings(int from, int to) async {
    final db = App.db;
    final t = I18n.ui;
    final apts = {for (final a in await Repo.apartments(includeArchived: true)) a.apt.id: a};
    final contracts = {for (final c in await Repo.contracts()) c.c.id: c};
    final meters = await (db.select(db.meters).join([
      innerJoin(db.utilityTypes, db.utilityTypes.id.equalsExp(db.meters.utilityTypeId)),
    ])).get();
    final meterMap = {for (final r in meters) r.readTable(db.meters).id: MeterView(r.readTable(db.meters), r.readTable(db.utilityTypes))};

    final start = Period.firstDay(from);
    final end = Period.lastDay(to).add(const Duration(days: 1));
    final rows = await (db.select(db.readings)
          ..where((r) =>
              (r.kind.equals(0) & r.period.isBetweenValues(from, to)) |
              (r.kind.isIn([1, 2]) & r.date.isBiggerOrEqualValue(start) & r.date.isSmallerThanValue(end)))
          ..orderBy([(r) => OrderingTerm.asc(r.date)]))
        .get();

    final table = <List<Object?>>[
      [t.period, t.type, t.xBuilding, t.xApartment, t.pdfTenant, t.xMeter, t.serialNumber, 'Date', t.xReading, t.xPreviousReading, t.consumption, t.unit, t.photo, t.note],
    ];
    for (final r in rows) {
      final mv = meterMap[r.meterId];
      if (mv == null) continue;
      final apt = apts[mv.meter.apartmentId];
      final period = r.period ?? Period.of(r.date);
      String? tenant;
      if (r.contractId != null) {
        tenant = contracts[r.contractId]?.tenant.fullName;
      } else {
        tenant = contracts.values
            .where((c) =>
                c.c.apartmentId == mv.meter.apartmentId &&
                !c.c.startDate.isAfter(Period.lastDay(period)) &&
                (c.c.exitDate == null || !c.c.exitDate!.isBefore(Period.firstDay(period))))
            .firstOrNull
            ?.tenant
            .fullName;
      }
      final prev = r.kind == 0 ? await Repo.previousIndex(mv.meter, period) : null;
      table.add([
        Period.label(period),
        [t.xKindMonthly, t.moveIn, t.moveOut][r.kind],
        apt?.building.name,
        apt?.apt.name,
        tenant ?? '',
        Labels.utilityName(mv.type),
        mv.meter.serial ?? '',
        Dates.dt(r.date),
        r.value,
        prev,
        prev == null ? null : r.value - prev,
        mv.type.unit,
        r.photoPath == null ? t.xNo : t.xYes,
        r.note ?? '',
      ]);
    }
    return {t.scopeReadings: table};
  }

  // --------------------------------------------------------------- facturation

  static Future<Map<String, Rows>> billing(int from, int to) async {
    final t = I18n.ui;
    final text = LineText(await NameBook.load(App.db), I18n.lang);
    final invs = await Repo.invoices(from: from, to: to);
    invs.sort((a, b) => a.inv.number.compareTo(b.inv.number));
    final invoices = <List<Object?>>[
      [t.xInvoiceNo, t.period, t.type, t.pdfTenant, t.xBuilding, t.xApartment, t.issuedOn, t.dueDate, t.xTotalWith(Money.currency.symbol), t.remainingToPay, t.pdfStatus, t.locked],
      for (final v in invs)
        [
          v.inv.number,
          Period.label(v.inv.period),
          v.inv.kind == 1 ? t.moveOut : t.monthly,
          v.cv.tenant.fullName,
          v.cv.building.name,
          v.cv.apt.name,
          Dates.d(v.inv.issueDate),
          Dates.d(v.inv.dueDate),
          _amount(v.inv.total),
          _amount(v.remaining),
          switch (v.status) { PayStatus.paid => t.payStatusPaid, PayStatus.partial => t.payStatusPartial, PayStatus.unpaid => t.payStatusUnpaid },
          v.locked ? t.xYes : t.xNo,
        ],
    ];

    final lines = <List<Object?>>[
      [t.xInvoiceNo, t.pdfTenant, t.xLabel, t.xDetails, t.xQuantity, t.unit, t.xUnitPrice, t.pdfExclTax, t.vat, t.xInclTax, t.xStartReading, t.xEndReading],
    ];
    for (final v in invs) {
      for (final l in await Repo.lines(v.inv.id)) {
        lines.add([
          v.inv.number,
          v.cv.tenant.fullName,
          text.label(l),
          text.details(l) ?? '',
          l.quantity,
          l.unit ?? '',
          _amount(l.unitPrice),
          _amount(l.ht),
          _amount(l.vat),
          _amount(l.ttc),
          l.startIndex,
          l.endIndex,
        ]);
      }
    }

    final pays = await Repo.payments(
        from: Period.firstDay(from), to: Period.lastDay(to).add(const Duration(days: 1)));
    final payments = <List<Object?>>[
      ['Date', t.xReceiptNo, t.pdfTenant, t.xBuilding, t.xApartment, t.type, t.xMethod, t.xReference, t.amount, t.note],
      for (final pv in pays)
        [
          Dates.d(pv.pay.date),
          pv.pay.receiptNumber,
          pv.cv.tenant.fullName,
          pv.cv.building.name,
          pv.cv.apt.name,
          [t.xPayment, t.depositApplied, t.refundKind, t.depositReceived][pv.pay.kind],
          Labels.method(t, pv.pay.method),
          pv.pay.reference ?? '',
          _amount(pv.pay.kind == 2 ? -pv.pay.amount : pv.pay.amount),
          pv.pay.note ?? '',
        ],
    ];

    final balances = <List<Object?>>[
      [t.pdfTenant, t.xBuilding, t.xApartment, t.lease, t.moveIn, t.moveOut, t.depositPaidShort, t.xBalanceSigned],
      for (final cv in await Repo.contracts())
        [
          cv.tenant.fullName,
          cv.building.name,
          cv.apt.name,
          cv.active ? t.active : t.done,
          Dates.d(cv.c.startDate),
          Dates.d(cv.c.exitDate),
          _amount(cv.c.depositPaid),
          _amount(cv.balance),
        ],
    ];

    return {t.invoices: invoices, t.xSheetLines: lines, t.payments: payments, t.xSheetBalances: balances};
  }

  // --------------------------------------------------------------- tout

  static Future<Map<String, Rows>> everything() async {
    final db = App.db;
    final out = <String, Rows>{};
    for (final t in db.allTables) {
      if (t.actualTableName == 'settings') continue;
      final rows = await db.customSelect('SELECT * FROM ${t.actualTableName}').get();
      final cols = t.$columns.map((c) => c.name).toList();
      out[t.actualTableName] = [
        cols,
        for (final r in rows) [for (final c in cols) r.data[c]],
      ];
    }
    return out;
  }

  // --------------------------------------------------------------- écriture

  static Future<File> write(String baseName, Map<String, Rows> tables, ExportFormat format) async {
    final stamp = DateFormat('yyyyMMdd-HHmm').format(DateTime.now());
    final dir = App.exportsDir;
    if (format == ExportFormat.excel) {
      final excel = Excel.createExcel();
      final defaultSheet = excel.getDefaultSheet();
      for (final e in tables.entries) {
        final sheet = excel[_sheetName(e.key)];
        for (final row in e.value) {
          sheet.appendRow(row.map(_cell).toList());
        }
      }
      if (defaultSheet != null && !tables.keys.map(_sheetName).contains(defaultSheet)) {
        excel.delete(defaultSheet);
      }
      final f = File(p.join(dir.path, '$baseName-$stamp.xlsx'));
      await f.writeAsBytes(excel.encode()!, flush: true);
      return f;
    }

    if (tables.length == 1) {
      final f = File(p.join(dir.path, '$baseName-$stamp.csv'));
      await f.writeAsBytes(_csv(tables.values.first), flush: true);
      return f;
    }
    final archive = Archive();
    for (final e in tables.entries) {
      final bytes = _csv(e.value);
      archive.addFile(ArchiveFile('${e.key}.csv', bytes.length, bytes));
    }
    final f = File(p.join(dir.path, '$baseName-$stamp-csv.zip'));
    await f.writeAsBytes(ZipEncoder().encode(archive)!, flush: true);
    return f;
  }

  static String _sheetName(String s) => s.length > 31 ? s.substring(0, 31) : s;

  static CellValue? _cell(Object? v) {
    if (v == null) return null;
    if (v is int) return IntCellValue(v);
    if (v is double) return DoubleCellValue(v);
    if (v is bool) return BoolCellValue(v);
    return TextCellValue(v.toString());
  }

  /// CSV séparé par des points-virgules, avec BOM UTF-8 (ouverture directe dans Excel).
  static List<int> _csv(Rows rows) {
    final buf = StringBuffer('﻿');
    for (final row in rows) {
      buf.writeln(row.map((v) {
        if (v == null) return '';
        var s = v is double ? v.toString().replaceAll('.', ',') : v.toString();
        if (s.contains(RegExp('[;"\n]'))) s = '"${s.replaceAll('"', '""')}"';
        return s;
      }).join(';'));
    }
    return utf8.encode(buf.toString());
  }

}
