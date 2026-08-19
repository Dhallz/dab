import 'package:drift/drift.dart';

import 'activities_table.dart';

class ActivityFigmaFileTable extends Table {
  @override
  String get tableName => 'activity_figma_file';

  TextColumn get activityId =>
      text().references(ActivitiesTable, #id, onDelete: KeyAction.cascade)();

  TextColumn get fileKey => text().named('file_key')();
  TextColumn get commentId => text().nullable().named('comment_id')();
  TextColumn get lastTouchedBy => text().nullable().named('last_touched_by')();

  @override
  Set<Column> get primaryKey => {activityId};
}
