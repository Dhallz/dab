import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../../domain/entities/activity.dart';
import '../../../../../presentation/core/extensions/activity_ui_extensions.dart';
import '../../../../../presentation/core/styles/app_colors.dart';

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
            Icon(Icons.history_rounded, size: 16, color: accentColor),
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
            return _ActivityHistoryItem(
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

class _ActivityHistoryItem extends StatelessWidget {
  final Activity activity;
  final Color accentColor;
  final bool isLast;

  const _ActivityHistoryItem({
    required this.activity,
    required this.accentColor,
    required this.isLast,
  });

  @override
  Widget build(BuildContext context) {
    final iconData = activity.granularIcon(context);
    
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Timeline Line and Icon
          SizedBox(
            width: 24,
            child: Column(
              children: [
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: accentColor.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: accentColor.withValues(alpha: 0.2),
                    ),
                  ),
                  child: Center(
                    child: Icon(
                      iconData,
                      size: 14,
                      color: accentColor,
                    ),
                  ),
                ),
                if (!isLast)
                  Expanded(
                    child: Container(
                      width: 1,
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      color: accentColor.withValues(alpha: 0.2),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      DateFormat('HH:mm').format(activity.createdAt),
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: AppColors.onSurface,
                      ),
                    ),
                    Text(
                      _formatDateDetailed(activity.createdAt),
                      style: const TextStyle(
                        fontSize: 10,
                        color: AppColors.onSurfaceVariantLow,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                MarkdownBody(
                  data: activity.content,
                  styleSheet: MarkdownStyleSheet(
                    p: const TextStyle(
                      fontSize: 13,
                      height: 1.4,
                      color: AppColors.onSurfaceVariantLow,
                    ),
                    code: TextStyle(
                      backgroundColor: Colors.white.withValues(alpha: 0.05),
                      color: accentColor,
                      fontSize: 11,
                      fontFamily: 'Roboto Mono',
                    ),
                  ),
                  onTapLink: (text, href, title) {
                    if (href != null) {
                      launchUrl(Uri.parse(href));
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatDateDetailed(DateTime date) {
     return DateFormat('MMM d, y').format(date);
  }
}
