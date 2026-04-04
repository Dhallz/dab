import 'package:bcrypt/bcrypt.dart';
import 'package:uuid/uuid.dart';

import '../domain/entities/group.dart';
import '../domain/entities/user.dart';
import '../domain/repositories/abs_i_user_repository.dart';
import '../infrastructure/connectors/phorge/phorge_connector.dart';

class UserService {
  final IUserRepository _repo;
  final PhorgeConnector _phorgeConnector;
  final _uuid = const Uuid();

  UserService(this._repo, this._phorgeConnector);

  Future<List<User>> getUsers() async {
    final result = await _repo.getUsers();
    return result.match((f) => throw Exception(f.message), (users) => users);
  }

  Future<User> getUser(String id) async {
    final result = await _repo.getUser(id);
    return result.match((f) => throw Exception(f.message), (user) => user);
  }

  Future<List<User>> getUsersByGroup(String groupId) async {
    final result = await _repo.getUsersByGroup(groupId);
    return result.match((f) => throw Exception(f.message), (users) => users);
  }

  Future<List<Group>> getGroups() async {
    final result = await _repo.getGroups();
    return result.match((f) => throw Exception(f.message), (groups) => groups);
  }

  Future<Group> saveGroup(Group group) async {
    final result = await _repo.saveGroup(group);
    return result.match(
      (f) => throw Exception(f.message),
      (savedGroup) => savedGroup,
    );
  }

  Future<void> deleteGroup(String id) async {
    final result = await _repo.deleteGroup(id);
    return result.match((f) => throw Exception(f.message), (_) => null);
  }

  Future<int> syncPhorgeUsers() async {
    final phorgeUsers = await _phorgeConnector.fetchAllUsers();
    int createdCount = 0;

    for (final pUser in phorgeUsers) {
      final email = '${pUser.userName.toLowerCase()}@necs.com';

      // Check if user already exists in DAB
      final existingResult = await _repo.findByEmail(email);
      final existing = existingResult.getOrElse((_) => null);

      if (existing == null) {
        final newUser = User(
          id: _uuid.v4(),
          name: pUser.realName ?? pUser.userName,
          email: email,
          passwordHash: BCrypt.hashpw(pUser.userName, BCrypt.gensalt()),
          phorgePhid: pUser.phid,
          phorgeUsername: pUser.userName,
          role: 'Standard',
          createdAt: DateTime.now(),
        );

        await _repo.saveUser(newUser);
        createdCount++;
      }
    }

    return createdCount;
  }
}
