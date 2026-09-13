import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:go_router/go_router.dart';

import '../../../domain/repositories/abs_i_inbox_local_notification.dart';
import '../../../presentation/core/navigation/app_route.dart';

/// [ARCH: INFRASTRUCTURE]
/// ROLE: OS-local inbox banners via flutter_local_notifications.
/// CONTRACT: Copy stays on device. Tap opens Dashboard.
class FlutterInboxLocalNotification implements IInboxLocalNotification {
  FlutterInboxLocalNotification({
    required GoRouter router,
    FlutterLocalNotificationsPlugin? plugin,
  }) : _router = router,
       _plugin = plugin ?? FlutterLocalNotificationsPlugin();

  final GoRouter _router;
  final FlutterLocalNotificationsPlugin _plugin;
  Future<void>? _init;
  bool _ready = false;

  /// Requests permission and wires tap → Dashboard. Safe after the first frame.
  Future<void> initialize() => _init ??= _initialize();

  Future<void> _initialize() async {
    const darwin = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );
    final settings = InitializationSettings(
      android: const AndroidInitializationSettings('@mipmap/ic_launcher'),
      iOS: darwin,
      macOS: darwin,
      linux: LinuxInitializationSettings(defaultActionName: 'Open'),
      windows: WindowsInitializationSettings(
        appName: 'DAB',
        appUserModelId: 'DAB.Inbox',
        guid: '8f3c1a2e-6b14-4d90-9c5a-0dab36000001',
      ),
    );
    try {
      await _plugin.initialize(
        settings: settings,
        onDidReceiveNotificationResponse: (_) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _router.go(AppRoute.homeDashboard.path);
          });
        },
      );
      await _plugin
          .resolvePlatformSpecificImplementation<
            MacOSFlutterLocalNotificationsPlugin
          >()
          ?.requestPermissions(alert: true, badge: true, sound: true);
      _ready = true;
    } catch (_) {
      _ready = false;
    }
  }

  @override
  Future<void> show({
    required String notificationId,
    required String title,
    required String body,
  }) async {
    await initialize();
    if (!_ready) return;
    final headline = title.trim();
    if (headline.isEmpty) return;
    await _plugin.show(
      id: notificationId.hashCode & 0x7fffffff,
      title: headline,
      body: body,
      notificationDetails: const NotificationDetails(
        android: AndroidNotificationDetails(
          'dab_inbox',
          'Inbox',
          channelDescription: 'Directed and Following activity banners',
        ),
        iOS: DarwinNotificationDetails(),
        macOS: DarwinNotificationDetails(),
        linux: LinuxNotificationDetails(),
      ),
    );
  }
}
