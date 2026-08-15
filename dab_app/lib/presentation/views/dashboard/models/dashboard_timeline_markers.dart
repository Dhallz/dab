import '../../../../domain/core/org_calendar.dart';
import '../../../../domain/entities/activity/activity.dart';

/// Whether the Timeline rail should show a date crumb above [index].
///
/// Always true for the first visible item; otherwise true when the
/// org-calendar day differs from the previous item.
bool dashboardTimelineShowsDayCrumb({
  required List<Activity> activities,
  required int index,
  required String orgTimezoneId,
}) {
  if (index < 0 || index >= activities.length) return false;
  if (index == 0) return true;
  return orgDayKeyFromUtc(orgTimezoneId, activities[index].createdAt) !=
      orgDayKeyFromUtc(orgTimezoneId, activities[index - 1].createdAt);
}
