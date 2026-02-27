import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../../../objectbox.g.dart';

class ObjectBoxStore {
  late final Store store;

  ObjectBoxStore._create(this.store);

  /// Create an instance of ObjectBox to use throughout the app.
  static Future<ObjectBoxStore> create() async {
    final docsDir = await getApplicationDocumentsDirectory();
    // Future: Use p.join(docsDir.path, "obx-db") if needed
    final store = await openStore(directory: p.join(docsDir.path, "obx-db"));
    return ObjectBoxStore._create(store);
  }
}
