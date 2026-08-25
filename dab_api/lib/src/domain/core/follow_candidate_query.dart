import '../entities/user/follow_candidate.dart';

/// [ARCH: DOMAIN]
/// ROLE: Substring match on the Follow/Reports picker row.
/// CONTRACT: Empty [query] matches everything. Otherwise the needle must
/// appear in [FollowCandidate.title] or [FollowCandidate.objectKey]
/// (case-insensitive). Display titles include the task number (`[T12] …`).
bool followCandidateTitleContains(FollowCandidate row, String query) {
  final needle = query.trim().toLowerCase();
  if (needle.isEmpty) return true;
  if (row.title.toLowerCase().contains(needle)) return true;
  if (row.objectKey.toLowerCase().contains(needle)) return true;
  return false;
}
