/// [ARCH: DOMAIN]
/// ROLE: Which Dashboard pane a live-ingest row belongs to.
/// CONTRACT: Directed is personal inbound (mention, assignment, git watch).
/// Follow is a subscription copy. A user in both sets gets two rows.
library;

import 'package:dart_mappable/dart_mappable.dart';

part 'activity_inbox_lane.mapper.dart';

/// Dashboard live-feed lane. Missing/legacy JSON is treated as [directed].
@MappableEnum()
enum ActivityInboxLane { directed, follow }

/// [ARCH: DOMAIN]
/// ROLE: Follow vs Directed helpers on an inbox lane.
extension OnActivityInboxLane on ActivityInboxLane {
  /// True when this lane is the Follow subscription copy.
  bool get isFollowInboxLane => this == ActivityInboxLane.follow;
}

/// [ARCH: DOMAIN]
/// ROLE: Appends a follow token to a stable activity id seed.
extension OnString on String {
  /// Directed seeds stay unchanged so existing live rows do not duplicate.
  String withInboxLaneId(ActivityInboxLane lane) {
    if (lane == ActivityInboxLane.follow) return '$this|follow';
    return this;
  }
}

/// Directed assignments first, then Follow. A user in both appears twice.
List<(String userId, ActivityInboxLane lane)> inboxLaneTargets({
  required Iterable<String> directedUserIds,
  Iterable<String> followerUserIds = const [],
}) {
  final directed = <String>{
    for (final id in directedUserIds)
      if (id.trim().isNotEmpty) id.trim(),
  };
  final follow = <String>{
    for (final id in followerUserIds)
      if (id.trim().isNotEmpty) id.trim(),
  };
  return [
    for (final id in directed) (id, ActivityInboxLane.directed),
    for (final id in follow) (id, ActivityInboxLane.follow),
  ];
}

/// Live fan-out when [forUserIds] or [followerUserIds] is passed; otherwise
/// a single directed row for [fallbackUserId] (Explorer / authored poll).
List<(String userId, ActivityInboxLane lane)> resolveInboxLaneTargets({
  Iterable<String>? forUserIds,
  Iterable<String>? followerUserIds,
  String? fallbackUserId,
}) {
  final live = forUserIds != null || followerUserIds != null;
  if (!live) {
    final id = fallbackUserId?.trim() ?? '';
    if (id.isEmpty) return const [];
    return [(id, ActivityInboxLane.directed)];
  }
  return inboxLaneTargets(
    directedUserIds: forUserIds ?? const [],
    followerUserIds: followerUserIds ?? const [],
  );
}
