import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/localization/l10n_extension.dart';
import '../../../core/models/view_status.dart';
import '../../../core/styles/app_icons.dart';
import '../../../core/styles/app_layout.dart';
import '../../../core/styles/app_spacing.dart';
import '../../../core/widgets/dab_toggle_chip.dart';
import '../../../core/widgets/view_toolbar.dart';
import '../explorer_notifier.dart';
import '../models/explorer_date_mode.dart';
import 'explorer_calendar_header.dart';
import 'explorer_date_selector.dart';
import 'explorer_range_mode_date_selector.dart';

/// [ARCH: PRESENTATION_WIDGET]
/// ROLE: Explorer toolbar — date strip + mode chips on the first row,
/// activity count and kind chips on the second.
class ExplorerIslandBarContent extends ConsumerWidget {
  final bool showHeader;

  const ExplorerIslandBarContent({super.key, this.showHeader = true});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
    final isLoading = state.status == ViewStatus.loading;
    final today = DateTime.now();
    final horizontal = ViewToolbar.horizontalPadding(context);

    final refreshButton = IconButton(
      tooltip: context.l10n.explorerClearCacheRefreshTooltip,
      visualDensity: VisualDensity.compact,
      style: IconButton.styleFrom(
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      onPressed: isLoading ? null : () => notifier.clearCacheAndRefresh(),
      icon: isLoading
          ? const SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : Icon(AppIcons.refresh, size: AppLayout.iconMedium),
    );

    return Padding(
      padding: EdgeInsets.fromLTRB(horizontal, 8, horizontal, 8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: state.dateMode == ExplorerDateMode.singleDay
                    ? ExplorerDateSelector(state: state, notifier: notifier)
                    : SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: ExplorerRangeModeDateSelector(
                          startDate: state.rangeStartDate ?? state.selectedDate,
                          endDate: state.rangeEndDate ?? state.selectedDate,
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
              ),
              const SizedBox(width: AppSpacing.s),
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
                  final weekEnd = DateTime(today.year, today.month, today.day);
                  notifier.changeDateRange(weekStart, weekEnd);
                },
              ),
              const SizedBox(width: AppSpacing.xs),
              DabToggleChip(
                label: context.l10n.explorerModeSingleDay,
                isSelected: state.dateMode == ExplorerDateMode.singleDay,
                onTap: () =>
                    notifier.changeDateMode(ExplorerDateMode.singleDay),
              ),
              const SizedBox(width: AppSpacing.xs),
              DabToggleChip(
                label: context.l10n.explorerModeRange,
                isSelected: state.dateMode == ExplorerDateMode.range,
                onTap: () => notifier.changeDateMode(ExplorerDateMode.range),
              ),
              refreshButton,
            ],
          ),
          if (showHeader) ...[
            const SizedBox(height: AppSpacing.s),
            ExplorerCalendarHeader(state: state),
          ],
        ],
      ),
    );
  }
}
