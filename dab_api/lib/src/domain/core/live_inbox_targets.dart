import '../entities/user/user_identity.dart';
import '../entities/user/user_identity_status.dart';

/// [ARCH: DOMAIN]
/// ROLE: Shared live-inbox recipient resolution for provider ingest.
/// CONTRACT: Pure. [Activity.userId] is the recipient; callers persist one
/// row per returned id. Unlinked external ids are dropped.

/// Maps linked identities to `externalId → DAB userId`.
Map<String, String> linkedExternalToUser(
  Iterable<UserIdentity> identities, {
  bool caseInsensitive = false,
}) {
  final map = <String, String>{};
  for (final identity in identities) {
    if (identity.status != UserIdentityStatus.linked) continue;
    var key = identity.externalId.trim();
    if (key.isEmpty) continue;
    if (caseInsensitive) key = key.toLowerCase();
    map.putIfAbsent(key, () => identity.userId);
  }
  return map;
}

/// Resolves provider external ids to DAB recipients.
///
/// Explicit mentions and assignee-became-me keep the sender when they tagged
/// or assigned themselves. Broadcast fan-out still uses
/// [liveInboxBroadcastTargets], which omits the sender.
Set<String> liveInboxTargets({
  required Iterable<String> externalIds,
  required Map<String, String> externalToUser,
  bool caseInsensitive = false,
}) {
  final targets = <String>{};
  for (final raw in externalIds) {
    var key = raw.trim();
    if (key.isEmpty) continue;
    if (caseInsensitive) key = key.toLowerCase();
    final userId = externalToUser[key];
    if (userId == null || userId.isEmpty) continue;
    targets.add(userId);
  }
  return targets;
}

/// Broadcast recipients: every linked user except the sender.
Set<String> liveInboxBroadcastTargets({
  required Iterable<String> linkedUserIds,
  String? senderUserId,
}) {
  return {
    for (final id in linkedUserIds)
      if (id.trim().isNotEmpty && id != senderUserId) id.trim(),
  };
}
