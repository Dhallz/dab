/// [ARCH: DOMAIN_PORT]
/// ROLE: Shows an OS-local inbox banner. Copy stays on device.
abstract interface class IInboxLocalNotification {
  /// Displays [title] / [body] for [notificationId]. Empty ids are ignored.
  Future<void> show({
    required String notificationId,
    required String title,
    required String body,
  });
}
