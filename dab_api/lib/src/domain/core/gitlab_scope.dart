/// [ARCH: DOMAIN]
/// ROLE: Parses GitLab project allow-lists and API base URLs from settings.
/// CONTRACT: Pure string parse. HTTP headers stay in the GitLab source.
library;

const kDefaultGitLabApiBase = 'https://gitlab.com/api/v4';

/// [ARCH: DOMAIN]
/// ROLE: Canonical GitLab project path or numeric id from Admin allow-list
/// entries, pasted URLs, or Dart `List.toString()` wrappers like `[[path]]`.
extension OnString on String {
  /// Canonical `group/project` (or numeric project id) from [this].
  String? normalizeGitLabProject() {
    var text = trim();
    if (text.isEmpty) return null;
    while (text.length >= 2 && text.startsWith('[') && text.endsWith(']')) {
      text = text.substring(1, text.length - 1).trim();
    }
    if (text.length >= 2) {
      final first = text[0];
      final last = text[text.length - 1];
      if ((first == '"' && last == '"') || (first == "'" && last == "'")) {
        text = text.substring(1, text.length - 1).trim();
      }
    }
    if (text.isEmpty) return null;

    final uri = Uri.tryParse(text);
    if (uri != null &&
        (uri.scheme == 'http' || uri.scheme == 'https') &&
        uri.path.trim().isNotEmpty) {
      var path = uri.path.replaceFirst(RegExp(r'^/'), '');
      final tree = path.indexOf('/-/');
      if (tree != -1) path = path.substring(0, tree);
      text = path;
    }
    text = text.replaceFirst(RegExp(r'\.git$'), '').trim();
    if (text.isEmpty) return null;
    if (RegExp(r'^\d+$').hasMatch(text)) return text;
    if (!text.contains('/')) return null;
    return text;
  }
}

/// [ARCH: DOMAIN]
/// ROLE: GitLab API base URL and project allow-list from provider settings.
extension OnProviderSettings on Map {
  /// Normalized API base URL (`https://gitlab.example.com/api/v4`).
  ///
  /// Resolution order: explicit `apiBaseUrl` setting, then the provider's base
  /// URL (instance URL) with `/api/v4` appended, then gitlab.com.
  String gitLabApiBase([String baseUrl = '']) {
    final explicit = (this['apiBaseUrl'] ?? '').toString().trim();
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
  List<String> gitLabProjects() {
    final seen = <String>{};
    final out = <String>[];

    void add(dynamic item) {
      if (item is List) {
        for (final child in item) {
          add(child);
        }
        return;
      }
      final project = item.toString().normalizeGitLabProject();
      if (project == null || !seen.add(project)) return;
      out.add(project);
    }

    final raw = this['projects'];
    if (raw is List) {
      for (final item in raw) {
        add(item);
      }
      return out;
    }
    final str = (raw ?? '').toString();
    if (str.trim().isEmpty) return const [];
    for (final part in str.split(RegExp(r'[\n,]+'))) {
      add(part);
    }
    return out;
  }
}
