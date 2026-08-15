import '../usecases/user/delete_user_provider_credential.dart';
import '../usecases/user/get_jira_project_watch_list.dart';
import '../usecases/user/get_user_by_id.dart';
import '../usecases/user/get_users.dart';
import '../usecases/user/get_users_by_group.dart';
import '../usecases/user/list_user_provider_credentials.dart';
import '../usecases/user/save_jira_project_watch_list.dart';
import '../usecases/user/save_user_provider_credential.dart';
import '../usecases/user/start_provider_oauth.dart';
import '../usecases/user/sync_phorge_users.dart';
import '../usecases/user/test_user_provider_credential.dart';

class UserUseCases {
  final GetUserById getUserById;
  final GetUsers getUsers;
  final GetUsersByGroup getUsersByGroup;
  final SyncPhorgeUsers syncPhorgeUsers;
  final ListUserProviderCredentials listUserProviderCredentials;
  final SaveUserProviderCredential saveUserProviderCredential;
  final DeleteUserProviderCredential deleteUserProviderCredential;
  final TestUserProviderCredential testUserProviderCredential;
  final StartProviderOauth startProviderOauth;
  final GetJiraProjectWatchList getJiraProjectWatchList;
  final SaveJiraProjectWatchList saveJiraProjectWatchList;

  UserUseCases({
    required this.getUserById,
    required this.getUsers,
    required this.getUsersByGroup,
    required this.syncPhorgeUsers,
    required this.listUserProviderCredentials,
    required this.saveUserProviderCredential,
    required this.deleteUserProviderCredential,
    required this.testUserProviderCredential,
    required this.startProviderOauth,
    required this.getJiraProjectWatchList,
    required this.saveJiraProjectWatchList,
  });
}
