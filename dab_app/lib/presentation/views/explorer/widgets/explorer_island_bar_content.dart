import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../../domain/entities/activity/activity.dart';
import '../../../core/app_bloc_consumer.dart';
import '../../../core/extensions/activity_extensions.dart';
import '../../../core/localization/l10n_extension.dart';
import '../../../core/widgets/island_bar.dart';
import '../explorer_bloc.dart';
import '../explorer_event.dart';
import '../explorer_item.dart';
import '../explorer_state.dart';
import '../models/directory_type.dart';
import '../models/explorer_date_mode.dart';
import 'activity_card/activity_intensity_bar.dart';
import 'explorer_calendar_date_button.dart';
import 'explorer_calendar_header.dart';
import 'explorer_date_selector.dart';

/// [ARCH: PRESENTATION_WIDGET]
/// ROLE: Explorer top chrome — [IslandBar] holds only the date strip (full island height); title row sits below like the pre–Island Bar layout.
class ExplorerIslandBarContent extends StatefulWidget {
  final bool showHeader;

  const ExplorerIslandBarContent({super.key, this.showHeader = true});

  @override
  State<ExplorerIslandBarContent> createState() =>
      _ExplorerIslandBarContentState();
}

class _ExplorerIslandBarContentState extends State<ExplorerIslandBarContent> {
  late PageController _pageController;
  static const int _initialPage = 10000;
  DateTime? _anchorDate;
  DateTime? _previewDate;
  bool _isInternalUpdating = false;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(
      initialPage: _initialPage,
      viewportFraction: 1 / 7,
    );
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
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        _pageController
            .animateToPage(
              targetPage,
              duration: const Duration(milliseconds: 600),
              curve: Curves.easeOutCubic,
            )
            .then((_) {
              if (mounted) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (!mounted) return;
                  setState(() {
                    _isInternalUpdating = false;
                  });
                });
              }
            });
      });
    }
  }

  void _onPageChanged(int page, ExplorerBloc bloc, DateTime currentDate) {
    if (_isInternalUpdating) return;

    final diff = page - _initialPage;
    final targetDate = _anchorDate!.add(Duration(days: diff));

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      setState(() {
        _previewDate = targetDate;
      });
    });

    if (!DateUtils.isSameDay(targetDate, currentDate)) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        bloc.add(ExplorerDateChanged(targetDate));
      });
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
        if (_anchorDate == null) {
          _anchorDate = state.selectedDate;
          _previewDate = state.selectedDate;
        }

        final previewDate = _previewDate ?? state.selectedDate;
        final headerDate = state.dateMode == ExplorerDateMode.singleDay
            ? state.selectedDate
            : (state.rangeStartDate ?? state.selectedDate);
        final headerHorizontalPadding = MediaQuery.sizeOf(context).width > 800
            ? 32.0
            : 16.0;

        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            IslandBar(
              content: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 560,
                            height: 78,
                            child: state.dateMode == ExplorerDateMode.singleDay
                                ? ExplorerDateSelector(
                                    state: state,
                                    bloc: bloc,
                                    pageController: _pageController,
                                    anchorDate: _anchorDate!,
                                    displayDate: previewDate,
                                    initialPage: _initialPage,
                                    onPageChanged: (page) => _onPageChanged(
                                      page,
                                      bloc,
                                      state.selectedDate,
                                    ),
                                  )
                                : _RangeModeDateSelector(
                                    startDate:
                                        state.rangeStartDate ??
                                        state.selectedDate,
                                    endDate:
                                        state.rangeEndDate ??
                                        state.selectedDate,
                                    onStartDateSelected: (startDate) {
                                      bloc.add(
                                        ExplorerDateRangeChanged(
                                          startDate: startDate,
                                          endDate:
                                              state.rangeEndDate ??
                                              state.selectedDate,
                                        ),
                                      );
                                    },
                                    onEndDateSelected: (endDate) {
                                      bloc.add(
                                        ExplorerDateRangeChanged(
                                          startDate:
                                              state.rangeStartDate ??
                                              state.selectedDate,
                                          endDate: endDate,
                                        ),
                                      );
                                    },
                                    onRangeSelected: (startDate, endDate) {
                                      bloc.add(
                                        ExplorerDateRangeChanged(
                                          startDate: startDate,
                                          endDate: endDate,
                                        ),
                                      );
                                    },
                                  ),
                          ),
                          const SizedBox(width: 10),
                          _ModeToggleButton(
                            label: state.dateMode == ExplorerDateMode.singleDay
                                ? context.l10n.explorerQuickToday
                                : context.l10n.explorerQuickWeek,
                            isSelected: false,
                            onTap: () {
                              final today = DateTime.now();
                              if (state.dateMode ==
                                  ExplorerDateMode.singleDay) {
                                bloc.add(ExplorerDateChanged(today));
                                return;
                              }
                              final weekStart = DateTime(
                                today.year,
                                today.month,
                                today.day,
                              ).subtract(const Duration(days: 6));
                              final weekEnd = DateTime(
                                today.year,
                                today.month,
                                today.day,
                              );
                              bloc.add(
                                ExplorerDateRangeChanged(
                                  startDate: weekStart,
                                  endDate: weekEnd,
                                ),
                              );
                            },
                          ),
                          const SizedBox(width: 10),
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              _ModeToggleButton(
                                label: context.l10n.explorerModeSingleDay,
                                isSelected:
                                    state.dateMode ==
                                    ExplorerDateMode.singleDay,
                                onTap: () => bloc.add(
                                  const ExplorerDateModeChanged(
                                    ExplorerDateMode.singleDay,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                              _ModeToggleButton(
                                label: context.l10n.explorerModeRange,
                                isSelected:
                                    state.dateMode == ExplorerDateMode.range,
                                onTap: () => bloc.add(
                                  const ExplorerDateModeChanged(
                                    ExplorerDateMode.range,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(width: 16),
                          Container(
                            width: 1,
                            height: 52,
                            color: const Color(0xFF334155),
                          ),
                          const SizedBox(width: 16),
                          _TopActivityKindSummaryButtons(state: state),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  _TopHeatBar(state: state),
                ],
              ),
            ),
            if (widget.showHeader) ...[
              const SizedBox(height: 24),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: headerHorizontalPadding,
                ),
                child: ExplorerCalendarHeader(
                  displayDate: headerDate,
                  state: state,
                ),
              ),
            ],
          ],
        );
      },
    );
  }
}

