import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;

import 'app_state.dart';

/// Photos compressées (compteurs, états des lieux), stockées dans le dossier de l'app.
class PhotoService {
  static final _picker = ImagePicker();

  /// Renvoie le nom de fichier relatif, ou null si annulé.
  static Future<String?> take({bool camera = true}) async {
    final x = await _picker.pickImage(
      source: camera ? ImageSource.camera : ImageSource.gallery,
      maxWidth: 1280,
      maxHeight: 1280,
      imageQuality: 60,
    );
    if (x == null) return null;
    final name = 'img_${DateTime.now().millisecondsSinceEpoch}.jpg';
    await File(x.path).copy(p.join(App.photosDir.path, name));
    return name;
  }

  static File? file(String? name) {
    if (name == null || name.isEmpty) return null;
    final f = File(p.join(App.photosDir.path, name));
    return f.existsSync() ? f : null;
  }

  static Future<void> delete(String? name) async {
    final f = file(name);
    if (f != null) await f.delete();
  }
}
