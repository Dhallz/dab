import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../core/localization/l10n_extension.dart';
import '../../../core/models/view_status.dart';
import '../../../core/styles/app_icons.dart';
import '../explorer_notifier.dart';
import '../explorer_state.dart';
import '../models/explorer_date_mode.dart';
import '../models/explorer_item.dart';

/// [ARCH: PRESENTATION_WIDGET]
/// ROLE: Header display for the active date in the explorer, including activity counts.
class ExplorerCalendarHeader extends ConsumerWidget {
  final DateTime displayDate;
  final ExplorerState state;
  final bool compact;

  const ExplorerCalendarHeader({
    super.key,
    required this.displayDate,
    required this.state,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localeName = Localizations.localeOf(context).toString();
    final isRangeMode = state.dateMode == ExplorerDateMode.range;
    final dateStr = isRangeMode
        ? _rangeLabel(localeName)
        : DateFormat.yMMMMEEEEd(localeName).format(displayDate);
    final shortDate = isRangeMode
        ? _rangeLabel(localeName, short: true)
        : DateFormat.MMMEd(localeName).format(displayDate);
    final isLoading = state.status == ViewStatus.loading;
    final refreshAction = IconButton(
      tooltip: context.l10n.explorerClearCacheRefreshTooltip,
      onPressed: isLoading
          ? null
          : () => ref
                .read(explorerNotifierProvider.notifier)
                .clearCacheAndRefresh(),
      icon: isLoading
          ? const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : Icon(AppIcons.refresh, size: 20),
    );

    final cs = Theme.of(context).colorScheme;
    if (compact) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: Row(
          children: [
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    shortDate,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: cs.onSurface,
                      letterSpacing: -0.2,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    _buildStatusText(context),
                    style: TextStyle(
                      fontSize: 11,
                      color: cs.onSurfaceVariant.withValues(alpha: 0.9),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            refreshAction,
          ],
        ),
      );
    }

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
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: cs.onSurface,
                    letterSpacing: -0.5,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  _buildStatusText(context),
                  style: TextStyle(
                    fontSize: 14,
                    color: cs.onSurfaceVariant.withValues(alpha: 0.9),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          refreshAction,
        ],
      ),
    );
  }

  String _buildStatusText(BuildContext context) {
    final l10n = context.l10n;
    final activityCount = state.items.fold<int>(
      0,
      (sum, item) => sum + _countActivities(item),
    );

    if (state.dateMode == ExplorerDateMode.range) {
      return l10n.explorerViewingArchivedFromRange(activityCount);
    }
    return l10n.explorerViewingArchivedFromDate(activityCount);
  }

  String _rangeLabel(String localeName, {bool short = false}) {
    final startDate = state.rangeStartDate ?? displayDate;
    final endDate = state.rangeEndDate ?? displayDate;
    if (short) {
      final shortFmt = DateFormat.MMMd(localeName);
      return '${shortFmt.format(startDate)} – ${shortFmt.format(endDate)}';
    }
    final fullFmt = DateFormat.yMMMMEEEEd(localeName);
    return '${fullFmt.format(startDate)} – ${fullFmt.format(endDate)}';
  }

  int _countActivities(ExplorerItem item) => switch (item) {
    SingleActivityItem() => 1,
    TaskActivityItem(:final activities) => activities.length,
    SlackConversationItem(:final activities) => activities.length,
  };
}
