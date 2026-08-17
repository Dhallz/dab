/// [ARCH: DOMAIN]
/// ROLE: Parses per-user git inbox watches from credential settings.
/// CONTRACT: Instance Admin `repos` / `projects` stay an ingest allow-list.
/// User `watchedRepos` / `watchedBranches` target Dashboard rows and Explorer
/// poll refs.
/// Missing `watchedRepos` means inherit [instanceRepos]; an empty list means
/// no git inbox for that user. Empty `watchedBranches` means all branches.
library;

/// Canonical repo keys (`owner/repo`) from a settings map.
List<String> parseWatchedRepos(Map<String, dynamic> settings) {
  return _stringList(settings['watchedRepos']);
}

/// Optional branch names the user tracks.
List<String> parseWatchedBranches(Map<String, dynamic> settings) {
  return _stringList(settings['watchedBranches']);
}

/// Whether [settings] contain an explicit `watchedRepos` key.
bool hasExplicitWatchedRepos(Map<String, dynamic> settings) {
  return settings.containsKey('watchedRepos');
}

/// Effective repo list: explicit watches, or [instanceRepos] when unset.
List<String> effectiveWatchedRepos({
  required Map<String, dynamic> settings,
  required Iterable<String> instanceRepos,
}) {
  if (!hasExplicitWatchedRepos(settings)) {
    return [
      for (final repo in instanceRepos)
        if (repo.trim().isNotEmpty) repo.trim(),
    ];
  }
  return parseWatchedRepos(settings);
}

/// Refs Explorer should poll for [repo].
///
/// Starts from the instance [configuredBranch] when set, otherwise a `null`
/// slot meaning the host default. Adds each watching user's `watchedBranches`.
List<String?> gitExplorerPollRefs({
  required String repo,
  required Iterable<String> instanceRepos,
  String configuredBranch = '',
  required Map<String, Map<String, dynamic>> userSettingsById,
}) {
  final named = <String>[];
  final seen = <String>{};
  void addNamed(String raw) {
    final name = raw.trim();
    if (name.isEmpty) return;
    if (!seen.add(name.toLowerCase())) return;
    named.add(name);
  }

  final instance = configuredBranch.trim();
  if (instance.isNotEmpty) addNamed(instance);

  final repoKey = repo.trim().toLowerCase();
  userSettingsById.forEach((_, settings) {
    final watching = effectiveWatchedRepos(
      settings: settings,
      instanceRepos: instanceRepos,
    ).any((item) => item.trim().toLowerCase() == repoKey);
    if (!watching) return;
    for (final branch in parseWatchedBranches(settings)) {
      addNamed(branch);
    }
  });

  if (instance.isEmpty) {
    return <String?>[null, ...named];
  }
  return named;
}

/// True when this user should receive a commit on [repo]/[branch].
bool watchesGitRef({
  required Map<String, dynamic> settings,
  required String repo,
  String? branch,
  required Iterable<String> instanceRepos,
}) {
  final repos = {
    for (final item in effectiveWatchedRepos(
      settings: settings,
      instanceRepos: instanceRepos,
    ))
      item.toLowerCase(),
  };
  if (repos.isEmpty) return false;
  if (!repos.contains(repo.trim().toLowerCase())) return false;

  final branches = parseWatchedBranches(settings);
  if (branches.isEmpty) return true;
  final wanted = (branch ?? '').trim().toLowerCase();
  if (wanted.isEmpty) return true;
  return branches.any((b) => b.toLowerCase() == wanted);
}

/// DAB user ids whose credentials watch [repo]/[branch], excluding [senderUserId].
Set<String> gitInboxWatchers({
  required Map<String, Map<String, dynamic>> userSettingsById,
  required String repo,
  String? branch,
  required Iterable<String> instanceRepos,
  String? senderUserId,
}) {
  final watchers = <String>{};
  userSettingsById.forEach((userId, settings) {
    if (senderUserId != null && userId == senderUserId) return;
    if (watchesGitRef(
      settings: settings,
      repo: repo,
      branch: branch,
      instanceRepos: instanceRepos,
    )) {
      watchers.add(userId);
    }
  });
  return watchers;
}

List<String> _stringList(Object? raw) {
  if (raw is List) {
    return [
      for (final item in raw)
        if (item.toString().trim().isNotEmpty) item.toString().trim(),
    ];
  }
  final text = (raw ?? '').toString();
  if (text.trim().isEmpty) return const [];
  return [
    for (final part in text.split(RegExp(r'[\n,]+')))
      if (part.trim().isNotEmpty) part.trim(),
  ];
}
