import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../core/extensions/date_extensions.dart';
import '../explorer_state.dart';
import '../models/explorer_date_mode.dart';
import '../models/explorer_item.dart';

/// [ARCH: PRESENTATION_WIDGET]
/// ROLE: Header display for the active date in the explorer, including activity counts.
class ExplorerCalendarHeader extends StatelessWidget {
  final DateTime displayDate;
  final ExplorerState state;
  final bool compact;

  const ExplorerCalendarHeader({
    super.key,
    required this.displayDate,
    required this.state,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    final isRangeMode = state.dateMode == ExplorerDateMode.range;
    final dayStr = DateFormat('EEEE, MMMM').format(displayDate);
    final dateStr = isRangeMode
        ? _rangeLabel()
        : '$dayStr ${displayDate.withOrdinalSuffix}';
    final shortDate = isRangeMode
        ? _rangeLabel(short: true)
        : '${DateFormat('EEE, MMM').format(displayDate)} ${displayDate.withOrdinalSuffix}';

    final cs = Theme.of(context).colorScheme;
    if (compact) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: Row(
          children: [
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    shortDate,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: cs.onSurface,
                      letterSpacing: -0.2,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    _buildStatusText(),
                    style: TextStyle(
                      fontSize: 11,
                      color: cs.onSurfaceVariant.withValues(alpha: 0.9),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  dateStr,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: cs.onSurface,
                    letterSpacing: -0.5,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  _buildStatusText(),
                  style: TextStyle(
                    fontSize: 14,
                    color: cs.onSurfaceVariant.withValues(alpha: 0.9),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _buildStatusText() {
    final activityCount = state.items.fold<int>(
      0,
      (sum, item) => sum + _countActivities(item),
    );

    if (state.dateMode == ExplorerDateMode.range) {
      return 'Viewing $activityCount archived activities from this range.';
    }
    return 'Viewing $activityCount archived activities from this date.';
  }

  String _rangeLabel({bool short = false}) {
    final startDate = state.rangeStartDate ?? displayDate;
    final endDate = state.rangeEndDate ?? displayDate;
    if (short) {
      final shortFormat = DateFormat('MMM d');
      return '${shortFormat.format(startDate)} - ${shortFormat.format(endDate)}';
    }
    final fullFormat = DateFormat('EEEE, MMMM d');
    return '${fullFormat.format(startDate)} - ${fullFormat.format(endDate)}';
  }

  int _countActivities(ExplorerItem item) => switch (item) {
    SingleActivityItem() => 1,
    TaskActivityItem(:final activities) => activities.length,
    SlackConversationItem(:final activities) => activities.length,
  };
}
