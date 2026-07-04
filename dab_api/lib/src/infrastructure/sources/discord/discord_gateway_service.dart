import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:web_socket_channel/web_socket_channel.dart';

import '../../../application/usecases/activity/ingest_discord_message.dart';
import '../../../domain/entities/provider/provider_config.dart';
import '../../../domain/repositories/abs_i_provider_config_repository.dart';
import 'discord_message_source.dart';

/// [ARCH: INFRASTRUCTURE_SERVICE]
/// ROLE: Outbound WebSocket client for the Discord Gateway (v10).
/// CONTRACT: Discord has no outbound webhooks for message events, so this
/// service maintains a persistent Gateway session: IDENTIFY with the bot
/// token and `GUILD_MESSAGES` + `MESSAGE_CONTENT` intents, heartbeat on the
/// server-provided interval, track sequence numbers, RESUME after drops with
/// exponential backoff. `MESSAGE_CREATE` dispatches are handed to
/// [IngestDiscordMessage] (same persist/fan-out pipeline as webhooks).
/// CONSTRAINTS: Read-only toward Discord — the client never sends anything
/// besides IDENTIFY/RESUME/HEARTBEAT control frames.
class DiscordGatewayService {
  final AbsIProviderConfigRepository _configRepository;
  final IngestDiscordMessage _ingestDiscordMessage;

  DiscordGatewayService(this._configRepository, this._ingestDiscordMessage);

  static const _gatewayUrl = 'wss://gateway.discord.gg/?v=10&encoding=json';

  /// `GUILD_MESSAGES` (1 << 9) + `MESSAGE_CONTENT` (1 << 15).
  static const _intents = (1 << 9) | (1 << 15);

  WebSocketChannel? _channel;
  StreamSubscription<dynamic>? _subscription;
  Timer? _heartbeatTimer;
  Timer? _reconnectTimer;

  bool _running = false;
  int? _lastSequence;
  String? _sessionId;
  String? _resumeGatewayUrl;
  int _reconnectAttempts = 0;

  /// Whether a Gateway session is currently desired (config active + token).
  bool get isRunning => _running;

  /// Whether the Gateway WebSocket is currently connected.
  bool get isConnected => _channel != null;

  /// Starts the Gateway session when the Discord provider is active and has
  /// a bot token; no-op otherwise.
  Future<void> start() async {
    final config = await _activeConfig();
    final token = config == null ? '' : discordBotToken(config.settings);
    if (token.isEmpty) {
      print('[DISCORD_GATEWAY] not started (provider inactive or no token)');
      return;
    }
    if (_running) return;
    _running = true;
    _connect(token);
  }

  /// Re-evaluates configuration: stops when Discord was deactivated,
  /// (re)starts when it became active. Called on provider config saves.
  Future<void> reload() async {
    await stop();
    await start();
  }

  /// Tears down the connection and timers; safe to call repeatedly.
  Future<void> stop() async {
    _running = false;
    _reconnectAttempts = 0;
    _heartbeatTimer?.cancel();
    _heartbeatTimer = null;
    _reconnectTimer?.cancel();
    _reconnectTimer = null;
    await _subscription?.cancel();
    _subscription = null;
    await _channel?.sink.close();
    _channel = null;
  }

  Future<ProviderConfig?> _activeConfig() async {
    final configsResult = await _configRepository.getConfigs();
    final configs = configsResult.getOrElse((_) => const <ProviderConfig>[]);
    for (final c in configs) {
      if (c.id == 'discord' && c.isActive) return c;
    }
    return null;
  }

  void _connect(String token) {
    if (!_running) return;

    final url = _resumeGatewayUrl ?? _gatewayUrl;
    print('[DISCORD_GATEWAY] connecting url=$url');
    try {
      _channel = WebSocketChannel.connect(Uri.parse(url));
    } catch (e) {
      print('[DISCORD_GATEWAY] connect failed: $e');
      _scheduleReconnect(token);
      return;
    }

    _subscription = _channel!.stream.listen(
      (frame) => _onFrame(frame, token),
      onError: (Object e) {
        print('[DISCORD_GATEWAY] stream error: $e');
        _scheduleReconnect(token);
      },
      onDone: () {
        print('[DISCORD_GATEWAY] connection closed');
        _scheduleReconnect(token);
      },
      cancelOnError: true,
    );
  }

