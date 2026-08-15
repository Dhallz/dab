import 'package:drift/drift.dart';

import 'activities_table.dart';

/// [ARCH: INFRASTRUCTURE]
/// ROLE: Table-per-type storage for Bitbucket commit metadata.
class ActivityBitbucketCommitTable extends Table {
  @override
  String get tableName => 'activity_bitbucket_commit';

  TextColumn get activityId =>
      text().references(ActivitiesTable, #id, onDelete: KeyAction.cascade)();

  /// Full repository slug (e.g. `workspace/repo`).
  TextColumn get repo => text().nullable()();
  TextColumn get branch => text().nullable()();

  @override
  Set<Column> get primaryKey => {activityId};
}
