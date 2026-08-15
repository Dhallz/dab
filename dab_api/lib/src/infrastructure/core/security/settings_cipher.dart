import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:pointycastle/export.dart';

/// [ARCH: INFRASTRUCTURE]
/// ROLE: AES-256-CBC encryption for user provider credential settings JSON.
/// CONTRACT: Ciphertext is `ivBase64:cipherBase64`. Never log plaintext or keys.
/// CONSTRAINTS: Key material is SHA-256 of [DAB_CREDENTIALS_KEY] (JWT secret fallback).
class SettingsCipher {
  SettingsCipher(String secret)
    : _key = Uint8List.fromList(sha256.convert(utf8.encode(secret)).bytes);

  final Uint8List _key;

  Uint8List _randomIv() {
    final random = Random.secure();
    return Uint8List.fromList(
      List<int>.generate(16, (_) => random.nextInt(256)),
    );
  }

  PaddedBlockCipher _cipher({required bool forEncryption, required Uint8List iv}) {
    final params = PaddedBlockCipherParameters<ParametersWithIV<KeyParameter>, Null>(
      ParametersWithIV<KeyParameter>(KeyParameter(_key), iv),
      null,
    );
    return PaddedBlockCipherImpl(
      PKCS7Padding(),
      CBCBlockCipher(AESEngine()),
    )..init(forEncryption, params);
  }

  String encryptMap(Map<String, dynamic> settings) {
    final iv = _randomIv();
    final encrypted = _cipher(forEncryption: true, iv: iv).process(
      Uint8List.fromList(utf8.encode(jsonEncode(settings))),
    );
    return '${base64Encode(iv)}:${base64Encode(encrypted)}';
  }

  Map<String, dynamic> decryptMap(String ciphertext) {
    final trimmed = ciphertext.trim();
    if (trimmed.isEmpty || trimmed == '{}') {
      return <String, dynamic>{};
    }
    final sep = trimmed.indexOf(':');
    if (sep <= 0 || sep == trimmed.length - 1) {
      throw const FormatException('Invalid credential ciphertext');
    }
    final iv = base64Decode(trimmed.substring(0, sep));
    final encrypted = base64Decode(trimmed.substring(sep + 1));
    final json = utf8.decode(
      _cipher(forEncryption: false, iv: iv).process(encrypted),
    );
    final decoded = jsonDecode(json);
    if (decoded is Map<String, dynamic>) return decoded;
    if (decoded is Map) {
      return decoded.map((key, value) => MapEntry(key.toString(), value));
    }
    return <String, dynamic>{};
  }
}
