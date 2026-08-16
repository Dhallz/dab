/// [ARCH: DOMAIN_ENTITY]
/// ROLE: Unique branch names a caller can add to personal git inbox watches.
class GitBranchList {
  const GitBranchList({this.available = const [], this.truncated = false});

  /// Distinct branch names across the requested repos, pinned then A–Z.
  final List<String> available;

  /// True when the provider returned more names than the catalog cap.
  final bool truncated;

  Map<String, dynamic> toMap() => {
    'available': available,
    'truncated': truncated,
  };
}
