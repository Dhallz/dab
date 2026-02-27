import '../services/logging_service.dart';

abstract class NotificationProvider {
  Future<void> send(
    String token,
    String title,
    String body, {
    Map<String, dynamic>? data,
  });
}

class PushNotificationService {
  final NotificationProvider? provider;

  PushNotificationService({this.provider});

  Future<void> notify(
    String token,
    String title,
    String body, {
    Map<String, dynamic>? data,
  }) async {
    if (provider == null) {
      LoggingService.log(
        'Push notification dropped (no provider): $title',
        level: 'WARNING',
      );
      return;
    }
    await provider!.send(token, title, body, data: data);
  }
}

// Example FCM Provider stub
class FcmProvider implements NotificationProvider {
  @override
  Future<void> send(
    String token,
    String title,
    String body, {
    Map<String, dynamic>? data,
  }) async {
    LoggingService.log('FCM: Sending notification to $token');
    // Implement actual FCM logic here
  }
}
