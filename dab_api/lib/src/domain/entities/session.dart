import 'package:dart_mappable/dart_mappable.dart';

part 'session.mapper.dart';

@MappableClass()
class Session with SessionMappable {
  final String id;
  final String userId;
  final String refreshToken;
  final DateTime expiresAt;
  final String? deviceInfo;

  Session({
    required this.id,
    required this.userId,
    required this.refreshToken,
    required this.expiresAt,
    this.deviceInfo,
  });
}
