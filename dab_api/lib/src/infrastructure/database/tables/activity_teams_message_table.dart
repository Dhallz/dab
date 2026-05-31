import 'package:drift/drift.dart';

import 'activities_table.dart';

/// [ARCH: INFRASTRUCTURE]
/// ROLE: Table-per-type storage for Microsoft Teams message metadata.
class ActivityTeamsMessageTable extends Table {
  @override
  String get tableName => 'activity_teams_message';

  TextColumn get activityId =>
      text().references(ActivitiesTable, #id, onDelete: KeyAction.cascade)();

  TextColumn get tenantId => text().nullable()();
  TextColumn get teamId => text().nullable()();
  TextColumn get channelId => text().nullable()();
  TextColumn get messageId => text().nullable()();
  TextColumn get replyToId => text().nullable()();

  @override
  Set<Column> get primaryKey => {activityId};
}
