import 'package:drift/drift.dart';

class GroupsTable extends Table {
  @override
  String get tableName => 'groups';

  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get type => text()(); // 'custom' or 'provider'
  TextColumn get iconUrl => text().nullable().named('icon_url')();
  TextColumn get providerName => text().nullable().named('provider_name')();

  @override
  Set<Column> get primaryKey => {id};
}
