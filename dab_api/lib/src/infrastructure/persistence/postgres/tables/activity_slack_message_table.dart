import 'package:drift/drift.dart';

import 'activities_table.dart';

class ActivitySlackMessageTable extends Table {
  @override
  String get tableName => 'activity_slack_message';

  TextColumn get activityId =>
      text().references(ActivitiesTable, #id, onDelete: KeyAction.cascade)();

  TextColumn get workspaceId => text().nullable()();
  TextColumn get channelId => text().nullable()();
  TextColumn get threadTs => text().nullable()();
  TextColumn get messageTs => text().nullable()();

  @override
  Set<Column> get primaryKey => {activityId};
}
