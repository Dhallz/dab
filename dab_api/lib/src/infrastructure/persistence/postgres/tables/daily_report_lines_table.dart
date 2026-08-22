import 'package:drift/drift.dart';
import 'package:drift_postgres/drift_postgres.dart';

import 'daily_reports_table.dart';

/// Curated lines on a daily report. Cascade-deleted with the parent report.
class DailyReportLinesTable extends Table {
  @override
  String get tableName => 'daily_report_lines';

  TextColumn get id => text()();
  TextColumn get reportId => text()
      .named('report_id')
      .references(DailyReportsTable, #id, onDelete: KeyAction.cascade)();
  TextColumn get subjectKey => text().named('subject_key')();

  /// Stored as 0/1 in Postgres (avoids BOOL vs driver mapping issues).
  IntColumn get included =>
      integer().withDefault(const Constant(1)).named('included')();
  TextColumn get note => text().nullable()();
  TextColumn get role =>
      text().withDefault(const Constant('directed'))();
  TextColumn get title => text().nullable()();
  TextColumn get url => text().nullable()();
  TimestampColumn get occurredAt => customType(
    PgTypes.timestampWithTimezone,
  ).nullable().named('occurred_at')();
  TextColumn get providerId => text().nullable().named('provider_id')();

  @override
  Set<Column> get primaryKey => {id};

  @override
  List<Set<Column>> get uniqueKeys => [
    {reportId, subjectKey},
  ];
}
