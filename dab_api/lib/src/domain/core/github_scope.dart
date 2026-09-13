/// [ARCH: DOMAIN]
/// ROLE: Parses GitHub repository allow-lists from provider settings.
/// CONTRACT: Returns canonical `owner/repo` strings consistent with webhook
/// `full_name`. No I/O.
library;

/// [ARCH: DOMAIN]
/// ROLE: GitHub repo allow-list from `owner`/`repo` and `repos`.
extension OnProviderSettings on Map {
  /// Extracts configured GitHub repos from `owner`/`repo` and `repos`.
  List<String> extractConfiguredGithubRepos() {
    final repos = <String>{};
    final owner = (this['owner'] ?? '').toString().trim();
    final repo = (this['repo'] ?? '').toString().trim();
    if (owner.isNotEmpty && repo.isNotEmpty) {
      repos.add('$owner/$repo');
    }

    final dynamic reposRaw = this['repos'];
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
}
