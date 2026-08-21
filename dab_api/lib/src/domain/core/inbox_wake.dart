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
extension OnActivity on Activity {
  /// FCM `data` map: type, inbox lane, activity id. No title or content.
  Map<String, String> inboxWakeData() {
    return {
      kInboxWakeTypeKey: kInboxWakeType,
      kInboxWakeLaneKey: inboxLane.name,
      kInboxWakeActivityIdKey: id,
    };
  }
}

/// True when this map is a wake and does not leak activity copy.
extension OnInboxWakeMap on Map<String, String> {
  /// True when this map is a wake and does not leak activity copy.
  bool get isInboxWakeData {
    if (this[kInboxWakeTypeKey] != kInboxWakeType) return false;
    if (containsKey('title') || containsKey('content')) return false;
    final lane = this[kInboxWakeLaneKey] ?? '';
    final id = this[kInboxWakeActivityIdKey] ?? '';
    return (lane == 'directed' || lane == 'follow') && id.isNotEmpty;
  }
}
