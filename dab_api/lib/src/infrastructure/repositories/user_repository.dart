import 'package:drift/drift.dart' hide Column;
import 'package:fpdart/fpdart.dart' hide Group;
import 'package:uuid/uuid.dart';

import '../../domain/core/failure.dart';
import '../../domain/entities/group.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/abs_i_user_repository.dart';
import '../database/app_database.dart';

class UserRepository implements IUserRepository {
  final AppDatabase _db;

  UserRepository(this._db);

  @override
  Future<Either<DatabaseFailure, List<User>>> getUsers() async {
    try {
      final users = await _db.select(_db.usersTable).get();
      return right(users);
    } catch (e) {
      return left(DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<Either<DatabaseFailure, User>> getUser(String id) async {
    try {
      final user = await (_db.select(
        _db.usersTable,
      )..where((t) => t.id.equals(id))).getSingle();
      return right(user);
    } catch (e) {
      return left(DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<Either<DatabaseFailure, List<User>>> getUsersByGroup(
    String groupId,
  ) async {
    try {
      final query = _db.select(_db.usersTable).join([
        innerJoin(
          _db.groupMembersTable,
          _db.groupMembersTable.userId.equalsExp(_db.usersTable.id),
        ),
      ])..where(_db.groupMembersTable.groupId.equals(groupId));

      final rows = await query.get();
      return right(rows.map((row) => row.readTable(_db.usersTable)).toList());
    } catch (e) {
      return left(DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<Either<DatabaseFailure, List<Group>>> getGroups() async {
    try {
      final groups = await _db.select(_db.groupsTable).get();
      final List<Group> result = [];

      for (final group in groups) {
        final membersResult = await getUsersByGroup(group.id);
        result.add(
          Group(
            id: group.id,
            name: group.name,
            type: GroupType.values.firstWhere(
              (e) => e.name == group.type,
              orElse: () => GroupType.custom,
            ),
            members: membersResult.getOrElse((_) => []),
            iconUrl: group.iconUrl,
            providerName: group.providerName,
          ),
        );
      }
      return right(result);
    } catch (e) {
      return left(DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<Either<DatabaseFailure, Group>> saveGroup(Group group) async {
    return _db.transaction(() async {
      try {
        final effectiveId = group.id.isEmpty ? const Uuid().v4() : group.id;
        final savedGroup = group.copyWith(id: effectiveId);

        await _db
            .into(_db.groupsTable)
            .insertOnConflictUpdate(
              GroupsTableCompanion.insert(
                id: effectiveId,
                name: savedGroup.name,
                type: savedGroup.type.name,
                iconUrl: Value(savedGroup.iconUrl),
                providerName: Value(savedGroup.providerName),
              ),
            );

        // Update members
        await (_db.delete(
          _db.groupMembersTable,
        )..where((t) => t.groupId.equals(effectiveId))).go();

        for (final member in savedGroup.members) {
          await _db
              .into(_db.groupMembersTable)
              .insert(
                GroupMembersTableCompanion.insert(
                  groupId: effectiveId,
                  userId: member.id,
                ),
              );
        }

        return right(savedGroup);
      } catch (e) {
        return left(DatabaseFailure(e.toString()));
      }
    });
  }

  @override
  Future<Either<DatabaseFailure, void>> deleteGroup(String id) async {
    try {
      await (_db.delete(_db.groupsTable)..where((t) => t.id.equals(id))).go();
      return right(null);
    } catch (e) {
      return left(DatabaseFailure(e.toString()));
    }
  }
}
