import '../repositories/abs_i_user_repository.dart';
import '../usecases/user/delete_group.dart';
import '../usecases/user/get_groups.dart';
import '../usecases/user/get_user.dart';
import '../usecases/user/get_users.dart';
import '../usecases/user/save_group.dart';

class UserUseCases {
  final DeleteGroup deleteGroup;
  final GetGroups getGroups;
  final GetUser getUser;
  final GetUsers getUsers;
  final SaveGroup saveGroup;

  UserUseCases(IUserRepository repository)
    : deleteGroup = DeleteGroup(repository),
      getGroups = GetGroups(repository),
      getUser = GetUser(repository),
      getUsers = GetUsers(repository),
      saveGroup = SaveGroup(repository);
}
