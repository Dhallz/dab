import 'jira_project.dart';

/// [ARCH: DOMAIN_ENTITY]
/// ROLE: Jira projects the signed-in user can see plus instance watch keys.
class JiraProjectWatchList {
  final List<JiraProject> available;
  final List<String> selected;

  const JiraProjectWatchList({
    this.available = const [],
    this.selected = const [],
  });

  factory JiraProjectWatchList.fromMap(Map<String, dynamic> map) {
    final rawAvailable = map['available'];
    final available = <JiraProject>[];
    if (rawAvailable is List) {
      for (final item in rawAvailable) {
        if (item is Map<String, dynamic>) {
          available.add(JiraProject.fromMap(item));
        } else if (item is Map) {
          available.add(JiraProject.fromMap(Map<String, dynamic>.from(item)));
        }
      }
    }
    final rawSelected = map['selected'];
    final selected = <String>[];
    if (rawSelected is List) {
      for (final item in rawSelected) {
        final key = item.toString().trim();
        if (key.isNotEmpty) selected.add(key);
      }
    }
    return JiraProjectWatchList(available: available, selected: selected);
  }
}
