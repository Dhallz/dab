/// [ARCH: DOMAIN]
/// ROLE: Which Dashboard pane a live-feed row belongs to.
/// CONTRACT: Directed is personal inbound. Follow is a subscription copy.
/// Missing/legacy JSON is treated as [directed].
library;

import 'package:dart_mappable/dart_mappable.dart';

part 'activity_inbox_lane.mapper.dart';

/// Dashboard live-feed lane.
@MappableEnum()
enum ActivityInboxLane { directed, follow }

/// Parses a wire value; unknown or empty becomes [ActivityInboxLane.directed].
ActivityInboxLane activityInboxLaneFrom(Object? raw) {
  final value = raw?.toString().trim().toLowerCase() ?? '';
  if (value == 'follow') return ActivityInboxLane.follow;
  return ActivityInboxLane.directed;
}
