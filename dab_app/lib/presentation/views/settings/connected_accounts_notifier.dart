import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../domain/containers/user_usecases.dart';
import '../../../domain/entities/user/git_watch_list.dart';
import '../../../domain/entities/user/jira_project_watch_list.dart';
import '../../../domain/entities/user/linear_team_watch_list.dart';
import '../../../domain/entities/user/user_provider_credential_summary.dart';
import '../../../services/service_locator.dart';
import '../../core/models/view_status.dart';
import '../../features/app/app_notifier.dart';

/// [ARCH: PRESENTATION]
/// ROLE: Settings connected-accounts state — list, connect, test, disconnect.
final connectedAccountsNotifierProvider =
    NotifierProvider.autoDispose<
      ConnectedAccountsNotifier,
      ConnectedAccountsState
    >(ConnectedAccountsNotifier.new);

class GitWatchDraft {
  final GitWatchList? watch;
  final List<String> draftRepos;
  final List<String> draftBranches;
  final List<String> availableBranches;
  final bool branchesTruncated;
  final bool branchesLoading;
  final bool loading;
  final bool saving;
  final String? error;
  final String? branchesError;

  const GitWatchDraft({
    this.watch,
    this.draftRepos = const [],
    this.draftBranches = const [],
    this.availableBranches = const [],
    this.branchesTruncated = false,
    this.branchesLoading = false,
    this.loading = false,
    this.saving = false,
    this.error,
    this.branchesError,
  });

  bool get hasLoaded => watch != null;

  bool get dirty {
    final savedRepos = {...(watch?.selected ?? const <String>[])};
    final draft = {...draftRepos};
    final savedBranches = {...(watch?.branches ?? const <String>[])};
    final draftBranchSet = {...draftBranches};
    return savedRepos.length != draft.length ||
        !savedRepos.containsAll(draft) ||
        savedBranches.length != draftBranchSet.length ||
        !savedBranches.containsAll(draftBranchSet);
  }

  GitWatchDraft copyWith({
    GitWatchList? watch,
    List<String>? draftRepos,
    List<String>? draftBranches,
    List<String>? availableBranches,
    bool? branchesTruncated,
    bool? branchesLoading,
    bool? loading,
    bool? saving,
    String? error,
    String? branchesError,
    bool clearWatch = false,
    bool clearError = false,
    bool clearBranchesError = false,
  }) {
    return GitWatchDraft(
      watch: clearWatch ? null : (watch ?? this.watch),
      draftRepos: clearWatch ? const [] : (draftRepos ?? this.draftRepos),
      draftBranches: clearWatch
          ? const []
          : (draftBranches ?? this.draftBranches),
      availableBranches: clearWatch
          ? const []
          : (availableBranches ?? this.availableBranches),
      branchesTruncated: clearWatch
          ? false
          : (branchesTruncated ?? this.branchesTruncated),
      branchesLoading: clearWatch
          ? false
          : (branchesLoading ?? this.branchesLoading),
      loading: loading ?? this.loading,
      saving: saving ?? this.saving,
      error: clearWatch || clearError ? null : (error ?? this.error),
      branchesError: clearWatch || clearBranchesError
          ? null
          : (branchesError ?? this.branchesError),
    );
  }
}

class ConnectedAccountsState {
  final ViewStatus status;
  final List<UserProviderCredentialSummary> credentials;
  final String? errorMessage;
  final String? busyProviderId;
  final JiraProjectWatchList? jiraProjects;
  final List<String> jiraDraftKeys;
  final bool jiraProjectsLoading;
  final bool jiraProjectsSaving;
  final LinearTeamWatchList? linearTeams;
  final List<String> linearDraftKeys;
  final bool linearTeamsLoading;
  final bool linearTeamsSaving;
  final String? jiraError;
  final String? linearError;
  final Map<String, GitWatchDraft> git;

  const ConnectedAccountsState({
    this.status = ViewStatus.initial,
    this.credentials = const [],
    this.errorMessage,
    this.busyProviderId,
    this.jiraProjects,
    this.jiraDraftKeys = const [],
    this.jiraProjectsLoading = false,
    this.jiraProjectsSaving = false,
    this.linearTeams,
    this.linearDraftKeys = const [],
    this.linearTeamsLoading = false,
    this.linearTeamsSaving = false,
    this.jiraError,
    this.linearError,
    this.git = const {},
  });

