/// [ARCH: DOMAIN]
/// ROLE: Caps and sorts unique branch names for Settings inbox watches.
library;

import '../entities/user/git_branch_list.dart';

const kGitBranchNameCap = 300;

const _pinned = ['main', 'master', 'develop', 'trunk'];

/// Distinct names, pinned (`main`/`master`/`develop`/`trunk`) then A–Z.
GitBranchList gitBranchListFromNames(
  Iterable<String> names, {
  required bool truncated,
}) {
  final unique = <String>{
    for (final name in names)
      if (name.trim().isNotEmpty) name.trim(),
  };
  final overflow = truncated || unique.length > kGitBranchNameCap;
  final available = unique.take(kGitBranchNameCap).toList()
    ..sort(compareGitBranchName);
  return GitBranchList(available: available, truncated: overflow);
}

int compareGitBranchName(String a, String b) {
  final ia = _pinned.indexOf(a.toLowerCase());
  final ib = _pinned.indexOf(b.toLowerCase());
  final pa = ia == -1 ? _pinned.length : ia;
  final pb = ib == -1 ? _pinned.length : ib;
  if (pa != pb) return pa.compareTo(pb);
  return a.toLowerCase().compareTo(b.toLowerCase());
}
