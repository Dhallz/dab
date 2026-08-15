/// [ARCH: DOMAIN]
/// ROLE: Parses GitLab project allow-lists and API base URLs from settings.
/// CONTRACT: Pure string parse. HTTP headers stay in the GitLab source.
library;

const kDefaultGitLabApiBase = 'https://gitlab.com/api/v4';

/// Normalized API base URL (`https://gitlab.example.com/api/v4`).
///
/// Resolution order: explicit `apiBaseUrl` setting, then the provider's base
/// URL (instance URL) with `/api/v4` appended, then gitlab.com.
String gitLabApiBase(Map<String, dynamic> settings, [String baseUrl = '']) {
  final explicit = (settings['apiBaseUrl'] ?? '').toString().trim();
  if (explicit.isNotEmpty) {
    return explicit.replaceAll(RegExp(r'/+$'), '');
  }
  final instance = baseUrl.trim().replaceAll(RegExp(r'/+$'), '');
  if (instance.isNotEmpty) {
    return instance.endsWith('/api/v4') ? instance : '$instance/api/v4';
  }
  return kDefaultGitLabApiBase;
}

/// Extracts the configured project allow-list (list or comma/newline string).
List<String> gitLabProjects(Map<String, dynamic> settings) {
  final raw = settings['projects'];
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
