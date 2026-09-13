import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

/// [ARCH: INFRASTRUCTURE]
/// ROLE: Persist the last successful DAB API origin next to session files.
class ApiOriginStorage {
  static const _fileName = 'api_origin.txt';

  Future<File> get _file async {
    final directory = await getApplicationSupportDirectory();
    return File(p.join(directory.path, _fileName));
  }

  Future<String?> read() async {
    try {
      final file = await _file;
      if (!await file.exists()) return null;
      final value = (await file.readAsString()).trim();
      return value.isEmpty ? null : value;
    } catch (_) {
      return null;
    }
  }

  Future<void> write(String origin) async {
    final file = await _file;
    await file.writeAsString(origin);
  }
}
