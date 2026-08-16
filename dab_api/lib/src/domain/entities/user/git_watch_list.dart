/// [ARCH: DOMAIN]
/// ROLE: Per-user git inbox watches (repos + optional branches).
class GitWatchList {
  const GitWatchList({
    required this.available,
    required this.selected,
    this.branches = const [],
  });

  final List<String> available;
  final List<String> selected;
  final List<String> branches;

  Map<String, dynamic> toMap() => {
    'available': available.map((key) => {'key': key, 'name': key}).toList(),
    'selected': selected,
    'branches': branches,
  };
}
