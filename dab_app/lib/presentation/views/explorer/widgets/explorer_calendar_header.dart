import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../core/extensions/date_extensions.dart';
import '../explorer_item.dart';
import '../explorer_state.dart';

/// [ARCH: PRESENTATION_WIDGET]
/// ROLE: Header display for the active date in the explorer, including activity counts.
class ExplorerCalendarHeader extends StatelessWidget {
  final DateTime displayDate;
  final ExplorerState state;

  const ExplorerCalendarHeader({
    super.key,
    required this.displayDate,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    final dayStr = DateFormat('EEEE, MMMM').format(displayDate);
    final dateStr = '$dayStr ${displayDate.withOrdinalSuffix}';

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
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFF1F5F9),
                    letterSpacing: -0.5,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  _buildStatusText(),
                  style: TextStyle(
                    fontSize: 14,
                    color: const Color(0xFF94A3B8).withValues(alpha: 0.8),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFF1E293B),
              border: Border.all(color: const Color(0xFF334155)),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Text(
              'ARCHIVED FEED',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: Color(0xFF94A3B8),
                letterSpacing: 0.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _buildStatusText() {
    final activityCount = state.items.fold<int>(
      0,
      (sum, item) =>
          sum +
          (item is SingleActivityItem
              ? 1
              : (item as TaskActivityItem).activities.length),
    );

    return 'Viewing $activityCount archived activities from this date.';
  }
}