  UserProviderCredentialSummary? forProvider(String providerId) {
    for (final cred in credentials) {
      if (cred.providerId == providerId) return cred;
    }
    return null;
  }

  bool get jiraDraftDirty {
    final saved = {...(jiraProjects?.selected ?? const <String>[])};
    final draft = {...jiraDraftKeys};
    return saved.length != draft.length || !saved.containsAll(draft);
  }

  bool get linearDraftDirty {
    final saved = {...(linearTeams?.selected ?? const <String>[])};
    final draft = {...linearDraftKeys};
    return saved.length != draft.length || !saved.containsAll(draft);
  }

  ConnectedAccountsState copyWith({
    ViewStatus? status,
    List<UserProviderCredentialSummary>? credentials,
    String? errorMessage,
    String? busyProviderId,
    JiraProjectWatchList? jiraProjects,
    List<String>? jiraDraftKeys,
    bool? jiraProjectsLoading,
    bool? jiraProjectsSaving,
    LinearTeamWatchList? linearTeams,
    List<String>? linearDraftKeys,
    bool? linearTeamsLoading,
    bool? linearTeamsSaving,
    String? jiraError,
    String? linearError,
    Map<String, GitWatchDraft>? git,
    bool clearBusy = false,
    bool clearJiraProjects = false,
    bool clearLinearTeams = false,
    bool clearJiraError = false,
    bool clearLinearError = false,
  }) {
    return ConnectedAccountsState(
      status: status ?? this.status,
      credentials: credentials ?? this.credentials,
      errorMessage: errorMessage,
      busyProviderId: clearBusy
          ? null
          : (busyProviderId ?? this.busyProviderId),
      jiraProjects: clearJiraProjects
          ? null
          : (jiraProjects ?? this.jiraProjects),
      jiraDraftKeys: clearJiraProjects
          ? const []
          : (jiraDraftKeys ?? this.jiraDraftKeys),
      jiraProjectsLoading: jiraProjectsLoading ?? this.jiraProjectsLoading,
      jiraProjectsSaving: jiraProjectsSaving ?? this.jiraProjectsSaving,
      linearTeams: clearLinearTeams ? null : (linearTeams ?? this.linearTeams),
      linearDraftKeys: clearLinearTeams
          ? const []
          : (linearDraftKeys ?? this.linearDraftKeys),
      linearTeamsLoading: linearTeamsLoading ?? this.linearTeamsLoading,
      linearTeamsSaving: linearTeamsSaving ?? this.linearTeamsSaving,
      jiraError: clearJiraProjects || clearJiraError
          ? null
          : (jiraError ?? this.jiraError),
      linearError: clearLinearTeams || clearLinearError
          ? null
          : (linearError ?? this.linearError),
      git: git ?? this.git,
    );
  }

  GitWatchDraft gitDraft(String providerId) =>
      git[providerId] ?? const GitWatchDraft();
}

