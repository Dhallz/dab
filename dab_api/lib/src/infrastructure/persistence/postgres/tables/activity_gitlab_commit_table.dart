import 'package:drift/drift.dart';

import 'activities_table.dart';

/// [ARCH: INFRASTRUCTURE]
/// ROLE: Table-per-type storage for GitLab commit metadata.
class ActivityGitlabCommitTable extends Table {
  @override
  String get tableName => 'activity_gitlab_commit';

  TextColumn get activityId =>
      text().references(ActivitiesTable, #id, onDelete: KeyAction.cascade)();

  /// Full project path (e.g. `group/project`).
  TextColumn get project => text().nullable()();
  TextColumn get branch => text().nullable()();

  @override
  Set<Column> get primaryKey => {activityId};
}
