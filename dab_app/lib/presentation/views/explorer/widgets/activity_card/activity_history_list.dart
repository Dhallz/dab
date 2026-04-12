import 'package:flutter/material.dart';

import '../../../../../domain/entities/activity/activity.dart';
import '../../../../../presentation/core/styles/app_icons.dart';
import 'activity_history_item.dart';

/// [ARCH: PRESENTATION_WIDGET]
/// ROLE: List container for activity history, formatted as a timeline.
class ActivityHistoryList extends StatelessWidget {
  final List<Activity> activities;
  final Color accentColor;

  const ActivityHistoryList({
    super.key,
    required this.activities,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        // Timeline Header
        Row(
          children: [
            Icon(AppIcons.history, size: 16, color: accentColor),
            const SizedBox(width: 8),
            Text(
              'ACTIVITY HISTORY',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: accentColor,
                letterSpacing: 1.0,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        // Activity Items
        ListView.separated(
          shrinkWrap: true,
          padding: EdgeInsets.zero,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: activities.length,
          separatorBuilder: (context, index) => const SizedBox(height: 24),
          itemBuilder: (context, index) {
            final activity = activities[index];
            return ActivityHistoryItem(
              activity: activity,
              accentColor: accentColor,
              isLast: index == activities.length - 1,
            );
          },
        ),
      ],
    );
  }
}
