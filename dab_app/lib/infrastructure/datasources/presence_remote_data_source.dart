import '../core/remote/web_socket_client.dart';

/// [ARCH: INFRASTRUCTURE_SOURCE]
/// ROLE: Low-level I/O for Real-time Presence tracking from the Remote API.
/// CONTRACT: Provides a raw stream of socket events.
/// CONSTRAINTS: Purely for socket communication. Uses [WebSocketClient].
class PresenceRemoteDataSource {
  final WebSocketClient _wsClient;

  PresenceRemoteDataSource(this._wsClient);

  Stream<dynamic> watchPresence() {
    return _wsClient.stream;
  }
}