  void _onFrame(dynamic frame, String token) {
    final dynamic decoded;
    try {
      decoded = jsonDecode(frame.toString());
    } catch (_) {
      return;
    }
    if (decoded is! Map<String, dynamic>) return;

    final op = decoded['op'];
    final seq = decoded['s'];
    if (seq is int) _lastSequence = seq;

    switch (op) {
      case 10: // HELLO
        final data = decoded['d'];
        final intervalMs = data is Map<String, dynamic>
            ? int.tryParse('${data['heartbeat_interval']}') ?? 41250
            : 41250;
        _startHeartbeat(intervalMs);
        if (_sessionId != null && _lastSequence != null) {
          _send({
            'op': 6, // RESUME
            'd': {
              'token': token,
              'session_id': _sessionId,
              'seq': _lastSequence,
            },
          });
        } else {
          _identify(token);
        }
      case 11: // HEARTBEAT ACK
        break;
      case 1: // HEARTBEAT request
        _send({'op': 1, 'd': _lastSequence});
      case 7: // RECONNECT — Discord asks for a resume
        _restartConnection(token);
      case 9: // INVALID SESSION — d=false means the session is not resumable
        if (decoded['d'] != true) {
          _sessionId = null;
          _resumeGatewayUrl = null;
        }
        _restartConnection(token);
      case 0: // DISPATCH
        _onDispatch(
          (decoded['t'] ?? '').toString(),
          decoded['d'],
        );
    }
  }

  void _onDispatch(String eventType, Object? data) {
    if (eventType == 'READY' && data is Map<String, dynamic>) {
      _sessionId = data['session_id']?.toString();
      final resumeUrl = data['resume_gateway_url']?.toString();
      if (resumeUrl != null && resumeUrl.isNotEmpty) {
        _resumeGatewayUrl = '$resumeUrl?v=10&encoding=json';
      }
      _reconnectAttempts = 0;
      print('[DISCORD_GATEWAY] session ready session_id=$_sessionId');
      return;
    }
    if (eventType == 'RESUMED') {
      _reconnectAttempts = 0;
      print('[DISCORD_GATEWAY] session resumed');
      return;
    }
    if (eventType == 'MESSAGE_CREATE' && data is Map<String, dynamic>) {
      unawaited(
        _ingestDiscordMessage.execute(payload: data).then((result) {
          result.fold((failure) {
            print('Discord live ingestion failed: ${failure.message}');
          }, (_) {});
        }),
      );
    }
  }

  void _identify(String token) {
    _send({
      'op': 2, // IDENTIFY
      'd': {
        'token': token,
        'intents': _intents,
        'properties': {'os': 'linux', 'browser': 'dab', 'device': 'dab'},
      },
    });
  }

  void _startHeartbeat(int intervalMs) {
    _heartbeatTimer?.cancel();
    _heartbeatTimer = Timer.periodic(
      Duration(milliseconds: intervalMs),
      (_) => _send({'op': 1, 'd': _lastSequence}),
    );
  }

  void _send(Map<String, dynamic> payload) {
    try {
      _channel?.sink.add(jsonEncode(payload));
    } catch (e) {
      print('[DISCORD_GATEWAY] send failed: $e');
    }
  }

  void _restartConnection(String token) {
    _heartbeatTimer?.cancel();
    _heartbeatTimer = null;
    unawaited(_subscription?.cancel());
    _subscription = null;
    unawaited(_channel?.sink.close());
    _channel = null;
    _scheduleReconnect(token, immediate: true);
  }

  void _scheduleReconnect(String token, {bool immediate = false}) {
    if (!_running) return;
    if (_reconnectTimer?.isActive ?? false) return;

    _heartbeatTimer?.cancel();
    _heartbeatTimer = null;

    final delaySeconds = immediate
        ? 1
        : min(60, pow(2, min(_reconnectAttempts, 6)).toInt());
    _reconnectAttempts++;
    print('[DISCORD_GATEWAY] reconnecting in ${delaySeconds}s');
    _reconnectTimer = Timer(Duration(seconds: delaySeconds), () {
      _reconnectTimer = null;
      _connect(token);
    });
  }
}
