import 'package:drift/drift.dart' hide Column;
import 'package:fpdart/fpdart.dart' hide Group;
import 'package:uuid/uuid.dart';

import '../../domain/core/failure.dart';
import '../../domain/entities/group/group.dart';
import '../../domain/entities/group/group_type.dart';
import '../../domain/entities/user/user.dart';
import '../../domain/entities/user/user_identity.dart';
import '../../domain/entities/user/user_identity_status.dart';
import '../../domain/repositories/abs_i_user_repository.dart';
import '../database/app_database.dart';
import '../database/drift_row_mappers.dart';

/// [ARCH: INFRASTRUCTURE_REPOSITORY]
/// ROLE: Persistence implementation for User directory and Team Groupings.
/// CONTRACT: Implements [IUserRepository] using [AppDatabase].
/// CONSTRAINTS: Handles many-to-many relationships for groups. Must ensure transactional integrity on group saves.
class UserRepository implements IUserRepository {
  final AppDatabase _db;

  UserRepository(this._db);

  /// Retrieves all users from the database.
  @override
  Future<Either<DatabaseFailure, List<User>>> getUsers() async {
    try {
      final rows = await _db.select(_db.usersTable).get();
      return right(rows.map(userFromUsersRow).toList());
    } catch (e) {
      return left(DatabaseFailure(e.toString()));
    }
  }

  /// Fetches a specific user by its primary identifier.
  @override
  Future<Either<Failure, User>> getUser(String id) async {
    try {
      final row = await (_db.select(
        _db.usersTable,
      )..where((t) => t.id.equals(id))).getSingleOrNull();
      if (row == null) {
        return left(NotFoundFailure('User not found: $id'));
      }
      return right(userFromUsersRow(row));
    } catch (e) {
      return left(DatabaseFailure(e.toString()));
    }
  }

  /// Finds a user by their unique email.
  @override
  Future<Either<DatabaseFailure, User?>> findByEmail(String email) async {
    try {
      final row = await (_db.select(
        _db.usersTable,
      )..where((t) => t.email.equals(email))).getSingleOrNull();
      return right(row != null ? userFromUsersRow(row) : null);
    } catch (e) {
      return left(DatabaseFailure(e.toString()));
    }
  }

  /// Resolves group membership using a JOIN on [groupMembersTable].
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
      return right(
        rows
            .map((row) => userFromUsersRow(row.readTable(_db.usersTable)))
            .toList(),
      );
    } catch (e) {
      return left(DatabaseFailure(e.toString()));
    }
  }

  /// Upserts user data.
  @override
  Future<Either<DatabaseFailure, void>> saveUser(User user) async {
    try {
      await _db
          .into(_db.usersTable)
          .insertOnConflictUpdate(
            UsersTableCompanion.insert(
              id: user.id,
              name: user.name,
              email: user.email,
              passwordHash: user.passwordHash,
              role: Value(user.role.name),
              phorgePhid: Value(user.phorgePhid),
              phorgeUsername: Value(user.phorgeUsername),
              createdAt: toPgDateTime(user.createdAt),
              updatedAt: Value(toPgDateTime(DateTime.now())),
              avatarUrl: Value(user.avatarUrl),
            ),
          );
      return right(null);
    } catch (e) {
      return left(DatabaseFailure(e.toString()));
    }
  }

  /// Retrieves all groups and hydydrates their member lists.
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

  /// Saves a group and its memberships within a single transaction.
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

        // Update members: Clear and replace to ensure consistency.
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

  /// Permanently removes a group record.
  @override
  Future<Either<DatabaseFailure, void>> deleteGroup(String id) async {
    try {
      await (_db.delete(_db.groupsTable)..where((t) => t.id.equals(id))).go();
      return right(null);
    } catch (e) {
      return left(DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<Either<DatabaseFailure, UserIdentity>> linkIdentity(
    UserIdentity identity,
  ) async {
    try {
      final companion = UserIdentitiesTableCompanion.insert(
        id: identity.id,
        userId: identity.userId,
        providerId: identity.providerId,
        externalId: identity.externalId,
        externalUsername: Value(identity.externalUsername),
        status: Value(identity.status.name),
        createdAt: Value(toPgDateTime(identity.createdAt)),
        updatedAt: Value(toPgDateTimeOrNull(identity.updatedAt)),
      );
      await _db.into(_db.userIdentitiesTable).insertOnConflictUpdate(companion);
      return right(identity);
    } catch (e) {
      return left(DatabaseFailure('Failed to link identity: $e'));
    }
  }

  @override
  Future<Either<DatabaseFailure, List<UserIdentity>>> getIdentities(
    String userId,
  ) async {
    try {
      final query = _db.select(_db.userIdentitiesTable)
        ..where((t) => t.userId.equals(userId));
      final rows = await query.get();
      return right(rows.map(_mapToIdentity).toList());
    } catch (e) {
      return left(DatabaseFailure('Failed to fetch user identities: $e'));
    }
  }

  @override
  Future<Either<DatabaseFailure, UserIdentity?>> getIdentity(
    String userId,
    String providerId,
  ) async {
    try {
      final query = _db.select(_db.userIdentitiesTable)
        ..where((t) => t.userId.equals(userId))
        ..where((t) => t.providerId.equals(providerId));
      final row = await query.getSingleOrNull();
      return right(row != null ? _mapToIdentity(row) : null);
    } catch (e) {
      return left(DatabaseFailure('Failed to fetch user identity: $e'));
    }
  }

  @override
  Future<Either<DatabaseFailure, List<UserIdentity>>>
  getIdentitiesForUsersAndProvider(
    Iterable<String> userIds,
    String providerId,
  ) async {
    try {
      final ids = userIds.toSet().toList();
      if (ids.isEmpty) {
        return right(const <UserIdentity>[]);
      }

      final query = _db.select(_db.userIdentitiesTable)
        ..where((t) => t.providerId.equals(providerId))
        ..where((t) => t.userId.isIn(ids));
      final rows = await query.get();
      return right(rows.map(_mapToIdentity).toList());
    } catch (e) {
      return left(
        DatabaseFailure(
          'Failed to fetch identities for users/provider: $e',
        ),
      );
    }
  }

  @override
  Future<Either<DatabaseFailure, List<UserIdentity>>> getAllIdentities() async {
    try {
      final query = _db.select(_db.userIdentitiesTable);
      final rows = await query.get();
      return right(rows.map(_mapToIdentity).toList());
    } catch (e) {
      return left(DatabaseFailure('Failed to fetch all identities: $e'));
    }
  }

  UserIdentity _mapToIdentity(UserIdentitiesTableData row) {
    return UserIdentity(
      id: row.id,
      userId: row.userId,
      providerId: row.providerId,
      externalId: row.externalId,
      externalUsername: row.externalUsername,
      status: UserIdentityStatus.values.firstWhere(
        (e) => e.name.toLowerCase() == row.status.toLowerCase(),
        orElse: () => UserIdentityStatus.pending,
      ),
      createdAt: row.createdAt.dateTime,
      updatedAt: row.updatedAt?.dateTime,
    );
  }
}
