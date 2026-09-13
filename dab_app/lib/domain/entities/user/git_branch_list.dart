/// [ARCH: DOMAIN_ENTITY]
/// ROLE: Unique branch names a caller can add to personal git inbox watches.
class GitBranchList {
  final List<String> available;
  final bool truncated;

  const GitBranchList({this.available = const [], this.truncated = false});

  factory GitBranchList.fromMap(Map<String, dynamic> map) {
    return GitBranchList(
      available: _stringList(map['available']),
      truncated: map['truncated'] == true,
    );
  }
}

List<String> _stringList(Object? raw) {
  if (raw is! List) return const [];
  return [
    for (final item in raw)
      if (item.toString().trim().isNotEmpty) item.toString().trim(),
  ];
}
