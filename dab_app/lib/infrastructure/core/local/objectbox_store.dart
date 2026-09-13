import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../../../objectbox.g.dart';

class ObjectBoxStore {
  /// POSIX semaphore prefix for sandboxed macOS. Must match
  /// `com.apple.security.application-groups` in the macOS entitlements and be
  /// at most 19 characters.
  static const macosApplicationGroupId = 'dab.objectbox';

  late final Store store;

  ObjectBoxStore._create(this.store);

  /// Create an instance of ObjectBox to use throughout the app.
  static Future<ObjectBoxStore> create() async {
    final supportDir = await getApplicationSupportDirectory();
    final dbPath = p.join(supportDir.path, "obx-db");
    print('ObjectBox: Opening store at: $dbPath');

    // Ensure the directory exists
    final directory = Directory(dbPath);
    if (!await directory.exists()) {
      await directory.create(recursive: true);
    }

    final store = await openStore(
      directory: dbPath,
      macosApplicationGroup: macosApplicationGroupId,
    );
    return ObjectBoxStore._create(store);
  }
}
