import '../core/remote/web_socket_client.dart';

class PresenceRemoteDataSource {
  final WebSocketClient _wsClient;

  PresenceRemoteDataSource(this._wsClient);

  Stream<dynamic> watchPresence() {
    return _wsClient.stream;
  }
}
