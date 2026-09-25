import 'dart:convert';

import 'package:cryptography/cryptography.dart';

import 'app_state.dart';

/// Types de documents signés.
enum DocType {
  invoice('F'),
  receipt('Q'),
  exit('S');

  final String code;
  const DocType(this.code);

  static DocType? fromCode(String c) =>
      DocType.values.where((d) => d.code == c).firstOrNull;
}

class QrPayload {
  final DocType type;
  final int id;
  final String number;
  final int amount;
  final String signature;
  QrPayload(this.type, this.id, this.number, this.amount, this.signature);

  String get message => SignatureService.message(type, id, number, amount);
}

/// Signature Ed25519 hors ligne. La clé privée est stockée dans la base
/// (et donc incluse dans les sauvegardes) : un QR reste vérifiable après restauration.
class SignatureService {
  static const _prefix = 'MYIMMO';
  static final _algo = Ed25519();
  static SimpleKeyPair? _keyPair;
  static SimplePublicKey? _publicKey;

  static String message(DocType t, int id, String number, int amount) =>
      '$_prefix|${t.code}|$id|$number|$amount';

  static Future<void> _ensureKeys() async {
    if (_keyPair != null) return;
    var seedB64 = await AppSettings.getRaw('signSeed');
    if (seedB64 == null) {
      final kp = await _algo.newKeyPair();
      seedB64 = base64Encode(await kp.extractPrivateKeyBytes());
      await AppSettings.setRaw('signSeed', seedB64);
    }
    _keyPair = await _algo.newKeyPairFromSeed(base64Decode(seedB64));
    _publicKey = await _keyPair!.extractPublicKey();
  }

  /// À appeler après une restauration (autre clé possible).
  static void reset() {
    _keyPair = null;
    _publicKey = null;
  }

  static Future<String> qrData(DocType t, int id, String number, int amount) async {
    await _ensureKeys();
    final msg = message(t, id, number, amount);
    final sig = await _algo.sign(utf8.encode(msg), keyPair: _keyPair!);
    return '$msg|${base64UrlEncode(sig.bytes).replaceAll('=', '')}';
  }

  static QrPayload? parse(String raw) {
    final parts = raw.split('|');
    if (parts.length != 6 || parts[0] != _prefix) return null;
    final type = DocType.fromCode(parts[1]);
    final id = int.tryParse(parts[2]);
    final amount = int.tryParse(parts[4]);
    if (type == null || id == null || amount == null) return null;
    return QrPayload(type, id, parts[3], amount, parts[5]);
  }

  static Future<bool> verify(QrPayload p) async {
    await _ensureKeys();
    try {
      final sig = base64Url.decode(base64Url.normalize(p.signature));
      return _algo.verify(utf8.encode(p.message),
          signature: Signature(sig, publicKey: _publicKey!));
    } catch (_) {
      return false;
    }
  }

  static Future<String> fingerprint() async {
    await _ensureKeys();
    final bytes = _publicKey!.bytes;
    final hex = bytes.take(8).map((b) => b.toRadixString(16).padLeft(2, '0')).join();
    return hex.toUpperCase().replaceAllMapped(RegExp(r'.{4}'), (m) => '${m[0]} ').trim();
  }
}
