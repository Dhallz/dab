/// [ARCH: DOMAIN_ENTITY]
/// ROLE: Per-user git inbox watches (repos + optional branches).
class GitWatchList {
  final List<GitWatchRepo> available;
  final List<String> selected;
  final List<String> branches;

  const GitWatchList({
    this.available = const [],
    this.selected = const [],
    this.branches = const [],
  });

  factory GitWatchList.fromMap(Map<String, dynamic> map) {
    final rawAvailable = map['available'];
    final available = <GitWatchRepo>[];
    if (rawAvailable is List) {
      for (final item in rawAvailable) {
        if (item is Map<String, dynamic>) {
          available.add(GitWatchRepo.fromMap(item));
        } else if (item is Map) {
          available.add(GitWatchRepo.fromMap(Map<String, dynamic>.from(item)));
        } else {
          final key = item.toString().trim();
          if (key.isNotEmpty) available.add(GitWatchRepo(key: key, name: key));
        }
      }
    }
    final selected = _stringList(map['selected']);
    final branches = _stringList(map['branches']);
    return GitWatchList(
      available: available,
      selected: selected,
      branches: branches,
    );
  }
}

/// One repo shown in the Settings git watch picker.
class GitWatchRepo {
  final String key;
  final String name;

  const GitWatchRepo({required this.key, required this.name});

  factory GitWatchRepo.fromMap(Map<String, dynamic> map) {
    final key = (map['key'] ?? '').toString().trim();
    final name = (map['name'] ?? key).toString().trim();
    return GitWatchRepo(key: key, name: name.isEmpty ? key : name);
  }
}

List<String> _stringList(Object? raw) {
  if (raw is! List) return const [];
  return [
    for (final item in raw)
      if (item.toString().trim().isNotEmpty) item.toString().trim(),
  ];
}
