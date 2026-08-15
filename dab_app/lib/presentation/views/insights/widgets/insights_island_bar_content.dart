import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../core/localization/l10n_extension.dart';
import '../../../core/styles/app_spacing.dart';
import '../../../core/styles/app_text_styles.dart';
import '../../../core/widgets/dab_toggle_chip.dart';
import '../../../core/widgets/island_bar.dart';
import '../insights_notifier.dart';
import '../insights_state.dart';
import '../models/insights_date_preset.dart';

class InsightsIslandBarContent extends ConsumerWidget {
  const InsightsIslandBarContent({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scheme = Theme.of(context).colorScheme;

    ref.watch(
      insightsNotifierProvider.select(
        (s) => (
          startDate: s.startDate,
          endDate: s.endDate,
          datePreset: s.datePreset,
        ),
      ),
    );
    final state = ref.read(insightsNotifierProvider);
    final notifier = ref.read(insightsNotifierProvider.notifier);
    final localeName = Localizations.localeOf(context).toString();
    final dateFmt = DateFormat.yMd(localeName);
    final dateText =
        '${dateFmt.format(state.startDate)} – ${dateFmt.format(state.endDate)}';
    return IslandBar(
      content: Row(
        children: [
          Expanded(
            child: InkWell(
              onTap: () => _pickCustomRange(context, notifier, state),
              borderRadius: BorderRadius.circular(12),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Text(
                  dateText,
                  style: AppTextStyles.titleMedium.copyWith(
                    color: scheme.onSurface,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.s),
          Flexible(
            child: Wrap(
              spacing: AppSpacing.xs,
              runSpacing: AppSpacing.xs,
              alignment: WrapAlignment.end,
              children: [
                DabToggleChip(
                  label: context.l10n.insightsPresetToday,
                  isSelected: state.datePreset == InsightsDatePreset.today,
                  onTap: () => notifier.setDatePreset(InsightsDatePreset.today),
                ),
                DabToggleChip(
                  label: context.l10n.insightsPresetLast7Days,
                  isSelected: state.datePreset == InsightsDatePreset.last7Days,
                  onTap: () =>
                      notifier.setDatePreset(InsightsDatePreset.last7Days),
                ),
                DabToggleChip(
                  label: context.l10n.insightsPresetLast30Days,
                  isSelected: state.datePreset == InsightsDatePreset.last30Days,
                  onTap: () =>
                      notifier.setDatePreset(InsightsDatePreset.last30Days),
                ),
                DabToggleChip(
                  label: context.l10n.insightsPresetCustom,
                  isSelected: state.datePreset == InsightsDatePreset.custom,
                  onTap: () => _pickCustomRange(context, notifier, state),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _pickCustomRange(
    BuildContext context,
    InsightsNotifier notifier,
    InsightsState state,
  ) async {
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      initialDateRange: DateTimeRange(
        start: state.startDate,
        end: state.endDate,
      ),
    );
    if (picked == null) {
      return;
    }
    await notifier.setDateRange(picked.start, picked.end);
  }
}
