import 'package:flutter/material.dart';

import '../explorer_notifier.dart';
import '../explorer_state.dart';
import 'explorer_calendar_date_button.dart';

/// Minimum width of one day cell so weekday + number stay tappable.
const double _kMinDayCellWidth = 72;

/// [ARCH: PRESENTATION_WIDGET]
/// ROLE: Interactive horizontal date selector for the explorer timeline.
/// CONTRACT: Fills its parent width with an odd number of calendar days
/// centered on [ExplorerState.selectedDate]. A tap selects that exact day.
class ExplorerDateSelector extends StatelessWidget {
  final ExplorerState state;
  final ExplorerNotifier notifier;

  const ExplorerDateSelector({
    super.key,
    required this.state,
    required this.notifier,
  });

  /// Odd count so the selected day stays in the middle of the strip.
  static int visibleDayCount(double width) {
    if (!width.isFinite || width <= 0) {
      return 7;
    }
    var count = (width / _kMinDayCellWidth).floor();
    if (count < 5) {
      count = 5;
    }
    if (count > 21) {
      count = 21;
    }
    if (count.isEven) {
      count -= 1;
    }
    return count;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (!constraints.hasBoundedWidth || constraints.maxWidth < 1) {
          return const SizedBox(height: 70);
        }
        final visibleDays = visibleDayCount(constraints.maxWidth);
        return _ExplorerDateStrip(
          selectedDate: DateUtils.dateOnly(state.selectedDate),
          notifier: notifier,
          visibleDays: visibleDays,
          width: constraints.maxWidth,
        );
      },
    );
  }
}

class _ExplorerDateStrip extends StatelessWidget {
  final DateTime selectedDate;
  final ExplorerNotifier notifier;
  final int visibleDays;
  final double width;

  const _ExplorerDateStrip({
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
