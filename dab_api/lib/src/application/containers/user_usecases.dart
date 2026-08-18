import '../usecases/user/delete_user_provider_credential.dart';
import '../usecases/user/get_git_branch_list.dart';
import '../usecases/user/get_git_watch_list.dart';
import '../usecases/user/get_jira_project_watch_list.dart';
import '../usecases/user/get_linear_team_watch_list.dart';
import '../usecases/user/get_user_by_id.dart';
import '../usecases/user/get_users.dart';
import '../usecases/user/get_users_by_group.dart';
import '../usecases/user/list_user_provider_credentials.dart';
import '../usecases/user/save_git_watch_list.dart';
import '../usecases/user/save_jira_project_watch_list.dart';
import '../usecases/user/save_linear_team_watch_list.dart';
import '../usecases/user/save_user_provider_credential.dart';
import '../usecases/user/start_provider_oauth.dart';
import '../usecases/user/sync_phorge_users.dart';
import '../usecases/user/test_user_provider_credential.dart';
import '../usecases/user/delete_activity_follow.dart';
import '../usecases/user/list_follow_candidates.dart';
import '../usecases/user/list_my_activity_follows.dart';
import '../usecases/user/save_activity_follow.dart';

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
  final GetGitWatchList getGitWatchList;
  final GetGitBranchList getGitBranchList;
  final SaveGitWatchList saveGitWatchList;
  final GetJiraProjectWatchList getJiraProjectWatchList;
  final SaveJiraProjectWatchList saveJiraProjectWatchList;
  final GetLinearTeamWatchList getLinearTeamWatchList;
  final SaveLinearTeamWatchList saveLinearTeamWatchList;
  final ListMyActivityFollows listMyActivityFollows;
  final ListFollowCandidates listFollowCandidates;
  final SaveActivityFollow saveActivityFollow;
  final DeleteActivityFollow deleteActivityFollow;

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
    required this.getGitWatchList,
    required this.getGitBranchList,
    required this.saveGitWatchList,
    required this.getJiraProjectWatchList,
    required this.saveJiraProjectWatchList,
    required this.getLinearTeamWatchList,
    required this.saveLinearTeamWatchList,
    required this.listMyActivityFollows,
    required this.listFollowCandidates,
    required this.saveActivityFollow,
    required this.deleteActivityFollow,
  });
}
