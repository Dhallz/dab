import 'package:flutter/material.dart';

import 'explorer_calendar_date_button.dart';
import 'explorer_range_date_slot.dart';
import 'explorer_range_ellipsis_button.dart';

/// [ARCH: PRESENTATION_WIDGET]
/// ROLE: Seven-slot range preview + pickers for Explorer island bar.
class ExplorerRangeModeDateSelector extends StatelessWidget {
  final DateTime startDate;
  final DateTime endDate;
  final void Function(DateTime startDate) onStartDateSelected;
  final void Function(DateTime endDate) onEndDateSelected;
  final void Function(DateTime startDate, DateTime endDate) onRangeSelected;

  const ExplorerRangeModeDateSelector({
    super.key,
    required this.startDate,
    required this.endDate,
    required this.onStartDateSelected,
    required this.onEndDateSelected,
    required this.onRangeSelected,
  });

  @override
  Widget build(BuildContext context) {
    final aroundStartA = startDate.add(const Duration(days: 1));
    final aroundStartB = startDate.add(const Duration(days: 2));
    final aroundEndA = endDate.subtract(const Duration(days: 2));
    final aroundEndB = endDate.subtract(const Duration(days: 1));

    return Row(
      children: [
        ExplorerRangeDateSlot(
          child: ExplorerCalendarDateButton(
            date: startDate,
            isSelected: true,
            onTap: () async {
              final picked = await showDatePicker(
                context: context,
                initialDate: startDate,
                firstDate: DateTime(2020),
                lastDate: DateTime.now(),
              );
              if (picked != null) {
                onStartDateSelected(picked);
              }
            },
          ),
        ),
        ExplorerRangeDateSlot(
          child: ExplorerCalendarDateButton(
            date: aroundStartA,
            isSelected: false,
            onTap: () {},
          ),
        ),
        ExplorerRangeDateSlot(
          child: ExplorerCalendarDateButton(
            date: aroundStartB,
            isSelected: false,
            onTap: () {},
          ),
        ),
        ExplorerRangeDateSlot(
          child: ExplorerRangeEllipsisButton(
            onTap: () async {
              final range = await showDateRangePicker(
                context: context,
                firstDate: DateTime(2020),
                lastDate: DateTime.now(),
                initialDateRange: DateTimeRange(start: startDate, end: endDate),
              );
              if (range != null) {
                onRangeSelected(range.start, range.end);
              }
            },
          ),
        ),
        ExplorerRangeDateSlot(
          child: ExplorerCalendarDateButton(
            date: aroundEndA,
            isSelected: false,
            onTap: () {},
          ),
        ),
        ExplorerRangeDateSlot(
          child: ExplorerCalendarDateButton(
            date: aroundEndB,
            isSelected: false,
            onTap: () {},
          ),
        ),
        ExplorerRangeDateSlot(
          child: ExplorerCalendarDateButton(
            date: endDate,
            isSelected: true,
            onTap: () async {
              final picked = await showDatePicker(
                context: context,
                initialDate: endDate,
                firstDate: DateTime(2020),
                lastDate: DateTime.now(),
              );
              if (picked != null) {
                onEndDateSelected(picked);
              }
            },
          ),
        ),
      ],
    );
  }
}
