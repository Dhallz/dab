import 'package:drift/drift.dart';
import 'package:drift_postgres/drift_postgres.dart';

/// Per-user Follow pins for Dashboard inbox objects (not git).
@TableIndex(
  name: 'idx_activity_follows_object',
  columns: {#providerId, #objectKey},
)
class ActivityFollowsTable extends Table {
  @override
  String get tableName => 'activity_follows';

  TextColumn get id => text()();
  TextColumn get userId => text()
      .named('user_id')
      .customConstraint('NOT NULL REFERENCES users(id) ON DELETE CASCADE')();
  TextColumn get providerId => text().named('provider_id')();
  TextColumn get objectKey => text().named('object_key')();
  TextColumn get title => text().nullable()();
  TextColumn get url => text().nullable()();
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
    {userId, providerId, objectKey},
  ];
}
