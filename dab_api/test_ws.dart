import 'dart:io';

void main() async {
  print('Attempting to connect to ws://localhost:8080/ws...');
  try {
    final socket = await WebSocket.connect('ws://localhost:8080/ws');
    print('Connected successfully!');

    socket.listen((data) {
      print('Received: $data');
    });

    socket.add('Hello from test client');
    await Future.delayed(Duration(seconds: 2));
    await socket.close();
    print('Closed.');
  } catch (e) {
    print('Connection failed: $e');
  }
}
