/// [ARCH: DOMAIN]
/// ROLE: Data-only FCM/APNs wake payload. Never includes activity copy.
library;

import '../entities/activity/activity.dart';

/// Value of [kInboxWakeTypeKey] on a remote wake.
const kInboxWakeType = 'inbox_wake';

const kInboxWakeTypeKey = 'type';
const kInboxWakeLaneKey = 'lane';
const kInboxWakeActivityIdKey = 'activityId';

/// FCM `data` map: type, inbox lane, activity id. No title or content.
Map<String, String> inboxWakeData(Activity activity) {
  return {
    kInboxWakeTypeKey: kInboxWakeType,
    kInboxWakeLaneKey: activity.inboxLane.name,
    kInboxWakeActivityIdKey: activity.id,
  };
}

/// True when [data] is a wake and does not leak activity copy.
bool isInboxWakeData(Map<String, String> data) {
  if (data[kInboxWakeTypeKey] != kInboxWakeType) return false;
  if (data.containsKey('title') || data.containsKey('content')) return false;
  final lane = data[kInboxWakeLaneKey] ?? '';
  final id = data[kInboxWakeActivityIdKey] ?? '';
  return (lane == 'directed' || lane == 'follow') && id.isNotEmpty;
}
