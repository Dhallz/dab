import 'package:drift/drift.dart';

import 'activities_table.dart';

class ActivityJiraIssueTable extends Table {
  @override
  String get tableName => 'activity_jira_issue';

  TextColumn get activityId =>
      text().references(ActivitiesTable, #id, onDelete: KeyAction.cascade)();

  TextColumn get issueKey => text().named('issue_key')();
  TextColumn get projectKey => text().named('project_key')();
  TextColumn get statusName => text().nullable().named('status_name')();

  @override
  Set<Column> get primaryKey => {activityId};
}
