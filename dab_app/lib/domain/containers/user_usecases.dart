import '../repositories/abs_i_user_repository.dart';
import '../usecases/user/create_user.dart';
import '../usecases/user/delete_group.dart';
import '../usecases/user/delete_my_credential.dart';
import '../usecases/user/get_groups.dart';
import '../usecases/user/get_user.dart';
import '../usecases/user/get_users.dart';
import '../usecases/user/list_my_credentials.dart';
import '../usecases/user/delete_my_activity_follow.dart';
import '../usecases/user/list_my_follow_candidates.dart';
import '../usecases/user/list_my_activity_follows.dart';
import '../usecases/user/list_my_git_branches.dart';
import '../usecases/user/list_my_git_watches.dart';
import '../usecases/user/list_my_jira_projects.dart';
import '../usecases/user/list_my_linear_teams.dart';
import '../usecases/user/save_group.dart';
import '../usecases/user/save_my_activity_follow.dart';
import '../usecases/user/save_my_credential.dart';
import '../usecases/user/save_my_git_watches.dart';
import '../usecases/user/save_my_jira_projects.dart';
import '../usecases/user/save_my_linear_teams.dart';
import '../usecases/user/start_my_oauth.dart';
import '../usecases/user/test_my_credential.dart';

class UserUseCases {
  final CreateUser createUser;
  final DeleteGroup deleteGroup;
  final GetGroups getGroups;
  final GetUser getUser;
  final GetUsers getUsers;
  final SaveGroup saveGroup;
  final ListMyCredentials listMyCredentials;
  final SaveMyCredential saveMyCredential;
  final TestMyCredential testMyCredential;
  final DeleteMyCredential deleteMyCredential;
  final StartMyOauth startMyOauth;
  final ListMyJiraProjects listMyJiraProjects;
  final SaveMyJiraProjects saveMyJiraProjects;
  final ListMyLinearTeams listMyLinearTeams;
  final SaveMyLinearTeams saveMyLinearTeams;
  final ListMyGitWatches listMyGitWatches;
  final ListMyGitBranches listMyGitBranches;
  final SaveMyGitWatches saveMyGitWatches;
  final ListMyActivityFollows listMyActivityFollows;
  final ListMyFollowCandidates listMyFollowCandidates;
  final SaveMyActivityFollow saveMyActivityFollow;
  final DeleteMyActivityFollow deleteMyActivityFollow;

  UserUseCases(IUserRepository repository)
    : createUser = CreateUser(repository),
      deleteGroup = DeleteGroup(repository),
      getGroups = GetGroups(repository),
      getUser = GetUser(repository),
      getUsers = GetUsers(repository),
      saveGroup = SaveGroup(repository),
      listMyCredentials = ListMyCredentials(repository),
      saveMyCredential = SaveMyCredential(repository),
      testMyCredential = TestMyCredential(repository),
      deleteMyCredential = DeleteMyCredential(repository),
      startMyOauth = StartMyOauth(repository),
      listMyJiraProjects = ListMyJiraProjects(repository),
      saveMyJiraProjects = SaveMyJiraProjects(repository),
      listMyLinearTeams = ListMyLinearTeams(repository),
      saveMyLinearTeams = SaveMyLinearTeams(repository),
      listMyGitWatches = ListMyGitWatches(repository),
      listMyGitBranches = ListMyGitBranches(repository),
      saveMyGitWatches = SaveMyGitWatches(repository),
      listMyActivityFollows = ListMyActivityFollows(repository),
      listMyFollowCandidates = ListMyFollowCandidates(repository),
      saveMyActivityFollow = SaveMyActivityFollow(repository),
      deleteMyActivityFollow = DeleteMyActivityFollow(repository);
}
