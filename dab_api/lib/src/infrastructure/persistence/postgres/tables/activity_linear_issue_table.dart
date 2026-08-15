import 'package:drift/drift.dart';

import 'activities_table.dart';

/// [ARCH: INFRASTRUCTURE]
/// ROLE: Table-per-type storage for Linear issue metadata.
class ActivityLinearIssueTable extends Table {
  @override
  String get tableName => 'activity_linear_issue';

  TextColumn get activityId =>
      text().references(ActivitiesTable, #id, onDelete: KeyAction.cascade)();

  TextColumn get identifier => text().named('identifier')();
  TextColumn get teamKey => text().named('team_key')();
  TextColumn get statusName => text().nullable().named('status_name')();

  @override
  Set<Column> get primaryKey => {activityId};
}
