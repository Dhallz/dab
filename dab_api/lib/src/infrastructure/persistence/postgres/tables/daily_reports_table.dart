import 'package:drift/drift.dart';
import 'package:drift_postgres/drift_postgres.dart';

/// Per-user org-calendar daily report header (DAB-99).
@TableIndex(name: 'idx_daily_reports_user_date', columns: {#userId, #reportDate})
class DailyReportsTable extends Table {
  @override
  String get tableName => 'daily_reports';

  TextColumn get id => text()();
  TextColumn get userId => text()
      .named('user_id')
      .customConstraint('NOT NULL REFERENCES users(id) ON DELETE CASCADE')();
  TextColumn get reportDate => text().named('report_date')();

  /// Stored as 0/1 in Postgres (avoids BOOL vs driver mapping issues).
  IntColumn get includeFollowing => integer()
      .withDefault(const Constant(0))
      .named('include_following')();
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
    {userId, reportDate},
  ];
}
