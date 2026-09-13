import 'package:drift/drift.dart';
import 'package:drift_postgres/drift_postgres.dart';

class ProviderConfigsTable extends Table {
  @override
  String get tableName => 'provider_configs';

  TextColumn get id => text()();
  TextColumn get name => text().named('name')();
  TextColumn get baseUrl => text().named('base_url')();
  /// Stored as 0/1 in Postgres (avoids BOOL vs driver mapping issues).
  IntColumn get isActive =>
      integer().withDefault(const Constant(1)).named('is_active')();
  TextColumn get iconUrl => text().nullable().named('icon_url')();
  TextColumn get settings =>
      text().withDefault(const Constant('{}')).named('settings')();
  TimestampColumn get updatedAt => customType(PgTypes.timestampWithTimezone)
      .nullable()
      .named('updated_at')();

  @override
  Set<Column> get primaryKey => {id};
}
