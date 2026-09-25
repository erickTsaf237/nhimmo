import 'package:flutter/material.dart';

import '../../core/dates.dart';
import '../../core/i18n.dart';
import '../../l10n/app_localizations.dart';
import '../../services/backup_service.dart';
import '../../services/export_service.dart';
import '../theme.dart';
import '../widgets.dart';

enum _Scope {
  readings(Icons.speed_rounded),
  billing(Icons.receipt_long_rounded),
  all(Icons.dataset_rounded);

  final IconData icon;
  const _Scope(this.icon);

  String label(AppLocalizations t) => switch (this) {
        _Scope.readings => t.scopeReadings,
        _Scope.billing => t.scopeBilling,
        _Scope.all => t.scopeAll,
      };

  String description(AppLocalizations t) => switch (this) {
        _Scope.readings => t.scopeReadingsHelp,
        _Scope.billing => t.scopeBillingHelp,
        _Scope.all => t.scopeAllHelp,
      };
}

class ExportPage extends StatefulWidget {
  const ExportPage({super.key});

  @override
  State<ExportPage> createState() => _ExportPageState();
}

class _ExportPageState extends State<ExportPage> {
  _Scope _scope = _Scope.readings;
  ExportFormat _format = ExportFormat.excel;
  int _from = Period.current();
  int _to = Period.current();
  bool _busy = false;

  Future<void> _export() async {
    setState(() => _busy = true);
    try {
      final from = _from <= _to ? _from : _to;
      final to = _from <= _to ? _to : _from;
      final t = context.t;
      final f = switch (_scope) {
        _Scope.readings => await ExportService.write('${t.scopeReadings}-$from-$to', await ExportService.readings(from, to), _format),
        _Scope.billing => await ExportService.write('${t.scopeBilling}-$from-$to', await ExportService.billing(from, to), _format),
        _Scope.all => await ExportService.write('nhimmo', await ExportService.everything(), _format),
      };
      await shareFile(f);
    } catch (e) {
      if (mounted) toast(context, context.t.errorWith('$e'), error: true);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final t = context.t;
    return Scaffold(
      appBar: AppBar(title: Text(t.exports)),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 4, 16, 120),
        children: [
          SectionHeader(t.whatToExport),
          for (final s in _Scope.values)
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: AppCard(
                color: _scope == s ? cs.primary.withValues(alpha: .08) : null,
                onTap: () => setState(() => _scope = s),
                child: Row(children: [
                  IconBadge(s.icon, _scope == s ? cs.primary : cs.outline),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(s.label(t), style: const TextStyle(fontWeight: FontWeight.w700)),
                      Text(s.description(t), style: TextStyle(fontSize: 12.5, color: cs.onSurfaceVariant)),
                    ]),
                  ),
                  Icon(_scope == s ? Icons.radio_button_checked : Icons.radio_button_off, color: _scope == s ? cs.primary : cs.outline),
                ]),
              ),
            ),
          if (_scope != _Scope.all) ...[
            SectionHeader(t.period),
            Row(children: [
              Expanded(child: _MonthButton(t.fromMonth, _from, (p) => setState(() => _from = p))),
              const SizedBox(width: 10),
              Expanded(child: _MonthButton(t.toMonth, _to, (p) => setState(() => _to = p))),
            ]),
            const SizedBox(height: 8),
            Wrap(spacing: 8, children: [
              ActionChip(label: Text(t.thisMonth), onPressed: () => setState(() => _from = _to = Period.current())),
              ActionChip(
                  label: Text(t.last3Months),
                  onPressed: () => setState(() {
                        _to = Period.current();
                        _from = Period.add(_to, -2);
                      })),
              ActionChip(
                  label: Text(t.thisYear),
                  onPressed: () => setState(() {
                        _from = DateTime.now().year * 100 + 1;
                        _to = DateTime.now().year * 100 + 12;
                      })),
            ]),
          ],
          SectionHeader(t.format),
          SegmentedButton<ExportFormat>(
            segments: const [
              ButtonSegment(value: ExportFormat.excel, label: Text('Excel (.xlsx)'), icon: Icon(Icons.grid_on_rounded)),
              ButtonSegment(value: ExportFormat.csv, label: Text('CSV'), icon: Icon(Icons.text_snippet_outlined)),
            ],
            selected: {_format},
            onSelectionChanged: (s) => setState(() => _format = s.first),
          ),
          const SizedBox(height: 20),
          AppCard(
            color: AppColors.warning.withValues(alpha: .08),
            onTap: () async {
              setState(() => _busy = true);
              try {
                await shareFile(await BackupService.create());
              } finally {
                if (mounted) setState(() => _busy = false);
              }
            },
            child: Row(children: [
              const IconBadge(Icons.archive_rounded, AppColors.warning),
              const SizedBox(width: 14),
              Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(t.fullBackupZip, style: const TextStyle(fontWeight: FontWeight.w700)),
                  Text(t.fullBackupHelp, style: const TextStyle(fontSize: 12.5)),
                ]),
              ),
              const Icon(Icons.chevron_right_rounded),
            ]),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
          child: FilledButton.icon(
            onPressed: _busy ? null : _export,
            icon: _busy
                ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2))
                : const Icon(Icons.ios_share_rounded),
            label: Text(t.exportAndShare),
          ),
        ),
      ),
    );
  }
}

class _MonthButton extends StatelessWidget {
  final String Function(String) label;
  final int period;
  final ValueChanged<int> onChanged;
  const _MonthButton(this.label, this.period, this.onChanged);

  @override
  Widget build(BuildContext context) => OutlinedButton(
        onPressed: () async {
          final p = await pickMonth(context, period);
          if (p != null) onChanged(p);
        },
        child: Text(label(Period.label(period))),
      );
}
