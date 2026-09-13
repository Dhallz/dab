import '../../../../domain/core/org_calendar.dart';
import '../../../../domain/entities/activity/activity.dart';

/// Whether the Timeline rail should show a date crumb above [index].
///
/// Always true for the first dated item; otherwise true when the
/// org-calendar day differs from the previous dated item. [skip] items
/// (quiet Following placeholders) never get a crumb.
bool dashboardTimelineShowsDayCrumb({
  required List<Activity> activities,
  required int index,
  required String orgTimezoneId,
  bool Function(Activity activity)? skip,
}) {
  if (index < 0 || index >= activities.length) return false;
  final activity = activities[index];
  if (skip?.call(activity) ?? false) return false;

  var previous = index - 1;
  while (previous >= 0 && (skip?.call(activities[previous]) ?? false)) {
    previous--;
  }
  if (previous < 0) return true;
  return orgDayKeyFromUtc(orgTimezoneId, activity.createdAt) !=
      orgDayKeyFromUtc(orgTimezoneId, activities[previous].createdAt);
}
