/// [ARCH: DOMAIN]
/// ROLE: Parses Bitbucket workspace and repo allow-lists from settings.
/// CONTRACT: Pure parse. Auth headers stay in the Bitbucket source.
library;

/// [ARCH: DOMAIN]
/// ROLE: Bitbucket workspace slug and repo allow-list from provider settings.
extension OnProviderSettings on Map {
  /// Extracts the configured workspace slug.
  String bitbucketWorkspace() =>
      (this['workspace'] ?? '').toString().trim();

  /// Extracts the configured repo allow-list (list or comma/newline string).
  List<String> bitbucketRepos() {
    final raw = this['repos'];
    if (raw is List) {
      return raw
          .map((e) => e.toString().trim())
          .where((e) => e.isNotEmpty)
          .toList();
    }
    final str = (raw ?? '').toString();
    if (str.trim().isEmpty) return const [];
    return str
        .split(RegExp(r'[\n,]+'))
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();
  }
}
