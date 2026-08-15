import 'dart:convert';

import 'package:relic/relic.dart';

import '../../domain/ports/i_presence_broadcaster.dart';

/// [ARCH: INFRASTRUCTURE_SERVICE]
/// ROLE: Tracks Relic WebSocket sessions and fans out live events.
class PresenceService implements IPresenceBroadcaster {
  final Map<RelicWebSocket, String> _sessions = {};

  void addSession(RelicWebSocket session, String userId) {
    _sessions[session] = userId;
    print('User $userId connected via WebSocket. Total: ${_sessions.length}');
  }

  void removeSession(RelicWebSocket session) {
    final userId = _sessions.remove(session);
    print('User $userId disconnected. Total: ${_sessions.length}');
  }

  Set<String> getActiveUserIds() => _sessions.values.toSet();

  @override
  void broadcast(String type, Map<String, dynamic> data) {
    final payload = jsonEncode({'type': type, 'data': data});
    for (final session in _sessions.keys) {
      session.trySendText(payload);
    }
  }

  @override
  void broadcastToUser(String userId, String type, Map<String, dynamic> data) {
    final payload = jsonEncode({'type': type, 'data': data});
    var delivered = 0;
    for (final entry in _sessions.entries) {
      if (entry.value == userId) {
        entry.key.trySendText(payload);
        delivered++;
      }
    }
    if (type == 'ACTIVITY_RECEIVED') {
      final activityId = data['id']?.toString() ?? 'unknown';
      print(
        '[SLACK_PIPELINE] ws_emit type=$type activity_id=$activityId user_id=$userId delivered_sessions=$delivered',
      );
    }
  }
}
