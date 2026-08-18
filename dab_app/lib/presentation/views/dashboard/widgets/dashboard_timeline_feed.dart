import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../domain/core/org_calendar.dart';
import '../../../../domain/entities/activity/activity.dart';
import '../../../core/styles/app_spacing.dart';
import '../../../core/styles/app_text_styles.dart';
import '../../../features/app/app_notifier.dart';
import '../models/dashboard_timeline_markers.dart';
import '../models/dashboard_watching_placeholder.dart';
import 'dashboard_timeline_row.dart';

/// [ARCH: PRESENTATION_WIDGET]
/// ROLE: Chronological Live Now list with a vertical HH:mm rail.
class DashboardTimelineFeed extends ConsumerWidget {
  final List<Activity> activities;
  final void Function(Activity activity) onArchive;
  final void Function(Activity activity) onUnarchive;
  final bool Function(Activity activity) isFollowing;
  final void Function(Activity activity) onFollow;
  final void Function(Activity activity) onUnfollow;
  final bool compact;

  const DashboardTimelineFeed({
    super.key,
    required this.activities,
    required this.onArchive,
    required this.onUnarchive,
    required this.isFollowing,
    required this.onFollow,
    required this.onUnfollow,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final orgTimezoneId = ref.watch(
      appNotifierProvider.select((s) => s.orgTimezoneId),
    );
    final localeName = Localizations.localeOf(context).toString();
    final timeFormat = DateFormat.Hm(localeName);
    final dayFormat = DateFormat.MMMd(localeName);
    final scheme = Theme.of(context).colorScheme;

    return ListView.builder(
      padding: EdgeInsets.zero,
      itemCount: activities.length,
      itemBuilder: (context, index) {
        final activity = activities[index];
        final local = orgLocalFromUtc(orgTimezoneId, activity.createdAt);
        final showDay = dashboardTimelineShowsDayCrumb(
          activities: activities,
          index: index,
          orgTimezoneId: orgTimezoneId,
          skip: isDashboardWatchingPlaceholder,
        );
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (showDay)
              Padding(
                padding: EdgeInsets.only(
                  bottom: AppSpacing.xs,
                  top: index == 0 ? 0 : AppSpacing.s,
                ),
                child: compact
                    ? Text(
                        dayFormat.format(local),
                        style: AppTextStyles.labelSmall.copyWith(
                          color: scheme.onSurfaceVariant,
                          fontWeight: FontWeight.w700,
                        ),
                      )
                    : SizedBox(
                        width: DashboardTimelineRow.timeColumnWidth,
                        child: Text(
                          dayFormat.format(local),
                          textAlign: TextAlign.end,
                          style: AppTextStyles.labelSmall.copyWith(
                            color: scheme.onSurfaceVariant,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
              ),
            DashboardTimelineRow(
              activity: activity,
              timeLabel: timeFormat.format(local),
              isLast: index == activities.length - 1,
              onArchive:
                  activity.archived || isDashboardWatchingPlaceholder(activity)
                  ? null
                  : () => onArchive(activity),
              onUnarchive: activity.archived
                  ? () => onUnarchive(activity)
                  : null,
              isFollowing: isFollowing(activity),
              onFollow: () => onFollow(activity),
              onUnfollow: () => onUnfollow(activity),
              compact: compact,
            ),
          ],
        );
      },
    );
  }
}
