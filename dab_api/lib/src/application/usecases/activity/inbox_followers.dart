import '../../../domain/contracts/repositories/abs_i_activity_follow_repository.dart';

/// Loads DAB user ids that Follow any of [objectKeys] for [providerId].
Future<Set<String>> inboxFollowerUserIds(
  AbsIActivityFollowRepository? follows, {
  required String providerId,
  required Iterable<String> objectKeys,
}) async {
  if (follows == null) return {};
  final ids = <String>{};
  for (final raw in objectKeys) {
    final key = raw.trim();
    if (key.isEmpty) continue;
    final result = await follows.userIdsFor(
      providerId: providerId,
      objectKey: key,
    );
    ids.addAll(result.getOrElse((_) => const []));
  }
  return ids;
}
