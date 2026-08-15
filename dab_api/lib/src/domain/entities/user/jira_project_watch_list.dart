import 'jira_project.dart';

final _jiraProjectKeyPattern = RegExp(r'^[A-Za-z][A-Za-z0-9_]{0,99}$');

/// Parses Admin/watch-list `projectKeys` (newline or comma separated).
List<String> parseJiraProjectKeys(dynamic raw) {
  if (raw is List) {
    return [
      for (final item in raw)
        if (_jiraProjectKeyPattern.hasMatch(item.toString().trim()))
          item.toString().trim(),
    ];
  }
  final text = (raw ?? '').toString();
  if (text.trim().isEmpty) return const [];
  return [
    for (final part in text.split(RegExp(r'[\n,]+')))
      if (_jiraProjectKeyPattern.hasMatch(part.trim())) part.trim(),
  ];
}

/// [ARCH: DOMAIN]
/// ROLE: Jira projects available to the caller plus the instance watch list.
class JiraProjectWatchList {
  const JiraProjectWatchList({
    required this.available,
    required this.selected,
  });

  final List<JiraProject> available;
  final List<String> selected;

  Map<String, dynamic> toMap() => {
    'available': available.map((p) => p.toMap()).toList(),
    'selected': selected,
  };
}
