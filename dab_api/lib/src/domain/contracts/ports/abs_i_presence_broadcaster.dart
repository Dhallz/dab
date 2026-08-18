/// [ARCH: DOMAIN_PORT]
/// ROLE: WebSocket fan-out for live activity and triage events.
/// CONTRACT: Application depends on this port, not the WebSocket session map.
/// Session add/remove stays on the infrastructure implementation.
abstract interface class AbsIPresenceBroadcaster {
  /// Sends [type] + [data] to every connected session.
  void broadcast(String type, Map<String, dynamic> data);

  /// Sends [type] + [data] to all sessions owned by [userId].
  void broadcastToUser(String userId, String type, Map<String, dynamic> data);

  /// True when [userId] has at least one connected WebSocket session.
  bool hasSession(String userId);
}
