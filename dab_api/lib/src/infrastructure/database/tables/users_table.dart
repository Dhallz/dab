import 'package:drift/drift.dart';
import 'package:drift_postgres/drift_postgres.dart';

class UsersTable extends Table {
  @override
  String get tableName => 'users';

  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get email => text().unique()();
  TextColumn get passwordHash => text().named('password_hash')();
  TextColumn get role => text().withDefault(const Constant('Standard'))();
  TextColumn get phorgePhid => text().nullable().named('phorge_phid')();
  TextColumn get phorgeUsername => text().nullable().named('phorge_username')();
  TimestampColumn get createdAt =>
      customType(PgTypes.timestampWithTimezone).named('created_at')();
  TimestampColumn get updatedAt => customType(PgTypes.timestampWithTimezone)
      .nullable()
      .named('updated_at')();
  TextColumn get avatarUrl => text().nullable().named('avatar_url')();

  @override
  Set<Column> get primaryKey => {id};
}
