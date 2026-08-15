/// [ARCH: DOMAIN]
/// ROLE: Parses Bitbucket workspace and repo allow-lists from settings.
/// CONTRACT: Pure parse. Auth headers stay in the Bitbucket source.
library;

/// Extracts the configured workspace slug.
String bitbucketWorkspace(Map<String, dynamic> settings) =>
    (settings['workspace'] ?? '').toString().trim();

/// Extracts the configured repo allow-list (list or comma/newline string).
List<String> bitbucketRepos(Map<String, dynamic> settings) {
  final raw = settings['repos'];
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
