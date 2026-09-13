import 'package:dab_app/domain/repositories/abs_i_inbox_local_notification.dart';
import 'package:dab_app/domain/usecases/activity/notify_inbox_activity.dart';
import 'package:flutter_test/flutter_test.dart';

class _RecordingInbox implements IInboxLocalNotification {
  int calls = 0;
  String? lastId;
  String? lastTitle;
  String? lastBody;

  @override
  Future<void> show({
    required String notificationId,
    required String title,
    required String body,
  }) async {
    calls += 1;
    lastId = notificationId;
    lastTitle = title;
    lastBody = body;
  }
}

void main() {
  test('skips when disabled or focused', () async {
    final port = _RecordingInbox();
    final useCase = NotifyInboxActivity(port);

    await useCase.execute(
      enabled: false,
      windowFocused: false,
      notificationId: 'a-1:directed',
      title: 'Hello',
      body: 'Directed',
    );
    await useCase.execute(
      enabled: true,
      windowFocused: true,
      notificationId: 'a-1:directed',
      title: 'Hello',
      body: 'Directed',
    );

    expect(port.calls, 0);
  });

  test('shows when enabled and unfocused', () async {
    final port = _RecordingInbox();
    final useCase = NotifyInboxActivity(port);

    await useCase.execute(
      enabled: true,
      windowFocused: false,
      notificationId: 'a-1:follow',
      title: 'Hello',
      body: 'Following',
    );

    expect(port.calls, 1);
    expect(port.lastId, 'a-1:follow');
    expect(port.lastTitle, 'Hello');
    expect(port.lastBody, 'Following');
  });
}