class ConnectedAccountsNotifier
    extends AutoDisposeNotifier<ConnectedAccountsState> {
  UserUseCases get _users => sl.userUseCases;
  final Map<String, int> _branchLoadGen = {};

  @override
  ConnectedAccountsState build() {
    Future.microtask(refresh);
    return const ConnectedAccountsState();
  }

  Future<void> refresh() async {
    state = state.copyWith(status: ViewStatus.loading, errorMessage: null);
    final result = await _users.listMyCredentials.execute();
    result.fold(
      (failure) {
        state = state.copyWith(
          status: ViewStatus.failure,
          errorMessage: failure.message,
        );
      },
      (list) {
        state = state.copyWith(
          status: ViewStatus.success,
          credentials: list,
          errorMessage: null,
        );
        unawaited(_maybeLoadJiraProjects(list));
        unawaited(_maybeLoadLinearTeams(list));
        unawaited(_maybeLoadGitWatches(list));
      },
    );
  }

  Future<String?> connect(
    String providerId,
    Map<String, dynamic> settings,
  ) async {
    state = state.copyWith(busyProviderId: providerId, errorMessage: null);
    final result = await _users.saveMyCredential.execute(
      providerId: providerId,
      settings: settings,
    );
    return result.fold(
      (failure) {
        state = state.copyWith(clearBusy: true, errorMessage: failure.message);
        return failure.message;
      },
      (summary) {
        final next = [
          for (final cred in state.credentials)
            if (cred.providerId != providerId) cred,
          summary,
        ];
        state = state.copyWith(
          credentials: next,
          clearBusy: true,
          status: ViewStatus.success,
        );
        unawaitedRefreshHealth();
        return null;
      },
    );
  }

  /// Opens the provider authorize URL and polls until the credential appears.
  Future<String?> startOauth(String providerId) async {
    state = state.copyWith(busyProviderId: providerId, errorMessage: null);
    final result = await _users.startMyOauth.execute(providerId: providerId);
    return result.fold(
      (failure) {
        state = state.copyWith(clearBusy: true, errorMessage: failure.message);
        return failure.message;
      },
      (url) async {
        final uri = Uri.tryParse(url);
        if (uri == null) {
          state = state.copyWith(
            clearBusy: true,
            errorMessage: 'Invalid authorization URL',
          );
          return 'Invalid authorization URL';
        }
        final launched = await launchUrl(
          uri,
          mode: LaunchMode.externalApplication,
        );
        if (!launched) {
          state = state.copyWith(
            clearBusy: true,
            errorMessage: 'Could not open the browser',
          );
          return 'Could not open the browser';
        }
        await _pollUntilConnected(providerId);
        return null;
      },
    );
  }

  Future<void> _pollUntilConnected(String providerId) async {
    final previous = state.forProvider(providerId);
    final wasConnected = previous?.isConnected == true;
    final previousUpdated = previous?.updatedAt;

    for (var i = 0; i < 45; i++) {
      await Future<void>.delayed(const Duration(seconds: 2));
      final result = await _users.listMyCredentials.execute();
      final list = result.getOrElse((_) => state.credentials);
      UserProviderCredentialSummary? summary;
      for (final cred in list) {
        if (cred.providerId == providerId) {
          summary = cred;
          break;
        }
      }
      if (summary?.isConnected == true) {
        final updated = summary!.updatedAt;
        final isNewCredential =
            !wasConnected ||
            (updated != null &&
                previousUpdated != null &&
                updated.isAfter(previousUpdated)) ||
            (updated != null &&
                previousUpdated != null &&
                updated != previousUpdated);
        if (!isNewCredential && i < 44) {
          continue;
        }
        state = state.copyWith(
          credentials: list,
          clearBusy: true,
          status: ViewStatus.success,
        );
        unawaitedRefreshHealth();
        if (providerId == 'jira') {
          await loadJiraProjects();
        }
        if (providerId == 'linear') {
          await loadLinearTeams();
        }
        if (providerId == 'github' ||
            providerId == 'gitlab' ||
            providerId == 'bitbucket') {
          await loadGitWatches(providerId);
        }
        return;
      }
    }
    state = state.copyWith(clearBusy: true);
  }

  Future<void> _maybeLoadJiraProjects(
    List<UserProviderCredentialSummary> list,
  ) async {
    final jira = list.where((c) => c.providerId == 'jira').firstOrNull;
    if (jira?.isConnected != true) {
      state = state.copyWith(clearJiraProjects: true);
      return;
    }
    await loadJiraProjects();
  }

  Future<void> _maybeLoadLinearTeams(
    List<UserProviderCredentialSummary> list,
  ) async {
    final linear = list.where((c) => c.providerId == 'linear').firstOrNull;
    if (linear?.isConnected != true) {
      state = state.copyWith(clearLinearTeams: true);
      return;
    }
    await loadLinearTeams();
  }

  Future<void> loadJiraProjects() async {
    state = state.copyWith(jiraProjectsLoading: true, clearJiraError: true);
    final result = await _users.listMyJiraProjects.execute();
    result.fold(
      (failure) {
        state = state.copyWith(
          jiraProjectsLoading: false,
          jiraError: failure.message,
        );
      },
      (watch) {
        state = state.copyWith(
          jiraProjectsLoading: false,
          jiraProjects: watch,
          jiraDraftKeys: List<String>.from(watch.selected),
          clearJiraError: true,
        );
      },
    );
  }

  void toggleJiraProject(String key) {
    final next = [...state.jiraDraftKeys];
    if (next.contains(key)) {
      next.remove(key);
    } else {
      next.add(key);
    }
    state = state.copyWith(jiraDraftKeys: next);
  }

  Future<String?> saveJiraProjects() async {
    state = state.copyWith(jiraProjectsSaving: true, errorMessage: null);
    final result = await _users.saveMyJiraProjects.execute(
      projectKeys: state.jiraDraftKeys,
    );
    return result.fold(
      (failure) {
        state = state.copyWith(
          jiraProjectsSaving: false,
          errorMessage: failure.message,
        );
        return failure.message;
      },
      (watch) {
        state = state.copyWith(
          jiraProjectsSaving: false,
          jiraProjects: watch,
          jiraDraftKeys: List<String>.from(watch.selected),
        );
        unawaitedRefreshHealth();
        return null;
      },
    );
  }

  Future<void> _maybeLoadGitWatches(
    List<UserProviderCredentialSummary> list,
  ) async {
    const gitIds = ['github', 'gitlab', 'bitbucket'];
    for (final id in gitIds) {
      final cred = list.where((c) => c.providerId == id).firstOrNull;
      if (cred?.isConnected != true) {
        _clearGit(id);
        continue;
      }
      await loadGitWatches(id);
    }
  }

  void _patchGit(String providerId, GitWatchDraft draft) {
    state = state.copyWith(git: {...state.git, providerId: draft});
  }

  void _clearGit(String providerId) {
    final next = {...state.git}..remove(providerId);
    state = state.copyWith(git: next);
  }

  Future<void> loadGitWatches(String providerId) async {
    _patchGit(
      providerId,
      state
          .gitDraft(providerId)
          .copyWith(
            loading: true,
            clearError: true,
            clearBranchesError: true,
          ),
    );
    final result = await _users.listMyGitWatches.execute(
      providerId: providerId,
    );
    result.fold(
      (failure) {
        _patchGit(
          providerId,
          state
              .gitDraft(providerId)
              .copyWith(loading: false, error: failure.message),
        );
      },
      (watch) {
        _patchGit(
          providerId,
          GitWatchDraft(
            watch: watch,
            draftRepos: List<String>.from(watch.selected),
            draftBranches: List<String>.from(watch.branches),
          ),
        );
        unawaited(loadGitBranches(providerId));
      },
    );
  }

  void toggleGitRepo(String providerId, String key) {
    final current = state.gitDraft(providerId);
    final next = [...current.draftRepos];
    if (next.contains(key)) {
      next.remove(key);
    } else {
      next.add(key);
    }
    _patchGit(providerId, current.copyWith(draftRepos: next));
    unawaited(loadGitBranches(providerId));
  }

  void addGitBranch(String providerId, String branch) {
    final name = branch.trim();
    if (name.isEmpty) return;
    final current = state.gitDraft(providerId);
    if (current.draftBranches.any(
      (b) => b.toLowerCase() == name.toLowerCase(),
    )) {
      return;
    }
    _patchGit(
      providerId,
      current.copyWith(draftBranches: [...current.draftBranches, name]),
    );
  }

  void removeGitBranch(String providerId, String branch) {
    final current = state.gitDraft(providerId);
    _patchGit(
      providerId,
      current.copyWith(
        draftBranches: [
          for (final item in current.draftBranches)
            if (item.toLowerCase() != branch.trim().toLowerCase()) item,
        ],
      ),
    );
  }

  Future<void> loadGitBranches(String providerId) async {
    final gen = (_branchLoadGen[providerId] ?? 0) + 1;
    _branchLoadGen[providerId] = gen;
    final current = state.gitDraft(providerId);
    final repos = current.draftRepos;
    if (repos.isEmpty) {
      _patchGit(
        providerId,
        current.copyWith(
          availableBranches: const [],
          branchesTruncated: false,
          branchesLoading: false,
          clearBranchesError: true,
        ),
      );
      return;
    }
    _patchGit(
      providerId,
      current.copyWith(branchesLoading: true, clearBranchesError: true),
    );
    final result = await _users.listMyGitBranches.execute(
      providerId: providerId,
      repos: repos,
    );
    if (gen != _branchLoadGen[providerId]) return;
    result.fold(
      (failure) {
        _patchGit(
          providerId,
          state
              .gitDraft(providerId)
              .copyWith(
                branchesLoading: false,
                availableBranches: const [],
                branchesTruncated: false,
                branchesError: failure.message,
              ),
        );
      },
      (list) {
        final draft = state.gitDraft(providerId);
        _patchGit(
          providerId,
          draft.copyWith(
            availableBranches: list.available,
            branchesTruncated: list.truncated,
            branchesLoading: false,
            clearBranchesError: true,
          ),
        );
      },
    );
  }

  Future<String?> saveGitWatches(String providerId) async {
    final current = state.gitDraft(providerId);
    _patchGit(providerId, current.copyWith(saving: true));
    final result = await _users.saveMyGitWatches.execute(
      providerId: providerId,
      repos: current.draftRepos,
      branches: current.draftBranches,
    );
    return result.fold(
      (failure) {
        _patchGit(
          providerId,
          state
              .gitDraft(providerId)
              .copyWith(saving: false, error: failure.message),
        );
        return failure.message;
      },
      (watch) {
        _patchGit(
          providerId,
          GitWatchDraft(
            watch: watch,
            draftRepos: List<String>.from(watch.selected),
            draftBranches: List<String>.from(watch.branches),
            availableBranches: state.gitDraft(providerId).availableBranches,
            branchesTruncated: state.gitDraft(providerId).branchesTruncated,
          ),
        );
        unawaitedRefreshHealth();
        return null;
      },
    );
  }

  Future<void> loadLinearTeams() async {
    state = state.copyWith(linearTeamsLoading: true, clearLinearError: true);
    final result = await _users.listMyLinearTeams.execute();
    result.fold(
      (failure) {
        state = state.copyWith(
          linearTeamsLoading: false,
          linearError: failure.message,
        );
      },
      (watch) {
        state = state.copyWith(
          linearTeamsLoading: false,
          linearTeams: watch,
          linearDraftKeys: List<String>.from(watch.selected),
          clearLinearError: true,
        );
      },
    );
  }

  void toggleLinearTeam(String key) {
    final next = [...state.linearDraftKeys];
    if (next.contains(key)) {
      next.remove(key);
    } else {
      next.add(key);
    }
    state = state.copyWith(linearDraftKeys: next);
  }

  Future<String?> saveLinearTeams() async {
    state = state.copyWith(linearTeamsSaving: true, errorMessage: null);
    final result = await _users.saveMyLinearTeams.execute(
      teamKeys: state.linearDraftKeys,
    );
    return result.fold(
      (failure) {
        state = state.copyWith(
          linearTeamsSaving: false,
          errorMessage: failure.message,
        );
        return failure.message;
      },
      (watch) {
        state = state.copyWith(
          linearTeamsSaving: false,
          linearTeams: watch,
          linearDraftKeys: List<String>.from(watch.selected),
        );
        unawaitedRefreshHealth();
        return null;
      },
    );
  }

  Future<String?> test(
    String providerId, {
    Map<String, dynamic>? settings,
  }) async {
    state = state.copyWith(busyProviderId: providerId, errorMessage: null);
    final result = await _users.testMyCredential.execute(
      providerId: providerId,
      settings: settings,
    );
    return result.fold(
      (failure) {
        state = state.copyWith(clearBusy: true, errorMessage: failure.message);
        return failure.message;
      },
      (_) {
        state = state.copyWith(clearBusy: true);
        return null;
      },
    );
  }

  Future<String?> disconnect(String providerId) async {
    state = state.copyWith(busyProviderId: providerId, errorMessage: null);
    final result = await _users.deleteMyCredential.execute(
      providerId: providerId,
    );
    return result.fold(
      (failure) {
        state = state.copyWith(clearBusy: true, errorMessage: failure.message);
        return failure.message;
      },
      (_) {
        state = state.copyWith(
          credentials: [
            for (final cred in state.credentials)
              if (cred.providerId != providerId) cred,
          ],
          clearBusy: true,
          clearJiraProjects: providerId == 'jira',
          clearLinearTeams: providerId == 'linear',
          git:
              providerId == 'github' ||
                  providerId == 'gitlab' ||
                  providerId == 'bitbucket'
              ? ({...state.git}..remove(providerId))
              : state.git,
        );
        unawaitedRefreshHealth();
        return null;
      },
    );
  }

  void unawaitedRefreshHealth() {
    ref.read(appNotifierProvider.notifier).refreshProviderConnectionStatuses();
  }
}
