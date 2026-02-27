import 'package:objectbox/objectbox.dart';

import '../../objectbox.g.dart';
import '../core/local/objectbox_store.dart';
import '../core/local/records/app_settings_record.dart';

class SystemLocalDataSource {
  final Box<AppSettingsRecord> _box;

  SystemLocalDataSource(ObjectBoxStore store)
    : _box = store.store.box<AppSettingsRecord>();

  Future<AppSettingsRecord?> getSettings() async {
    return _box.get(1);
  }

  Future<void> saveSettings(AppSettingsRecord record) async {
    record.id = 1; // Singleton record
    _box.put(record);
  }
}
