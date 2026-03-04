import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

class TokenStorage {
  static const _fileName = 'tokens.json';

  Future<File> get _file async {
    final directory = await getApplicationSupportDirectory();
    return File(p.join(directory.path, _fileName));
  }

  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    final file = await _file;
    final json = jsonEncode({
      'accessToken': accessToken,
      'refreshToken': refreshToken,
    });
    await file.writeAsString(json);
  }

  Future<Map<String, String>?> readTokens() async {
    try {
      final file = await _file;
      if (!await file.exists()) return null;
      final content = await file.readAsString();
      final Map<String, dynamic> data = jsonDecode(content);
      return {
        'accessToken': data['accessToken'] as String,
        'refreshToken': data['refreshToken'] as String,
      };
    } catch (e) {
      return null;
    }
  }

  Future<void> clear() async {
    final file = await _file;
    if (await file.exists()) {
      await file.delete();
    }
  }
}
