/// [ARCH: DOMAIN]
/// ROLE: Caps and sorts unique branch names for Settings inbox watches.
library;

import '../entities/user/git_branch_list.dart';

const kGitBranchNameCap = 300;

const _pinned = ['main', 'master', 'develop', 'trunk'];

/// Distinct names, pinned (`main`/`master`/`develop`/`trunk`) then A–Z.
extension OnStringIterable on Iterable<String> {
  /// Distinct names, pinned (`main`/`master`/`develop`/`trunk`) then A–Z.
  GitBranchList gitBranchListFromNames({required bool truncated}) {
    final unique = <String>{
      for (final name in this)
        if (name.trim().isNotEmpty) name.trim(),
    };
    final overflow = truncated || unique.length > kGitBranchNameCap;
    final available = unique.take(kGitBranchNameCap).toList()
      ..sort((a, b) => a.compareGitBranchName(b));
    return GitBranchList(available: available, truncated: overflow);
  }
}

/// [ARCH: DOMAIN]
/// ROLE: Pinned-then-alpha compare for git branch names.
extension OnString on String {
  int compareGitBranchName(String other) {
    final ia = _pinned.indexOf(toLowerCase());
    final ib = _pinned.indexOf(other.toLowerCase());
    final pa = ia == -1 ? _pinned.length : ia;
    final pb = ib == -1 ? _pinned.length : ib;
    if (pa != pb) return pa.compareTo(pb);
    return toLowerCase().compareTo(other.toLowerCase());
  }
}
