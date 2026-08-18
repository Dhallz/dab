import '../../repositories/abs_i_inbox_local_notification.dart';

/// [ARCH: APPLICATION_USECASE]
/// ROLE: Shows a local inbox banner when enabled and the window is unfocused.
class NotifyInboxActivity {
  NotifyInboxActivity(this._notifications);

  final IInboxLocalNotification _notifications;

  Future<void> execute({
    required bool enabled,
    required bool windowFocused,
    required String notificationId,
    required String title,
    required String body,
  }) async {
    if (!enabled || windowFocused) return;
    final id = notificationId.trim();
    if (id.isEmpty) return;
    await _notifications.show(
      notificationId: id,
      title: title,
      body: body,
    );
  }
}
