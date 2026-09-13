/// [ARCH: DOMAIN]
/// ROLE: One Jira Cloud project the connected user can see.
class JiraProject {
  const JiraProject({required this.key, required this.name});

  final String key;
  final String name;

  Map<String, dynamic> toMap() => {'key': key, 'name': name};

  factory JiraProject.fromMap(Map<String, dynamic> map) {
    return JiraProject(
      key: (map['key'] ?? '').toString().trim(),
      name: (map['name'] ?? '').toString().trim(),
    );
  }
}
