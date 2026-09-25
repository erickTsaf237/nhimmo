import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:archive/archive.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as p;

import '../core/i18n.dart';
import '../data/database.dart';
import 'app_state.dart';
import 'signature_service.dart';

class BackupInfo {
  final File file;
  final DateTime date;
  final int size;
  BackupInfo(this.file, this.date, this.size);
}

/// Sauvegarde complète (base + photos) dans un ZIP, et restauration.
class BackupService {
  static const _format = 'myimmo-backup';

  static Future<File> create() async {
    final tmp = await Directory.systemTemp.createTemp('myimmo');
    try {
      final dbCopy = p.join(tmp.path, AppDatabase.fileName);
      await App.db.exportTo(dbCopy);

      final archive = Archive();
      final manifest = utf8.encode(jsonEncode({
        'format': _format,
        'version': 1,
        'schema': App.db.schemaVersion,
        'date': DateTime.now().toIso8601String(),
      }));
      archive.addFile(ArchiveFile('manifest.json', manifest.length, manifest));
      final dbBytes = await File(dbCopy).readAsBytes();
      archive.addFile(ArchiveFile(AppDatabase.fileName, dbBytes.length, dbBytes));
      if (await App.photosDir.exists()) {
        await for (final f in App.photosDir.list()) {
          if (f is File) {
            final b = await f.readAsBytes();
            archive.addFile(ArchiveFile('photos/${p.basename(f.path)}', b.length, b));
          }
        }
      }
      final bytes = ZipEncoder().encode(archive)!;
      final stamp = DateFormat('yyyyMMdd-HHmmss').format(DateTime.now());
      final out = File(p.join(App.backupsDir.path, 'nhimmo-sauvegarde-$stamp.zip'));
      await out.writeAsBytes(bytes, flush: true);
      await _prune();
      return out;
    } finally {
      await tmp.delete(recursive: true);
    }
  }

  /// Garde les 10 sauvegardes locales les plus récentes.
  static Future<void> _prune() async {
    final all = await list();
    for (final b in all.skip(10)) {
      await b.file.delete();
    }
  }

  static Future<List<BackupInfo>> list() async {
    if (!await App.backupsDir.exists()) return [];
    final files = await App.backupsDir
        .list()
        .where((e) => e is File && e.path.endsWith('.zip'))
        .cast<File>()
        .toList();
    final out = <BackupInfo>[];
    for (final f in files) {
      final st = await f.stat();
      out.add(BackupInfo(f, st.modified, st.size));
    }
    out.sort((a, b) => b.date.compareTo(a.date));
    return out;
  }

  /// Remplace toutes les données par celles de la sauvegarde.
  static Future<void> restore(Uint8List zipBytes) async {
    final archive = ZipDecoder().decodeBytes(zipBytes);
    final manifestFile = archive.findFile('manifest.json');
    final dbFile = archive.findFile(AppDatabase.fileName);
    if (manifestFile == null || dbFile == null) {
      throw FormatException(I18n.ui.backupNotMyImmo);
    }
    final manifest = jsonDecode(utf8.decode(manifestFile.content as List<int>));
    if (manifest['format'] != _format) {
      throw FormatException(I18n.ui.backupUnknownFormat);
    }
    if ((manifest['schema'] as int) > App.db.schemaVersion) {
      throw FormatException(I18n.ui.backupTooRecent);
    }

    // Sauvegarde de sécurité de l'état actuel avant d'écraser.
    await create();

    await App.db.close();
    final target = await AppDatabase.file();
    for (final suffix in ['', '-wal', '-shm', '-journal']) {
      final f = File('${target.path}$suffix');
      if (await f.exists()) await f.delete();
    }
    await target.writeAsBytes(dbFile.content as List<int>, flush: true);

    if (await App.photosDir.exists()) await App.photosDir.delete(recursive: true);
    await App.photosDir.create(recursive: true);
    for (final f in archive.files) {
      if (f.isFile && f.name.startsWith('photos/')) {
        final name = p.basename(f.name);
        await File(p.join(App.photosDir.path, name))
            .writeAsBytes(f.content as List<int>, flush: true);
      }
    }
    SignatureService.reset();
    await App.reopen();
  }
}
