import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/localization/l10n_extension.dart';
import '../../../core/models/view_status.dart';
import '../../../core/styles/app_icons.dart';
import '../../../core/styles/app_layout.dart';
import '../../../core/styles/app_spacing.dart';
import '../../../core/widgets/dab_toggle_chip.dart';
import '../../../core/widgets/island_bar.dart';
import '../explorer_notifier.dart';
import '../explorer_state.dart';
import '../models/explorer_date_mode.dart';
import 'explorer_calendar_header.dart';
import 'explorer_date_selector.dart';
import 'explorer_range_mode_date_selector.dart';

/// [ARCH: PRESENTATION_WIDGET]
/// ROLE: Explorer Island Bar — date navigation, day/range chips, refresh.
class ExplorerIslandBarContent extends ConsumerStatefulWidget {
  final bool showHeader;

  const ExplorerIslandBarContent({super.key, this.showHeader = true});

  @override
  ConsumerState<ExplorerIslandBarContent> createState() =>
      _ExplorerIslandBarContentState();
}

class _ExplorerIslandBarContentState
    extends ConsumerState<ExplorerIslandBarContent> {
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
        if (!mounted) {
          return;
        }
        _pageController
            .animateToPage(
              targetPage,
              duration: const Duration(milliseconds: 600),
              curve: Curves.easeOutCubic,
            )
            .then((_) {
              if (mounted) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (!mounted) {
                    return;
                  }
                  setState(() {
                    _isInternalUpdating = false;
                  });
                });
              }
            });
      });
    }
  }

  void _onPageChanged(
    int page,
    ExplorerNotifier notifier,
    DateTime currentDate,
  ) {
    if (_isInternalUpdating) {
      return;
    }

    final diff = page - _initialPage;
    final targetDate = _anchorDate!.add(Duration(days: diff));

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }
      setState(() {
        _previewDate = targetDate;
      });
    });

    if (!DateUtils.isSameDay(targetDate, currentDate)) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) {
          return;
        }
        notifier.scheduleDateChanged(targetDate);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(
      explorerNotifierProvider.select(
        (s) => (
          s.selectedDate,
          s.dateMode,
          s.rangeStartDate,
          s.rangeEndDate,
          s.items,
          s.status,
        ),
      ),
    );
    final state = ref.read(explorerNotifierProvider);
    final notifier = ref.read(explorerNotifierProvider.notifier);

    ref.listen<ExplorerState>(explorerNotifierProvider, (previous, next) {
      if (!_isInternalUpdating) {
        _syncPageToDate(next.selectedDate);
      }
    });

    if (_anchorDate == null) {
      _anchorDate = state.selectedDate;
      _previewDate = state.selectedDate;
    }

    final previewDate = _previewDate ?? state.selectedDate;
    final headerDate = state.dateMode == ExplorerDateMode.singleDay
        ? state.selectedDate
        : (state.rangeStartDate ?? state.selectedDate);
    final headerHorizontalPadding = MediaQuery.sizeOf(context).width > 800
        ? AppSpacing.xl
        : AppSpacing.m;
    final isLoading = state.status == ViewStatus.loading;
    final today = DateTime.now();

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
                                notifier: notifier,
                                pageController: _pageController,
                                anchorDate: _anchorDate!,
                                displayDate: previewDate,
                                initialPage: _initialPage,
                                onPageChanged: (page) => _onPageChanged(
                                  page,
                                  notifier,
                                  state.selectedDate,
                                ),
                              )
                            : ExplorerRangeModeDateSelector(
                                startDate:
                                    state.rangeStartDate ?? state.selectedDate,
                                endDate:
                                    state.rangeEndDate ?? state.selectedDate,
                                onStartDateSelected: (startDate) {
                                  notifier.changeDateRange(
                                    startDate,
                                    state.rangeEndDate ?? state.selectedDate,
                                  );
                                },
                                onEndDateSelected: (endDate) {
                                  notifier.changeDateRange(
                                    state.rangeStartDate ?? state.selectedDate,
                                    endDate,
                                  );
                                },
                                onRangeSelected: (startDate, endDate) {
                                  notifier.changeDateRange(startDate, endDate);
                                },
                              ),
                      ),
                      const SizedBox(width: 10),
                      DabToggleChip(
                        label: state.dateMode == ExplorerDateMode.singleDay
                            ? context.l10n.explorerQuickToday
                            : context.l10n.explorerQuickWeek,
                        isSelected: false,
                        onTap: () {
                          if (state.dateMode == ExplorerDateMode.singleDay) {
                            notifier.scheduleDateChanged(today);
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
                          notifier.changeDateRange(weekStart, weekEnd);
                        },
                      ),
                      const SizedBox(width: 10),
                      DabToggleChip(
                        label: context.l10n.explorerModeSingleDay,
                        isSelected:
                            state.dateMode == ExplorerDateMode.singleDay,
                        onTap: () => notifier.changeDateMode(
                          ExplorerDateMode.singleDay,
                        ),
                      ),
                      const SizedBox(width: 8),
                      DabToggleChip(
                        label: context.l10n.explorerModeRange,
                        isSelected: state.dateMode == ExplorerDateMode.range,
                        onTap: () =>
                            notifier.changeDateMode(ExplorerDateMode.range),
                      ),
                    ],
                  ),
                ),
              ),
              IconButton(
                tooltip: context.l10n.explorerClearCacheRefreshTooltip,
                onPressed: isLoading
                    ? null
                    : () => notifier.clearCacheAndRefresh(),
                icon: isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Icon(AppIcons.refresh, size: AppLayout.iconMedium),
              ),
            ],
          ),
        ),
        if (widget.showHeader) ...[
          const SizedBox(height: AppSpacing.l),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: headerHorizontalPadding),
            child: ExplorerCalendarHeader(
              displayDate: headerDate,
              state: state,
            ),
          ),
        ],
      ],
    );
  }
}
