/// [ARCH: DOMAIN]
/// ROLE: One Linear team the connected user can see.
class LinearTeam {
  const LinearTeam({required this.key, required this.name});

  final String key;
  final String name;

  Map<String, dynamic> toMap() => {'key': key, 'name': name};

  factory LinearTeam.fromMap(Map<String, dynamic> map) {
    final key = (map['key'] ?? '').toString().trim();
    final name = (map['name'] ?? key).toString().trim();
    return LinearTeam(key: key, name: name.isEmpty ? key : name);
  }
}
