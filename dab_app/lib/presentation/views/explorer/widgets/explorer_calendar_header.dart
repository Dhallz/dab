import 'package:flutter/material.dart';

import '../../../core/localization/l10n_extension.dart';
import '../../../core/styles/app_spacing.dart';
import '../../../core/styles/app_text_styles.dart';
import '../explorer_state.dart';
import '../models/explorer_date_mode.dart';
import '../models/explorer_item.dart';
import 'explorer_top_activity_kind_summary_buttons/explorer_top_activity_kind_summary_buttons.dart';
import 'explorer_top_heat_bar.dart';

/// [ARCH: PRESENTATION_WIDGET]
/// ROLE: Second Explorer toolbar row — activity count, kind chips, heat.
class ExplorerCalendarHeader extends StatelessWidget {
  final ExplorerState state;

  const ExplorerCalendarHeader({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Row(
      children: [
        Flexible(
          child: Text(
            _buildStatusText(context),
            style: AppTextStyles.labelLarge.copyWith(
              color: cs.onSurfaceVariant,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(width: AppSpacing.s),
        ExplorerTopActivityKindSummaryButtons(state: state, compact: true),
        ExplorerTopHeatBar(state: state, compact: true),
      ],
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

  int _countActivities(ExplorerItem item) => switch (item) {
    SingleActivityItem() => 1,
    TaskActivityItem(:final activities) => activities.length,
    SlackConversationItem(:final activities) => activities.length,
  };
}