class _RangeModeDateSelector extends StatelessWidget {
  final DateTime startDate;
  final DateTime endDate;
  final void Function(DateTime startDate) onStartDateSelected;
  final void Function(DateTime endDate) onEndDateSelected;
  final void Function(DateTime startDate, DateTime endDate) onRangeSelected;

  const _RangeModeDateSelector({
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
        _RangeSlot(
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
        _RangeSlot(
          child: ExplorerCalendarDateButton(
            date: aroundStartA,
            isSelected: false,
            onTap: () {},
          ),
        ),
        _RangeSlot(
          child: ExplorerCalendarDateButton(
            date: aroundStartB,
            isSelected: false,
            onTap: () {},
          ),
        ),
        _RangeSlot(
          child: _RangeEllipsisButton(
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
        _RangeSlot(
          child: ExplorerCalendarDateButton(
            date: aroundEndA,
            isSelected: false,
            onTap: () {},
          ),
        ),
        _RangeSlot(
          child: ExplorerCalendarDateButton(
            date: aroundEndB,
            isSelected: false,
            onTap: () {},
          ),
        ),
        _RangeSlot(
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

class _RangeSlot extends StatelessWidget {
  final Widget child;

  const _RangeSlot({required this.child});

  @override
  Widget build(BuildContext context) {
    return SizedBox(width: 80, height: 72, child: Center(child: child));
  }
}

class _RangeEllipsisButton extends StatefulWidget {
  final VoidCallback onTap;

  const _RangeEllipsisButton({required this.onTap});

  @override
  State<_RangeEllipsisButton> createState() => _RangeEllipsisButtonState();
}

class _RangeEllipsisButtonState extends State<_RangeEllipsisButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: 70,
          padding: const EdgeInsets.symmetric(vertical: 6),
          decoration: BoxDecoration(
            color: _isHovered
                ? Colors.white.withValues(alpha: 0.05)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF94A3B8),
                ),
              ),
              SizedBox(height: 4),
              Text(
                ' ... ',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF94A3B8),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ModeToggleButton extends StatefulWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _ModeToggleButton({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  State<_ModeToggleButton> createState() => _ModeToggleButtonState();
}

class _ModeToggleButtonState extends State<_ModeToggleButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          width: 70,
          padding: EdgeInsets.symmetric(vertical: widget.isSelected ? 8 : 6),
          decoration: BoxDecoration(
            color: _isHovered && !widget.isSelected
                ? Colors.white.withValues(alpha: 0.05)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            border: widget.isSelected
                ? Border.all(
                    color: const Color(0xFF6366F1).withValues(alpha: 0.35),
                  )
                : null,
          ),
          child: Center(
            child: Text(
              widget.label.toUpperCase(),
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: widget.isSelected
                    ? const Color(0xFF6366F1)
                    : const Color(0xFF94A3B8).withValues(alpha: 0.75),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _TopActivityKindSummaryButtons extends StatelessWidget {
  final ExplorerState state;

  const _TopActivityKindSummaryButtons({required this.state});

  @override
  Widget build(BuildContext context) {
    final summaries = _buildSummaries(context);

    return Row(
      children: [
        ...summaries.map(
          (summary) => Padding(
            padding: const EdgeInsets.only(right: 14),
            child: Tooltip(
              message: '${summary.label}: ${summary.count}',
              child: Container(
                width: 70,
                padding: const EdgeInsets.symmetric(vertical: 6),
                decoration: BoxDecoration(
                  color: summary.color.withValues(
                    alpha: summary.count == 0 ? 0.04 : 0.08,
                  ),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: summary.color.withValues(
                      alpha: summary.count == 0 ? 0.16 : 0.25,
                    ),
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(summary.icon, size: 13, color: summary.color),
                    const SizedBox(height: 3),
                    Text(
                      '${summary.count}',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: summary.color,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  List<_ActivityKindSummary> _buildSummaries(BuildContext context) {
    const allKeys = <String>[
      'comment',
      'tag',
      'status',
      'review',
      'assignment',
      'commit',
      'message',
      'activity',
    ];
    final counts = <String, int>{};
    final activeColors = <String, Color>{};
    final activities = _flattenActivities();
    final totalActivityCount = activities.length;
    final totalHeatCount = _heatMetricCount(totalActivityCount);

    for (final activity in activities) {
      final key = activity.granularKey();
      counts.update(key, (v) => v + 1, ifAbsent: () => 1);
      activeColors.putIfAbsent(key, () => activity.style(context).color);
    }

    return allKeys.map((key) {
      final count = key == 'activity' ? totalActivityCount : (counts[key] ?? 0);
      final color = count == 0
          ? const Color(0xFF64748B)
          : (key == 'activity'
                ? _heatColor(totalHeatCount)
                : (activeColors[key] ?? const Color(0xFF94A3B8)));
      return _ActivityKindSummary(
        label: _labelForKey(context, key),
        count: count,
        icon: _iconForKey(key),
        color: color,
      );
    }).toList();
  }

  String _labelForKey(BuildContext context, String key) {
    return switch (key) {
      'comment' => context.l10n.activityKindComment,
      'tag' => context.l10n.activityKindTag,
      'status' => context.l10n.activityKindStatus,
      'review' => context.l10n.activityKindReview,
      'assignment' => context.l10n.activityKindAssignment,
      'commit' => context.l10n.activityKindCommit,
      'message' => context.l10n.activityKindMessage,
      _ => context.l10n.activityKindActivity,
    };
  }

  IconData _iconForKey(String key) {
    return switch (key) {
      'comment' => Icons.chat_bubble_outline_rounded,
      'tag' => Icons.local_offer_outlined,
      'status' => Icons.swap_horiz_rounded,
      'review' => Icons.fact_check_outlined,
      'assignment' => Icons.person_add_alt_1_outlined,
      'commit' => Icons.commit_rounded,
      'message' => Icons.chat_outlined,
      _ => Icons.bubble_chart_outlined,
    };
  }

  int _heatMetricCount(int totalCount) {
    final dayCount = _selectedDayCount();
    final scopeCount = _selectedScopeCount();
    final units = (dayCount * scopeCount).clamp(1, 1000000);
    final avgPerUnit = totalCount / units;
    final volumePerSqrtUnit = totalCount / math.sqrt(units);
    final heatScore = (0.8 * avgPerUnit) + (0.2 * volumePerSqrtUnit);
    return heatScore.ceil();
  }

  int _selectedDayCount() {
    if (state.dateMode == ExplorerDateMode.singleDay) {
      return 1;
    }
    final start = state.rangeStartDate ?? state.selectedDate;
    final end = state.rangeEndDate ?? state.selectedDate;
    final days = end.difference(start).inDays.abs() + 1;
    return days <= 0 ? 1 : days;
  }

  int _selectedScopeCount() {
    if (state.directoryType == DirectoryType.users) {
      return state.selectedUserIds.isEmpty ? 1 : state.selectedUserIds.length;
    }
    final ids = <String>{};
    for (final groupId in state.selectedGroupIds) {
      final matching = state.groups.where((g) => g.id == groupId);
      if (matching.isEmpty) continue;
      final group = matching.first;
      ids.addAll(group.members.map((m) => m.id));
    }
    return ids.isEmpty ? 1 : ids.length;
  }

  Color _heatColor(int count) {
    if (count >= 8) return const Color(0xFFFF1744);
    if (count >= 6) return const Color(0xFFFF3D00);
    if (count >= 4) return const Color(0xFFAEEA00);
    if (count >= 2) return const Color(0xFF00E5FF);
    return const Color(0xFF6366F1);
  }

  List<Activity> _flattenActivities() {
    final result = <Activity>[];
    for (final item in state.items) {
      switch (item) {
        case SingleActivityItem(:final activity):
          result.add(activity);
        case TaskActivityItem(:final activities):
          result.addAll(activities);
        case SlackConversationItem(:final activities):
          result.addAll(activities);
      }
    }
    return result;
  }
}

class _TopHeatBar extends StatelessWidget {
  final ExplorerState state;

  const _TopHeatBar({required this.state});

  @override
  Widget build(BuildContext context) {
    final totalCount = _flattenActivities().length;
    if (totalCount == 0) {
      return const SizedBox.shrink();
    }
    final heatCount = _heatMetricCount(totalCount);
    return SizedBox(
      width: 70,
      child: Center(
        child: ActivityIntensityBar(
          activityCount: heatCount,
          accentColor: _heatColor(heatCount),
          direction: Axis.vertical,
        ),
      ),
    );
  }

  List<Activity> _flattenActivities() {
    final result = <Activity>[];
    for (final item in state.items) {
      switch (item) {
        case SingleActivityItem(:final activity):
          result.add(activity);
        case TaskActivityItem(:final activities):
          result.addAll(activities);
        case SlackConversationItem(:final activities):
          result.addAll(activities);
      }
    }
    return result;
  }

  int _heatMetricCount(int totalCount) {
    final dayCount = _selectedDayCount();
    final scopeCount = _selectedScopeCount();
    final units = (dayCount * scopeCount).clamp(1, 1000000);
    final avgPerUnit = totalCount / units;
    final volumePerSqrtUnit = totalCount / math.sqrt(units);
    final heatScore = (0.8 * avgPerUnit) + (0.2 * volumePerSqrtUnit);
    return heatScore.ceil();
  }

  int _selectedDayCount() {
    if (state.dateMode == ExplorerDateMode.singleDay) {
      return 1;
    }
    final start = state.rangeStartDate ?? state.selectedDate;
    final end = state.rangeEndDate ?? state.selectedDate;
    final days = end.difference(start).inDays.abs() + 1;
    return days <= 0 ? 1 : days;
  }

  int _selectedScopeCount() {
    if (state.directoryType == DirectoryType.users) {
      return state.selectedUserIds.isEmpty ? 1 : state.selectedUserIds.length;
    }
    final ids = <String>{};
    for (final groupId in state.selectedGroupIds) {
      final matching = state.groups.where((g) => g.id == groupId);
      if (matching.isEmpty) continue;
      final group = matching.first;
      ids.addAll(group.members.map((m) => m.id));
    }
    return ids.isEmpty ? 1 : ids.length;
  }

  Color _heatColor(int count) {
    if (count >= 8) return const Color(0xFFFF1744);
    if (count >= 6) return const Color(0xFFFF3D00);
    if (count >= 4) return const Color(0xFFAEEA00);
    if (count >= 2) return const Color(0xFF00E5FF);
    return const Color(0xFF6366F1);
  }
}

class _ActivityKindSummary {
  final String label;
  final int count;
  final IconData icon;
  final Color color;

  const _ActivityKindSummary({
    required this.label,
    required this.count,
    required this.icon,
    required this.color,
  });
}
