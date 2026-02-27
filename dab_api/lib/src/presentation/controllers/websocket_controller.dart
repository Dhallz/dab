import 'package:relic/relic.dart';
import 'package:web_socket/web_socket.dart' as ws_pkg;

class WebSocketController {
  static WebSocketUpgrade handle(Request request) {
    return WebSocketUpgrade((webSocket) async {
      webSocket.sendText('Connected to Relic Real-time!');

      await for (final event in (webSocket as ws_pkg.WebSocket).events) {
        if (event is ws_pkg.TextDataReceived) {
          print('WS Received: ${event.text}');
          // Echo back or broadcast logic goes here
          webSocket.sendText('Echo: ${event.text}');
        }
      }
    });
  }
}
