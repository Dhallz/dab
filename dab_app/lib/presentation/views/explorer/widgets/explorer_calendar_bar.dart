import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../core/app_bloc_consumer.dart';
import '../../../core/extensions/date_extensions.dart';
import '../../../core/widgets/dab_app_bar.dart';
import '../explorer_bloc.dart';
import '../explorer_event.dart';
import '../explorer_state.dart';

class ExplorerCalendarBar extends StatefulWidget {
  const ExplorerCalendarBar({super.key});

  @override
  State<ExplorerCalendarBar> createState() => _ExplorerCalendarBarState();
}

class _ExplorerCalendarBarState extends State<ExplorerCalendarBar> {
  late PageController _pageController;
  static const int _initialPage = 10000;
  DateTime? _anchorDate;
  DateTime? _previewDate;
  bool _isInternalUpdating = false;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 1 / 7);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _syncPageToDate(DateTime selectedDate) {
    _anchorDate ??= selectedDate;
    _previewDate = selectedDate;

    final diff = selectedDate.difference(_anchorDate!).inDays;
    final targetPage = _initialPage + diff;

    if (_pageController.hasClients &&
        _pageController.page?.round() != targetPage) {
      _isInternalUpdating = true;
      _pageController
          .animateToPage(
            targetPage,
            duration: const Duration(milliseconds: 600),
            curve: Curves.easeOutCubic,
          )
          .then((_) {
            if (mounted) {
              setState(() {
                _isInternalUpdating = false;
              });
            }
          });
    }
  }

  void _onPageChanged(int page, ExplorerBloc bloc, DateTime currentDate) {
    if (_isInternalUpdating) return;

    final diff = page - _initialPage;
    final targetDate = _anchorDate!.add(Duration(days: diff));

    setState(() {
      _previewDate = targetDate;
    });

    if (!DateUtils.isSameDay(targetDate, currentDate)) {
      bloc.add(ExplorerDateChanged(targetDate));
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppBlocConsumer<ExplorerBloc, ExplorerState>(
      listener: (context, state, bloc) {
        if (!_isInternalUpdating) {
          _syncPageToDate(state.selectedDate);
        }
      },
      builder: (context, state, bloc) {
        final displayDate = _previewDate ?? state.selectedDate;

        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            DabAppBar(
              actions: [_buildJumpToDateButton(context, displayDate, bloc)],
              child: _buildDateSelector(context, state, bloc, displayDate),
            ),
            const SizedBox(height: 24),
            _buildHeader(state, displayDate),
          ],
        );
      },
    );
  }

  Widget _buildDateSelector(
    BuildContext context,
    ExplorerState state,
    ExplorerBloc bloc,
    DateTime displayDate,
  ) {
    if (_anchorDate == null) {
      _anchorDate = state.selectedDate;
      _previewDate = state.selectedDate;
      _pageController = PageController(
        initialPage: _initialPage,
        viewportFraction: 1 / 7,
      );
    }

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
                // (Page index target is always the center, which is the 4th item)
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
                  controller: _pageController,
                  onPageChanged: (page) =>
                      _onPageChanged(page, bloc, state.selectedDate),
                  itemBuilder: (context, index) {
                    final diff = index - _initialPage;
                    final date = _anchorDate!.add(Duration(days: diff));
                    final isSelected = DateUtils.isSameDay(date, displayDate);

                    return Center(
                      child: _DateButton(
                        date: date,
                        isSelected: isSelected,
                        onTap: () {
                          _pageController.animateToPage(
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

  Widget _buildJumpToDateButton(
    BuildContext context,
    DateTime selectedDate,
    ExplorerBloc bloc,
  ) {
    return InkWell(
      onTap: () async {
        final date = await showDatePicker(
          context: context,
          initialDate: selectedDate,
          firstDate: DateTime(2020),
          lastDate: DateTime.now(),
          builder: (context, child) {
            return Theme(
              data: Theme.of(context).copyWith(
                colorScheme: const ColorScheme.dark(
                  primary: Color(0xFF6366F1),
                  onPrimary: Colors.white,
                  surface: Color(0xFF1E293B),
                  onSurface: Colors.white,
                ),
              ),
              child: child!,
            );
          },
        );
        if (date != null) {
          bloc.add(ExplorerDateChanged(date));
        }
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.calendar_month_rounded,
              color: Color(0xFFCBD5E1),
              size: 18,
            ),
            SizedBox(width: 8),
            Text(
              'Jump to date',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Color(0xFFCBD5E1),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(ExplorerState state, DateTime displayDate) {
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
                  state.status == ExplorerStatus.loading
                      ? 'Fetching activities...'
                      : 'Viewing ${state.activities.length} archived activities from this date.',
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
}

class _DateButton extends StatefulWidget {
  final DateTime date;
  final bool isSelected;
  final VoidCallback onTap;

  const _DateButton({
    required this.date,
    required this.isSelected,
    required this.onTap,
  });

  @override
  State<_DateButton> createState() => _DateButtonState();
}

class _DateButtonState extends State<_DateButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final isWeekend =
        widget.date.weekday == DateTime.saturday ||
        widget.date.weekday == DateTime.sunday;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: 70,
          padding: EdgeInsets.symmetric(vertical: widget.isSelected ? 12 : 8),
          decoration: BoxDecoration(
            color: _isHovered && !widget.isSelected
                ? Colors.white.withValues(alpha: 0.05)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                DateFormat('E').format(widget.date).toUpperCase(),
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: widget.isSelected
                      ? const Color(0xFF6366F1)
                      : isWeekend
                      ? const Color(0xFF64748B).withValues(alpha: 0.5)
                      : const Color(0xFF94A3B8).withValues(alpha: 0.6),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                DateFormat('d').format(widget.date),
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: widget.isSelected
                      ? const Color(0xFF6366F1)
                      : isWeekend
                      ? const Color(0xFF94A3B8).withValues(alpha: 0.7)
                      : const Color(0xFF94A3B8),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
