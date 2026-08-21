import 'package:flutter/material.dart';

import '../../explorer_notifier.dart';
import '../explorer_calendar_date_button.dart';

/// [ARCH: PRESENTATION_WIDGET]
/// ROLE: Swipeable strip of calendar day cells centered on the selected date.
class ExplorerDateStrip extends StatelessWidget {
  final DateTime selectedDate;
  final ExplorerNotifier notifier;
  final int visibleDays;
  final double width;

  const ExplorerDateStrip({
    super.key,
    required this.selectedDate,
    required this.notifier,
    required this.visibleDays,
    required this.width,
  });

  DateTime _dayAt(int offset) {
    return DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day + offset,
    );
  }

  void _shiftBy(int days) {
    notifier.scheduleDateChanged(_dayAt(days));
  }

  @override
  Widget build(BuildContext context) {
    final half = visibleDays ~/ 2;
    final itemWidth = width / visibleDays;
    final cs = Theme.of(context).colorScheme;
    const stackHeight = 70.0;

    return GestureDetector(
      onHorizontalDragEnd: (details) {
        final velocity = details.primaryVelocity ?? 0;
        if (velocity.abs() < 120) {
          return;
        }
        final days = velocity > 0 ? -1 : 1;
        _shiftBy(days);
      },
      child: SizedBox(
        width: width,
        height: stackHeight,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: (itemWidth - 10).clamp(52.0, 80.0),
              height: 58,
              decoration: BoxDecoration(
                color: cs.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: cs.primary.withValues(alpha: 0.22)),
              ),
            ),
            Row(
              children: [
                for (var offset = -half; offset <= half; offset++)
                  SizedBox(
                    width: itemWidth,
                    height: stackHeight,
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () => notifier.scheduleDateChanged(_dayAt(offset)),
                      child: Center(
                        child: ExplorerCalendarDateButton(
                          date: _dayAt(offset),
                          isSelected: offset == 0,
                          onTap: () =>
                              notifier.scheduleDateChanged(_dayAt(offset)),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
