import 'package:fpdart/fpdart.dart' hide Group;

import '../../domain/entities/group/group.dart';
import '../../domain/entities/user/user.dart';
import '../../domain/entities/user/user_role.dart';
import '../../domain/entities/user/user_identity.dart';
import '../../domain/entities/user/user_identity_status.dart';
import '../../domain/entities/user/user_provider_credential_summary.dart';
import '../../domain/entities/user/activity_follow.dart';
import '../../domain/entities/user/daily_report.dart';
import '../../domain/entities/user/daily_report_line.dart';
import '../../domain/entities/user/follow_candidate.dart';
import '../../domain/entities/user/git_branch_list.dart';
import '../../domain/entities/user/git_watch_list.dart';
import '../../domain/entities/user/jira_project_watch_list.dart';
import '../../domain/entities/user/linear_team_watch_list.dart';
import '../core/failures.dart';

abstract class IUserRepository {
  Future<Either<AppFailure, List<User>>> getUsers();
  Future<Either<AppFailure, User>> getUser(String id);
  Future<Either<AppFailure, List<Group>>> getGroups();
  Future<Either<AppFailure, Group>> saveGroup(Group group);
  Future<Either<AppFailure, void>> deleteGroup(String id);

  /// Admin: Fetch all platform identity candidates.
  Future<Either<AppFailure, List<UserIdentity>>> getIdentities();

  /// Admin: Count of identities in [pending] or [failed] state (for shell badge).
  Future<Either<AppFailure, int>> getIdentityResolutionSummary();

  /// Admin: Link a candidate identity to a DAB user.
  Future<Either<AppFailure, UserIdentity>> linkIdentity({
    required String userId,
    required String providerId,
    required String externalId,
    String? externalUsername,
  });

  /// Admin: Approve or reject a candidate identity (DAB-40).
  Future<Either<AppFailure, UserIdentity>> resolveIdentity({
    required String userId,
    required String providerId,
    required UserIdentityStatus status,
  });

  /// Admin: Permanently remove a provider identity link.
  Future<Either<AppFailure, void>> deleteIdentity({required String identityId});

  /// Admin: Update a user's globally defined role.
  Future<Either<AppFailure, void>> updateUserRole({
    required String userId,
    required UserRole role,
  });

  /// Admin: Create a new user account. The only account creation path after
  /// the bootstrap admin has registered; subject to the allowed-domain
  /// restriction when domain validation is enabled.
  Future<Either<AppFailure, User>> createUser({
    required String name,
    required String email,
    required String password,
    UserRole role = UserRole.standard,
  });

  /// Self-serve: masked credential status for the authenticated user.
  Future<Either<AppFailure, List<UserProviderCredentialSummary>>>
  listMyCredentials();

  /// Self-serve: save a personal PAT or workspace bot token.
  Future<Either<AppFailure, UserProviderCredentialSummary>> saveMyCredential({
    required String providerId,
    required Map<String, dynamic> settings,
  });

  /// Self-serve: test stored or posted credentials.
  Future<Either<AppFailure, void>> testMyCredential({
    required String providerId,
    Map<String, dynamic>? settings,
  });

  /// Self-serve: disconnect a personal credential (and shared bot if last user).
  Future<Either<AppFailure, void>> deleteMyCredential({
    required String providerId,
  });

  /// Self-serve: start browser OAuth for a provider. Returns the authorize URL.
  Future<Either<AppFailure, String>> startMyOauth({required String providerId});

  /// Self-serve: Jira projects visible to the caller plus instance watch keys.
  Future<Either<AppFailure, JiraProjectWatchList>> listMyJiraProjects();

  /// Self-serve: replace instance Jira `projectKeys`.
  Future<Either<AppFailure, JiraProjectWatchList>> saveMyJiraProjects({
    required List<String> projectKeys,
  });

  /// Self-serve: Linear teams visible to the caller plus instance watch keys.
  Future<Either<AppFailure, LinearTeamWatchList>> listMyLinearTeams();

  /// Self-serve: replace instance Linear `teamKeys`.
  Future<Either<AppFailure, LinearTeamWatchList>> saveMyLinearTeams({
    required List<String> teamKeys,
  });

  /// Self-serve: instance git repos plus the caller's personal inbox watches.
  Future<Either<AppFailure, GitWatchList>> listMyGitWatches({
    required String providerId,
  });

  /// Self-serve: replace personal git `watchedRepos` / `watchedBranches`.
  Future<Either<AppFailure, GitWatchList>> saveMyGitWatches({
    required String providerId,
    required List<String> repos,
    List<String> branches = const [],
  });

  /// Self-serve: unique branch names on [repos] for the git inbox picker.
  Future<Either<AppFailure, GitBranchList>> listMyGitBranches({
    required String providerId,
    List<String> repos = const [],
  });

  /// Self-serve: objects the caller can Follow from the Dashboard picker.
  Future<Either<AppFailure, List<FollowCandidate>>> listMyFollowCandidates({
    String query = '',
  });

  /// Self-serve: Dashboard object Follow pins for the caller.
  Future<Either<AppFailure, List<ActivityFollow>>> listMyActivityFollows();

  /// Self-serve: upsert a Dashboard object Follow pin.
  Future<Either<AppFailure, ActivityFollow>> saveMyActivityFollow({
    required String providerId,
    required String objectKey,
    String? title,
    String? url,
  });

  /// Self-serve: remove a Dashboard object Follow pin.
  Future<Either<AppFailure, void>> deleteMyActivityFollow({
    required String providerId,
    required String objectKey,
  });

  /// Self-serve: personal daily report for an org-calendar day (`YYYY-MM-DD`).
  Future<Either<AppFailure, DailyReport>> getMyDailyReport({
    required String date,
  });

  /// Self-serve: upsert the caller's curated daily report for [date].
  Future<Either<AppFailure, DailyReport>> saveMyDailyReport({
    required String date,
    required bool includeFollowing,
    required List<DailyReportLine> lines,
  });
}
