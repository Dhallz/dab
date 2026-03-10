import 'package:drift/drift.dart';

import 'groups_table.dart';
import 'users_table.dart';

class GroupMembersTable extends Table {
  @override
  String get tableName => 'group_members';

  TextColumn get groupId =>
      text().references(GroupsTable, #id, onDelete: KeyAction.cascade)();
  TextColumn get userId =>
      text().references(UsersTable, #id, onDelete: KeyAction.cascade)();

  @override
  Set<Column> get primaryKey => {groupId, userId};
}
