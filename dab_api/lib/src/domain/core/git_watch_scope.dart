/// [ARCH: DOMAIN]
/// ROLE: Parses per-user git inbox watches from credential settings.
/// CONTRACT: Instance Admin `repos` / `projects` stay an ingest allow-list.
/// User `watchedRepos` / `watchedBranches` target Dashboard rows.
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
