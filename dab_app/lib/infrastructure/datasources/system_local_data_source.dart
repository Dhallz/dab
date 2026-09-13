import 'package:objectbox/objectbox.dart';
import '../../objectbox.g.dart';
import '../core/local/objectbox_store.dart';
import '../core/local/records/app_settings_record.dart';

/// [ARCH: INFRASTRUCTURE_SOURCE]
/// ROLE: Persistence layer for local App Settings and Sync Tokens using ObjectBox.
/// CONTRACT: Provides synchronous/asynchronous CRUD for the [AppSettingsRecord] box.
/// CONSTRAINTS: Manages a single settings record (ID 1). Focuses on [Record] types.
class SystemLocalDataSource {
  final Box<AppSettingsRecord> _box;

  SystemLocalDataSource(ObjectBoxStore store)
    : _box = store.store.box<AppSettingsRecord>();

  Future<AppSettingsRecord?> getSettings() async {
    return _box.get(1);
  }

  Future<void> saveSettings(AppSettingsRecord record) async {
    final existing = _box.get(1);
    if (existing != null) {
      record.id = 1;
    } else {
      record.id = 0; // First insertion, let ObjectBox assign ID 1
    }
    _box.put(record);
  }
}
