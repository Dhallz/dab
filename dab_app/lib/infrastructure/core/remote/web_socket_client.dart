import 'dart:async';
import 'dart:io';

import 'package:web_socket_channel/io.dart';

class WebSocketClient {
  String _url;
  final Future<String?> Function()? tokenProvider;
  IOWebSocketChannel? _channel;
  final _controller = StreamController<dynamic>.broadcast();
  StreamSubscription? _subscription;
  Timer? _reconnectTimer;
  bool _isConnecting = false;
  bool _manualDisconnect = false;

  WebSocketClient(String url, {this.tokenProvider}) : _url = url;

  String get url => _url;

  /// Disconnects if the origin changed so the next [connect] uses [url].
  void setUrl(String url) {
    if (url == _url) return;
    disconnect();
    _url = url;
  }

  Stream<dynamic> get stream => _controller.stream;

  Future<void> connect() async {
    if (_isConnecting || _channel != null) {
      return;
    }

    _isConnecting = true;
    _manualDisconnect = false;

    try {
      final token = await tokenProvider?.call();
      final headers = <String, dynamic>{};
      if (token != null && token.trim().isNotEmpty) {
        headers['Authorization'] = 'Bearer ${token.trim()}';
      }

      final socket = await WebSocket.connect(
        _url,
        headers: headers.isEmpty ? null : headers,
      );
      final channel = IOWebSocketChannel(socket);
      _channel = channel;
      _subscription?.cancel();
      _subscription = channel.stream.listen(
        (data) => _controller.add(data),
        onDone: () {
          _cleanupSocket();
          if (_manualDisconnect) {
            return;
          }
          _scheduleReconnect();
        },
        onError: (_) {
          _cleanupSocket();
          if (_manualDisconnect) {
            return;
          }
          _scheduleReconnect();
        },
      );
    } on Object {
      _cleanupSocket();
      if (!_manualDisconnect) {
        _scheduleReconnect();
      }
    } finally {
      _isConnecting = false;
    }
  }

  void disconnect() {
    _manualDisconnect = true;
    _reconnectTimer?.cancel();
    _reconnectTimer = null;
    _subscription?.cancel();
    _subscription = null;
    _channel?.sink.close();
    _channel = null;
  }

  void _cleanupSocket() {
    _subscription?.cancel();
    _subscription = null;
    _channel = null;
  }

  void _scheduleReconnect() {
    _reconnectTimer?.cancel();
    _reconnectTimer = Timer(const Duration(seconds: 3), () {
      connect();
    });
  }
}
