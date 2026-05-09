import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../../domain/entities/activity/activity.dart';
import '../../../../../presentation/core/extensions/activity_extensions.dart';

/// [ARCH: PRESENTATION_WIDGET]
/// ROLE: Individual item within the activity history timeline.
class ActivityHistoryItem extends StatelessWidget {
  final Activity activity;
  final Color accentColor;
  final bool isLast;

  const ActivityHistoryItem({
    super.key,
    required this.activity,
    required this.accentColor,
    required this.isLast,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
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
                    child: Tooltip(
                      message: activity.granularLabel(context),
                      child: Icon(iconData, size: 14, color: accentColor),
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
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: cs.onSurface,
                      ),
                    ),
                    Text(
                      _formatDateDetailed(activity.createdAt),
                      style: TextStyle(
                        fontSize: 10,
                        color: cs.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                MarkdownBody(
                  data: activity.content,
                  styleSheet: MarkdownStyleSheet(
                    p: TextStyle(
                      fontSize: 13,
                      height: 1.4,
                      color: cs.onSurfaceVariant,
                    ),
                    code: TextStyle(
                      backgroundColor: cs.onSurface.withValues(alpha: 0.06),
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
