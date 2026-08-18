import 'package:drift/drift.dart';
import 'package:drift_postgres/drift_postgres.dart';

/// Per-user FCM/APNs device tokens for inbox wakes.
class UserDeviceTokensTable extends Table {
  @override
  String get tableName => 'user_device_tokens';

  TextColumn get id => text()();
  TextColumn get userId => text()
      .named('user_id')
      .customConstraint('NOT NULL REFERENCES users(id) ON DELETE CASCADE')();
  TextColumn get platform => text()();
  TextColumn get token => text()();
  TimestampColumn get createdAt => customType(
    PgTypes.timestampWithTimezone,
  ).named('created_at').withDefault(now())();
  TimestampColumn get updatedAt => customType(
    PgTypes.timestampWithTimezone,
  ).nullable().named('updated_at')();

  @override
  Set<Column> get primaryKey => {id};

  @override
  List<Set<Column>> get uniqueKeys => [
    {userId, token},
  ];
}
