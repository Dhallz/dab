import 'package:flutter/material.dart';

import '../../explorer_notifier.dart';
import '../../explorer_state.dart';
import 'explorer_date_strip.dart';

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
        return ExplorerDateStrip(
          selectedDate: DateUtils.dateOnly(state.selectedDate),
          notifier: notifier,
          visibleDays: visibleDays,
          width: constraints.maxWidth,
        );
      },
    );
  }
}
