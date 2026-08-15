/// [ARCH: DOMAIN]
/// ROLE: Parses GitHub repository allow-lists from provider settings.
/// CONTRACT: Returns canonical `owner/repo` strings consistent with webhook
/// `full_name`. No I/O.
library;

/// Extracts configured GitHub repos from `owner`/`repo` and `repos`.
List<String> extractConfiguredGithubRepos(Map<String, dynamic> settings) {
  final repos = <String>{};
  final owner = (settings['owner'] ?? '').toString().trim();
  final repo = (settings['repo'] ?? '').toString().trim();
  if (owner.isNotEmpty && repo.isNotEmpty) {
    repos.add('$owner/$repo');
  }

  final dynamic reposRaw = settings['repos'];
  if (reposRaw is List) {
    for (final entry in reposRaw) {
      if (entry is String && entry.trim().isNotEmpty) {
        repos.add(entry.trim());
      } else if (entry is Map<String, dynamic>) {
        final eOwner = (entry['owner'] ?? '').toString().trim();
        final eRepo = (entry['repo'] ?? '').toString().trim();
        if (eOwner.isNotEmpty && eRepo.isNotEmpty) {
          repos.add('$eOwner/$eRepo');
        }
      }
    }
  }

  return repos.toList();
}
