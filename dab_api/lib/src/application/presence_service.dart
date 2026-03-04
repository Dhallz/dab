import 'dart:convert';

import 'package:relic/relic.dart';

class PresenceService {
  final Set<RelicWebSocket> _sessions = {};

  void addSession(RelicWebSocket session) {
    _sessions.add(session);
    print('WebSocket client connected. Total: ${_sessions.length}');
  }

  void removeSession(RelicWebSocket session) {
    _sessions.remove(session);
    print('WebSocket client disconnected. Total: ${_sessions.length}');
  }

  void broadcast(String type, Map<String, dynamic> data) {
    final payload = jsonEncode({'type': type, 'data': data});
    for (final session in _sessions) {
      session.trySendText(payload);
    }
  }
}
