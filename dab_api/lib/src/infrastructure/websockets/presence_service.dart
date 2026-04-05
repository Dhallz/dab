import 'dart:convert';

import 'package:relic/relic.dart';

class PresenceService {
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

  void broadcast(String type, Map<String, dynamic> data) {
    final payload = jsonEncode({'type': type, 'data': data});
    for (final session in _sessions.keys) {
      session.trySendText(payload);
    }
  }
}
