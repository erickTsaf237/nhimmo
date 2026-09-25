import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import '../../core/dates.dart';
import '../../services/backup_service.dart';
import '../theme.dart';
import '../widgets.dart';
import '../../core/i18n.dart';

class BackupPage extends StatefulWidget {
  const BackupPage({super.key});

  @override
  State<BackupPage> createState() => _BackupPageState();
}

class _BackupPageState extends State<BackupPage> {
  bool _busy = false;
  late Future<List<BackupInfo>> _list = BackupService.list();

  void _refresh() => setState(() => _list = BackupService.list());

  Future<void> _run(Future<void> Function() action) async {
    setState(() => _busy = true);
    try {
      await action();
    } catch (e) {
      if (mounted) toast(context, context.t.errorWith('$e'), error: true);
    } finally {
      if (mounted) {
        setState(() => _busy = false);
        _refresh();
      }
    }
  }

  Future<void> _restoreBytes(Future<List<int>> Function() read) async {
    final ok = await confirm(
      context,
      context.t.restoreQ,
      context.t.restoreHelp,
      ok: context.t.restore,
      danger: true,
    );
    if (!ok || !mounted) return;
    final nav = Navigator.of(context);
    await _run(() async {
      final bytes = await read();
      await BackupService.restore(Uint8List.fromList(bytes));
      nav.popUntil((r) => r.isFirst);
    });
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(title: Text(context.t.backup)),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 4, 16, 32),
        children: [
          AppCard(
            color: AppColors.info.withValues(alpha: .08),
            child: Text(context.t.backupHelp),
          ),
          const SizedBox(height: 14),
          FilledButton.icon(
            onPressed: _busy
                ? null
                : () => _run(() async {
                      final f = await BackupService.create();
                      if (mounted) await shareFile(f, text: context.t.backupShareText);
                    }),
            icon: const Icon(Icons.backup_rounded),
            label: Text(context.t.createShareBackup),
          ),
          const SizedBox(height: 10),
          OutlinedButton.icon(
            onPressed: _busy
                ? null
                : () async {
                    final f = await FilePicker.pickFile(dialogTitle: context.t.chooseBackupFile);
                    if (f == null) return;
                    await _restoreBytes(() async => await f.readAsBytes());
                  },
            icon: const Icon(Icons.restore_rounded),
            label: Text(context.t.restoreFromFile),
          ),
          if (_busy) const Padding(padding: EdgeInsets.all(16), child: LinearProgressIndicator()),
          SectionHeader(context.t.localBackups),
          FutureBuilder<List<BackupInfo>>(
            future: _list,
            builder: (context, s) {
              final list = s.data ?? [];
              if (list.isEmpty) {
                return Text(context.t.noLocalBackup, style: TextStyle(color: cs.onSurfaceVariant));
              }
              return Column(children: [
                for (final b in list)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: AppCard(
                      child: Row(children: [
                        const IconBadge(Icons.archive_rounded, AppColors.warning, size: 40),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                            Text(Dates.dt(b.date), style: const TextStyle(fontWeight: FontWeight.w700)),
                            Text(context.t.sizeKb((b.size / 1024).toStringAsFixed(0)), style: TextStyle(fontSize: 12.5, color: cs.onSurfaceVariant)),
                          ]),
                        ),
                        IconButton(tooltip: context.t.share, onPressed: () => shareFile(b.file), icon: const Icon(Icons.share_rounded)),
                        IconButton(
                          tooltip: context.t.restore,
                          onPressed: _busy ? null : () => _restoreBytes(() => b.file.readAsBytes()),
                          icon: const Icon(Icons.restore_rounded),
                        ),
                      ]),
                    ),
                  ),
              ]);
            },
          ),
        ],
      ),
    );
  }
}
