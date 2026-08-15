import 'package:redis/redis.dart';

class RedisClient {
  final String host;
  final int port;
  final String? password;

  Command? _command;

  RedisClient({required this.host, required this.port, this.password});

  Future<void> connect() async {
    final conn = RedisConnection();
    _command = await conn.connect(host, port);
    if (password != null) {
      await _command!.send_object(['AUTH', password]);
    }
  }

  Command get command {
    if (_command == null) {
      throw StateError('RedisClient not connected. Call connect() first.');
    }
    return _command!;
  }

  Future<void> disconnect() async {
    // Basic redis package doesn't have a direct disconnect on Command,
    // usually handled by connection closing or ignored in long-running processes.
  }
}
