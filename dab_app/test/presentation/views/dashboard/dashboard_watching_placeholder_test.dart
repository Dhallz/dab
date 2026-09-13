import 'package:dab_app/domain/core/activity_follow_key.dart';
import 'package:dab_app/domain/entities/activity/activity.dart';
import 'package:dab_app/domain/entities/user/activity_follow.dart';
import 'package:dab_app/presentation/core/extensions/activity_extensions.dart';
import 'package:dab_app/presentation/core/extensions/activity_follow_extensions.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('builds a Follow-lane card that round-trips the pin key', () {
    const pin = ActivityFollow(
      providerId: 'jira',
      objectKey: 'DAB-7',
      title: '[DAB-7] Inbox',
      url: '/browse/DAB-7',
    );
    final card = pin.watchingPlaceholderActivity;

    expect(card.isDashboardWatchingPlaceholder, isTrue);
    expect(card.title, '[DAB-7] Inbox');
    expect(card.url, '/browse/DAB-7');
    expect(card.content, isEmpty);
    expect(card.isFollowLane, isTrue);
    expect(card.provider.followObjectRefFor, pin.objectRef);
  });
}
