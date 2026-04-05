import '../usecases/user/get_user_by_id.dart';
import '../usecases/user/get_users.dart';
import '../usecases/user/get_users_by_group.dart';
import '../usecases/user/sync_phorge_users.dart';

class UserUseCases {
  final GetUserById getUserById;
  final GetUsers getUsers;
  final GetUsersByGroup getUsersByGroup;
  final SyncPhorgeUsers syncPhorgeUsers;

  UserUseCases({
    required this.getUserById,
    required this.getUsers,
    required this.getUsersByGroup,
    required this.syncPhorgeUsers,
  });
}
