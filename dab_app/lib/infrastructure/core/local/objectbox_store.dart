import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../../../objectbox.g.dart';

class ObjectBoxStore {
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

    final store = await openStore(directory: dbPath);
    return ObjectBoxStore._create(store);
  }
}
