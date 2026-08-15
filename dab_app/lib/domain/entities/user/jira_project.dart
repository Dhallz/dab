/// [ARCH: DOMAIN_ENTITY]
/// ROLE: One Jira Cloud project shown in the Settings watch-list picker.
class JiraProject {
  final String key;
  final String name;

  const JiraProject({required this.key, required this.name});

  factory JiraProject.fromMap(Map<String, dynamic> map) {
    final key = (map['key'] ?? '').toString().trim();
    final name = (map['name'] ?? key).toString().trim();
    return JiraProject(key: key, name: name.isEmpty ? key : name);
  }
}
