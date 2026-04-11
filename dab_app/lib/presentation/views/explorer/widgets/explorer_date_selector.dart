import 'package:flutter/material.dart';

import '../explorer_bloc.dart';
import '../explorer_state.dart';
import 'explorer_calendar_date_button.dart';

/// [ARCH: PRESENTATION_WIDGET]
/// ROLE: Interactive horizontal date selector for the explorer timeline.
class ExplorerDateSelector extends StatelessWidget {
  final ExplorerState state;
  final ExplorerBloc bloc;
  final PageController pageController;
  final DateTime anchorDate;
  final DateTime displayDate;
  final int initialPage;
  final Function(int) onPageChanged;

  const ExplorerDateSelector({
    super.key,
    required this.state,
    required this.bloc,
    required this.pageController,
    required this.anchorDate,
    required this.displayDate,
    required this.initialPage,
    required this.onPageChanged,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // We want to show exactly 7 items, each ~80px wide.
        const double itemWidth = 80.0;
        final double selectorWidth = itemWidth * 7;

        return Align(
          alignment: Alignment.centerLeft,
          child: SizedBox(
            width: selectorWidth,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Static Selection Highlight in the middle of the 7 items
                Container(
                  width: itemWidth - 10,
                  height: 70,
                  decoration: BoxDecoration(
                    color: const Color(0xFF6366F1).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: const Color(0xFF6366F1).withValues(alpha: 0.2),
                    ),
                  ),
                ),
                PageView.builder(
                  controller: pageController,
                  onPageChanged: onPageChanged,
                  itemBuilder: (context, index) {
                    final diff = index - initialPage;
                    final date = anchorDate.add(Duration(days: diff));
                    final isSelected = DateUtils.isSameDay(date, displayDate);

                    return Center(
                      child: ExplorerCalendarDateButton(
                        date: date,
                        isSelected: isSelected,
                        onTap: () {
                          pageController.animateToPage(
                            index,
                            duration: const Duration(milliseconds: 500),
                            curve: Curves.easeOutCubic,
                          );
                        },
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
