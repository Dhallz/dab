import '../repositories/abs_i_inbox_local_notification.dart';

/// [ARCH: DOMAIN]
/// ROLE: No-op inbox banners for tests and platforms without a plugin.
class NoopInboxLocalNotification implements IInboxLocalNotification {
  const NoopInboxLocalNotification();

  @override
  Future<void> show({
    required String notificationId,
    required String title,
    required String body,
  }) async {}
}
