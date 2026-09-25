import 'package:drift/drift.dart' hide Column;
import 'package:flutter/material.dart';

import '../../core/dates.dart';
import '../../core/money.dart';
import '../../data/database.dart';
import '../../data/repo.dart';
import '../../services/app_state.dart';
import '../../services/billing_service.dart';
import '../../services/export_service.dart';
import '../../services/photo_service.dart';
import '../shell.dart';
import '../theme.dart';
import '../widgets.dart';
import '../../core/i18n.dart';
import '../../core/labels.dart';

class MeterLine {
  final MeterView mv;
  final Reading? reading;
  final double previous;
  final double? average;
  final bool locked;
  MeterLine(this.mv, this.reading, this.previous, this.average, this.locked);

  double? get consumption => reading == null ? null : reading!.value - previous;
}

class AptLines {
  final ApartmentView a;
  final List<MeterLine> meters;
  AptLines(this.a, this.meters);
}

Future<List<AptLines>> loadReadings(int period) async {
  final apts = await Repo.apartments();
  final out = <AptLines>[];
  for (final a in apts) {
    if (a.meters.isEmpty) continue;
    final lines = <MeterLine>[];
    for (final mv in a.meters) {
      lines.add(MeterLine(
        mv,
        await Repo.monthlyReading(mv.meter.id, period),
        await Repo.previousIndex(mv.meter, period),
        await Repo.averageConsumption(mv.meter.id, period),
        await Repo.readingLocked(mv.meter.id, period),
      ));
    }
    out.add(AptLines(a, lines));
  }
  // Appartements occupés en premier.
  out.sort((x, y) => (y.a.occupied ? 1 : 0).compareTo(x.a.occupied ? 1 : 0));
  return out;
}

class ReadingsPage extends StatefulWidget {
  const ReadingsPage({super.key});

  @override
  State<ReadingsPage> createState() => _ReadingsPageState();
}

class _ReadingsPageState extends State<ReadingsPage> {
  int _period = Period.current();
  bool _generating = false;

  Future<void> _generate() async {
    setState(() => _generating = true);
    try {
      final r = await BillingService.generateMonth(_period);
      if (!mounted) return;
      await showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          icon: Icon(r.warnings.isEmpty ? Icons.check_circle_rounded : Icons.info_rounded,
              color: r.warnings.isEmpty ? AppColors.success : AppColors.warning, size: 44),
          title: Text(ctx.t.invoicesFor(Period.label(_period))),
          content: SingleChildScrollView(
            child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(r.locked > 0
                  ? ctx.t.generationSummaryLocked('${r.created}', '${r.updated}', '${r.locked}')
                  : ctx.t.generationSummary('${r.created}', '${r.updated}')),
              if (r.warnings.isNotEmpty) ...[
                const SizedBox(height: 12),
                Text(ctx.t.warnings, style: const TextStyle(fontWeight: FontWeight.w700)),
                for (final w in r.warnings) Text('• $w'),
              ],
            ]),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx), child: Text(ctx.t.close)),
            FilledButton(
              onPressed: () {
                Navigator.pop(ctx);
                HomeShell.of(context)?.goTo(4);
              },
              child: Text(ctx.t.viewInvoices),
            ),
          ],
        ),
      );
    } finally {
      if (mounted) setState(() => _generating = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.t.navReadings),
        actions: [
          IconButton(
            tooltip: context.t.exportMonthReadings,
            icon: const Icon(Icons.file_download_outlined),
            onPressed: () async {
              final f = await ExportService.write('releves-$_period', await ExportService.readings(_period, _period), ExportFormat.excel);
              await shareFile(f);
            },
          ),
        ],
      ),
      body: Column(children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
          child: MonthSwitcher(period: _period, onChanged: (p) => setState(() => _period = p)),
        ),
        Expanded(
          child: DbBuilder<List<AptLines>>(
            load: () => loadReadings(_period),
            deps: [_period],
            builder: (context, list) {
              if (list.isEmpty) {
                return EmptyState(
                  icon: Icons.speed_rounded,
                  title: context.t.noMeter,
                  message: context.t.noMeterHelp,
                );
              }
              final all = list.expand((a) => a.meters).toList();
              final done = all.where((m) => m.reading != null).length;
              final withPhoto = all.where((m) => m.reading?.photoPath != null).length;
              return ListView(
                padding: const EdgeInsets.fromLTRB(16, 4, 16, 110),
                children: [
                  AppCard(
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Row(children: [
                        Text('$done / ${all.length}', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800)),
                        const SizedBox(width: 8),
                        Expanded(child: Text(context.t.metersRead)),
                        StatusChip(context.t.photosCount('$withPhoto'), AppColors.info, icon: Icons.photo_camera_rounded),
                      ]),
                      const SizedBox(height: 10),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: LinearProgressIndicator(
                          value: all.isEmpty ? 0 : done / all.length,
                          minHeight: 8,
                          color: done == all.length ? AppColors.success : AppColors.primary,
                        ),
                      ),
                    ]),
                  ),
                  for (final a in list) ...[
                    SectionHeader(a.a.fullName,
                        trailing: a.a.occupied
                            ? StatusChip(a.a.tenant!.fullName, AppColors.success)
                            : StatusChip(context.t.free, AppColors.warning)),
                    for (final m in a.meters)
                      Padding(padding: const EdgeInsets.only(bottom: 8), child: _MeterTile(m, _period, a.a)),
                  ],
                ],
              );
            },
          ),
        ),
      ]),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _generating ? null : _generate,
        icon: _generating
            ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
            : const Icon(Icons.receipt_long_rounded),
        label: Text(context.t.generateInvoices),
      ),
    );
  }
}

