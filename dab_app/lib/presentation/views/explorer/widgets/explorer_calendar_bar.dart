import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../core/app_bloc_consumer.dart';
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
  Timer? _debounceTimer;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.15);
  }

  @override
  void dispose() {
    _pageController.dispose();
    _debounceTimer?.cancel();
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

    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 400), () {
      if (!DateUtils.isSameDay(targetDate, currentDate)) {
        bloc.add(ExplorerDateChanged(targetDate));
      }
    });
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
            _buildDateSelector(context, state, bloc, displayDate),
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
        viewportFraction: 0.15,
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        // Calculate viewportFraction based on approximate item width (78px)
        final double listAreaWidth = (constraints.maxWidth - 160).clamp(
          100.0,
          constraints.maxWidth,
        );
        final double vFraction = (78.0 / listAreaWidth).clamp(0.05, 1.0);

        if (_pageController.viewportFraction != vFraction) {
          final currentPage = _pageController.hasClients
              ? _pageController.page?.round() ?? _initialPage
              : _initialPage;
          _pageController = PageController(
            initialPage: currentPage,
            viewportFraction: vFraction,
          );
        }

        return ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
            child: Container(
              height: 100,
              decoration: BoxDecoration(
                color: const Color(0xFF1E293B).withValues(alpha: 0.6),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.25),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // Static Selection Highlight in the middle
                        Container(
                          width: 78,
                          height: 70,
                          decoration: BoxDecoration(
                            color: const Color(
                              0xFF6366F1,
                            ).withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: const Color(
                                0xFF6366F1,
                              ).withValues(alpha: 0.2),
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
                            final isSelected = DateUtils.isSameDay(
                              date,
                              displayDate,
                            );

                            return Center(
                              child: GestureDetector(
                                onTap: () {
                                  _pageController.animateToPage(
                                    index,
                                    duration: const Duration(milliseconds: 500),
                                    curve: Curves.easeOutCubic,
                                  );
                                },
                                child: _buildDateButton(
                                  DateFormat('E').format(date),
                                  DateFormat('d').format(date),
                                  isSelected: isSelected,
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 1,
                    height: 40,
                    color: Colors.white.withValues(alpha: 0.1),
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: _buildJumpToDateButton(context, displayDate, bloc),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildDateButton(String day, String date, {required bool isSelected}) {
    return Container(
      width: 70,
      padding: EdgeInsets.symmetric(vertical: isSelected ? 12 : 8),
      decoration: const BoxDecoration(color: Colors.transparent),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            day.toUpperCase(),
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: isSelected
                  ? const Color(0xFF6366F1)
                  : const Color(0xFF94A3B8).withValues(alpha: 0.6),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            date,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: isSelected
                  ? const Color(0xFF6366F1)
                  : const Color(0xFF94A3B8),
            ),
          ),
        ],
      ),
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
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
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
    final dateStr = DateFormat('EEEE, MMMM dth').format(displayDate);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Column(
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
              ),
            ],
          ),
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
