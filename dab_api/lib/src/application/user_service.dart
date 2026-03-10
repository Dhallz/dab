import '../domain/entities/group.dart';
import '../domain/entities/user.dart';
import '../domain/repositories/abs_i_user_repository.dart';

class UserService {
  final IUserRepository _repo;

  UserService(this._repo);

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
}
