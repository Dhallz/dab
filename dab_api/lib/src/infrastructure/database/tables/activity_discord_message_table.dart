import 'package:drift/drift.dart';

import 'activities_table.dart';

/// [ARCH: INFRASTRUCTURE]
/// ROLE: Table-per-type storage for Discord message metadata.
class ActivityDiscordMessageTable extends Table {
  @override
  String get tableName => 'activity_discord_message';

  TextColumn get activityId =>
      text().references(ActivitiesTable, #id, onDelete: KeyAction.cascade)();

  TextColumn get guildId => text().nullable()();
  TextColumn get channelId => text().nullable()();
  TextColumn get messageId => text().nullable()();
  TextColumn get replyToId => text().nullable()();

  @override
  Set<Column> get primaryKey => {activityId};
}
