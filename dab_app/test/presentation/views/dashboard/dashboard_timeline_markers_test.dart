import 'package:dab_app/domain/core/org_calendar.dart';
import 'package:dab_app/domain/entities/activity/activity.dart';
import 'package:dab_app/presentation/views/dashboard/models/dashboard_timeline_markers.dart';
import 'package:flutter_test/flutter_test.dart';

Activity _activity({required String id, required DateTime createdAt}) {
  return Activity(
    id: id,
    userId: 'u-1',
    provider: const SlackMessageProvider(channelId: 'C1'),
    title: id,
    content: id,
    authorName: 'Alice',
    commentCount: 0,
    createdAt: createdAt,
  );
}

void main() {
  setUpAll(initializeOrgCalendar);

  const tz = 'America/New_York';

  test('shows a date crumb on the first item and when the org day changes', () {
    final sameDayMorning = DateTime.utc(2026, 7, 3, 14, 0);
    final sameDayLater = DateTime.utc(2026, 7, 3, 18, 0);
    final previousDay = DateTime.utc(2026, 7, 3, 0, 30);

    final activities = [
      _activity(id: 'newest', createdAt: sameDayLater),
      _activity(id: 'mid', createdAt: sameDayMorning),
      _activity(id: 'older', createdAt: previousDay),
    ];

    expect(
      dashboardTimelineShowsDayCrumb(
        activities: activities,
        index: 0,
        orgTimezoneId: tz,
      ),
      isTrue,
    );
    expect(
      dashboardTimelineShowsDayCrumb(
        activities: activities,
        index: 1,
        orgTimezoneId: tz,
      ),
      isFalse,
    );
    expect(
      dashboardTimelineShowsDayCrumb(
        activities: activities,
        index: 2,
        orgTimezoneId: tz,
      ),
      isTrue,
    );
  });
}