class _MeterTile extends StatelessWidget {
  final MeterLine m;
  final int period;
  final ApartmentView apt;
  const _MeterTile(this.m, this.period, this.apt);

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final t = m.mv.type;
    final r = m.reading;
    final cons = m.consumption;
    final anomaly = cons != null && m.average != null && m.average! > 0 && cons > m.average! * 2;
    return AppCard(
      onTap: () => showReadingSheet(context, m, period, apt),
      child: Row(children: [
        IconBadge(utilityIcon(t.iconKey), Color(t.colorValue), size: 44),
        const SizedBox(width: 12),
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Text(Labels.utilityName(t), style: const TextStyle(fontWeight: FontWeight.w700)),
              if (m.locked) ...[const SizedBox(width: 6), Icon(Icons.lock_rounded, size: 14, color: cs.outline)],
            ]),
            Text(context.t.previousValue('${Num.format(m.previous)} ${t.unit}'), style: TextStyle(fontSize: 12.5, color: cs.onSurfaceVariant)),
            if (r != null) ...[
              const SizedBox(height: 4),
              Wrap(spacing: 6, runSpacing: 4, children: [
                StatusChip('+${Num.format(cons!)} ${t.unit}', anomaly ? AppColors.warning : AppColors.primary,
                    icon: anomaly ? Icons.warning_amber_rounded : null),
                if (r.photoPath == null) StatusChip(context.t.noPhoto, AppColors.danger, icon: Icons.no_photography_outlined),
              ]),
            ],
          ]),
        ),
        if (r != null) ...[
          if (r.photoPath != null) ...[PhotoThumb(r.photoPath, size: 46), const SizedBox(width: 10)],
          Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
            Text(Num.format(r.value), style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
            Text(Dates.d(r.date), style: TextStyle(fontSize: 11, color: cs.onSurfaceVariant)),
          ]),
        ] else
          FilledButton.tonalIcon(
            onPressed: () => showReadingSheet(context, m, period, apt),
            icon: const Icon(Icons.edit_rounded, size: 18),
            label: Text(context.t.actionRead),
            style: FilledButton.styleFrom(minimumSize: const Size(0, 40)),
          ),
      ]),
    );
  }
}

Future<void> showReadingSheet(BuildContext context, MeterLine m, int period, ApartmentView apt) {
  return showSheet(
    context: context,
    isScrollControlled: true,
    builder: (_) => _ReadingSheet(m, period, apt),
  );
}

class _ReadingSheet extends StatefulWidget {
  final MeterLine m;
  final int period;
  final ApartmentView apt;
  const _ReadingSheet(this.m, this.period, this.apt);

  @override
  State<_ReadingSheet> createState() => _ReadingSheetState();
}

class _ReadingSheetState extends State<_ReadingSheet> {
  late final _value = TextEditingController(text: widget.m.reading == null ? '' : Num.format(widget.m.reading!.value));
  late final _note = TextEditingController(text: widget.m.reading?.note);
  late String? _photo = widget.m.reading?.photoPath;
  late DateTime _date = widget.m.reading?.date ?? DateTime.now();
  bool _saving = false;

  double? get _parsed => Num.parse(_value.text);

