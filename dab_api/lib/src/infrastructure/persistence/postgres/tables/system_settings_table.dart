import 'package:drift/drift.dart';

class SystemSettingsTable extends Table {
  @override
  String get tableName => 'system_settings';

  TextColumn get key => text()();
  TextColumn get value => text()();

  @override
  Set<Column> get primaryKey => {key};
}
