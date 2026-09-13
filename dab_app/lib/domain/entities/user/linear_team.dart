/// [ARCH: DOMAIN_ENTITY]
/// ROLE: One Linear team shown in the Settings watch-list picker.
class LinearTeam {
  final String key;
  final String name;

  const LinearTeam({required this.key, required this.name});

  factory LinearTeam.fromMap(Map<String, dynamic> map) {
    final key = (map['key'] ?? '').toString().trim();
    final name = (map['name'] ?? key).toString().trim();
    return LinearTeam(key: key, name: name.isEmpty ? key : name);
  }
}