  @override
  Widget build(BuildContext context) {
    final m = widget.m;
    final t = m.mv.type;
    final v = _parsed;
    final cons = v == null ? null : v - m.previous;
    final tooLow = cons != null && cons < 0;
    final anomaly = cons != null && m.average != null && m.average! > 0 && cons > m.average! * 2;
    final cs = Theme.of(context).colorScheme;

    return Padding(
      padding: EdgeInsets.fromLTRB(20, 0, 20, MediaQuery.of(context).viewInsets.bottom + 20),
      child: SingleChildScrollView(
        child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Row(children: [
            IconBadge(utilityIcon(t.iconKey), Color(t.colorValue)),
            const SizedBox(width: 12),
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('${Labels.utilityName(t)} · ${widget.apt.apt.name}', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
                Text(Period.label(widget.period), style: TextStyle(color: cs.onSurfaceVariant)),
              ]),
            ),
          ]),
          const SizedBox(height: 16),
          if (m.locked)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: AppCard(
                color: cs.outline.withValues(alpha: .08),
                child: Text(context.t.readingLocked),
              ),
            ),
          Row(children: [
            Expanded(child: _Box(context.t.previous, '${Num.format(m.previous)} ${t.unit}')),
            const SizedBox(width: 10),
            Expanded(
              child: _Box(context.t.consumption, cons == null ? '—' : '${Num.format(cons)} ${t.unit}',
                  color: tooLow ? AppColors.danger : anomaly ? AppColors.warning : AppColors.primary),
            ),
          ]),
          const SizedBox(height: 14),
          TextField(
            controller: _value,
            enabled: !m.locked,
            autofocus: m.reading == null,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w800),
            decoration: InputDecoration(
              labelText: context.t.newReading,
              suffixText: t.unit,
              errorText: tooLow ? context.t.readingLowerThanPrevious : null,
              helperText: anomaly ? context.t.anomalyHelp(Num.format(m.average!, maxDecimals: 1)) : null,
              helperStyle: const TextStyle(color: AppColors.warning),
            ),
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: 14),
          Row(children: [
            if (_photo != null) ...[PhotoThumb(_photo, size: 64), const SizedBox(width: 12)],
            Expanded(
              child: OutlinedButton.icon(
                onPressed: m.locked
                    ? null
                    : () async {
                        final p = await PhotoService.take();
                        if (p != null) setState(() => _photo = p);
                      },
                icon: const Icon(Icons.photo_camera_rounded),
                label: Text(_photo == null ? context.t.photographMeter : context.t.retakePhoto),
              ),
            ),
          ]),
          const SizedBox(height: 14),
          DateField(label: context.t.readingDate, value: _date, onChanged: (d) => setState(() => _date = d)),
          TextField(controller: _note, enabled: !m.locked, decoration: InputDecoration(labelText: context.t.note, prefixIcon: const Icon(Icons.notes))),
          const SizedBox(height: 18),
          Row(children: [
            if (m.reading != null && !m.locked)
              IconButton(
                icon: const Icon(Icons.delete_outline_rounded, color: AppColors.danger),
                onPressed: () async {
                  final db = App.db;
                  await (db.delete(db.readings)..where((r) => r.id.equals(m.reading!.id))).go();
                  if (context.mounted) Navigator.pop(context);
                },
              ),
            const Spacer(),
            FilledButton.icon(
              onPressed: m.locked || v == null || tooLow || _saving ? null : _save,
              icon: const Icon(Icons.check_rounded),
              label: Text(context.t.save),
            ),
          ]),
        ]),
      ),
    );
  }

  Future<void> _save() async {
    if (_photo == null) {
      final ok = await confirm(context, context.t.noPhotoTitle, context.t.saveWithoutPhoto, ok: context.t.save);
      if (!ok) return;
    }
    setState(() => _saving = true);
    final db = App.db;
    final m = widget.m;
    final c = ReadingsCompanion(
      meterId: Value(m.mv.meter.id),
      period: Value(widget.period),
      kind: const Value(0),
      date: Value(_date),
      value: Value(_parsed!),
      photoPath: Value(_photo),
      note: Value(emptyToNull(_note.text)),
    );
    if (m.reading == null) {
      await db.into(db.readings).insert(c);
    } else {
      if (m.reading!.photoPath != null && m.reading!.photoPath != _photo) {
        await PhotoService.delete(m.reading!.photoPath);
      }
      await (db.update(db.readings)..where((r) => r.id.equals(m.reading!.id))).write(c);
    }
    if (mounted) Navigator.pop(context);
  }
}

class _Box extends StatelessWidget {
  final String label;
  final String value;
  final Color? color;
  const _Box(this.label, this.value, {this.color});

  @override
  Widget build(BuildContext context) {
    final c = color ?? Theme.of(context).colorScheme.onSurface;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: c.withValues(alpha: .07), borderRadius: BorderRadius.circular(14)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(label, style: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.onSurfaceVariant)),
        Text(value, style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16, color: c)),
      ]),
    );
  }
}
