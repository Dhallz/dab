import 'package:drift/drift.dart';
import 'package:drift_postgres/drift_postgres.dart';

class SessionsTable extends Table {
  @override
  String get tableName => 'sessions';

  TextColumn get id => text()();
  TextColumn get userId => text().named('user_id')();
  TextColumn get refreshToken => text().named('token')();
  TimestampColumn get expiresAt =>
      customType(PgTypes.timestampWithTimezone).named('expires_at')();
  TextColumn get deviceInfo => text().nullable().named('device_info')();

  @override
  Set<Column> get primaryKey => {id};
}
