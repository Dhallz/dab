import 'package:drift/drift.dart';

import 'activities_table.dart';

class ActivityPhorgeTable extends Table {
  @override
  String get tableName => 'activity_phorge';

  TextColumn get activityId =>
      text().references(ActivitiesTable, #id, onDelete: KeyAction.cascade)();

  TextColumn get taskPhid => text().nullable()();
  TextColumn get revisionId => text().nullable()();
  TextColumn get tags => text().nullable()();

  @override
  Set<Column> get primaryKey => {activityId};
}
