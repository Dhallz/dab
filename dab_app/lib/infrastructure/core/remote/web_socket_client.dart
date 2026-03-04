import 'dart:async';

import 'package:web_socket_channel/web_socket_channel.dart';

class WebSocketClient {
  final String url;
  WebSocketChannel? _channel;
  final _controller = StreamController<dynamic>.broadcast();

  WebSocketClient(this.url);

  Stream<dynamic> get stream => _controller.stream;

  void connect() {
    _channel = WebSocketChannel.connect(Uri.parse(url));
    _channel!.stream.listen(
      (data) => _controller.add(data),
      onDone: () {
        print('WS Connection closed. Reconnecting...');
        Future.delayed(const Duration(seconds: 5), () => connect());
      },
      onError: (e) {
        print('WS Error: $e');
        _channel?.sink.close();
      },
    );
  }

  void disconnect() {
    _channel?.sink.close();
  }
}
