import 'package:drift/drift.dart';
import 'package:drift_postgres/drift_postgres.dart';

class UserIdentitiesTable extends Table {
  @override
  String get tableName => 'user_identities';

  TextColumn get id => text()();
  TextColumn get userId => text()
      .named('user_id')
      .customConstraint('NOT NULL REFERENCES users(id) ON DELETE CASCADE')();
  TextColumn get providerId => text().named('provider_id')();
  TextColumn get externalId => text().named('external_id')();
  TextColumn get externalUsername => text().nullable().named('external_username')();
  TextColumn get status => text().withDefault(
    const Constant('Pending'),
  )(); // Linked, Pending, Failed
  TimestampColumn get createdAt => customType(PgTypes.timestampWithTimezone)
      .named('created_at')
      .withDefault(now())();
  TimestampColumn get updatedAt => customType(PgTypes.timestampWithTimezone)
      .nullable()
      .named('updated_at')();

  @override
  Set<Column> get primaryKey => {id};
}
