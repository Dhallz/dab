import 'package:drift/drift.dart';

import 'activities_table.dart';

class ActivityGithubCommitTable extends Table {
  @override
  String get tableName => 'activity_github_commit';

  TextColumn get activityId =>
      text().references(ActivitiesTable, #id, onDelete: KeyAction.cascade)();

  TextColumn get repo => text().nullable()();
  TextColumn get branch => text().nullable()();

  @override
  Set<Column> get primaryKey => {activityId};
}
