import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/localization/l10n_extension.dart';
import '../../../core/styles/app_colors.dart';
import '../../../core/styles/app_icons.dart';
import '../../../core/styles/app_spacing.dart';
import '../../../core/styles/app_text_styles.dart';
import '../../../core/widgets/island_bar.dart';
import '../insights_notifier.dart';
import '../insights_state.dart';
import '../models/insights_date_preset.dart';

class InsightsIslandBarContent extends ConsumerWidget {
  const InsightsIslandBarContent({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
    final dateText =
        '${state.startDate.month}/${state.startDate.day} - ${state.endDate.month}/${state.endDate.day}';
    return IslandBar(
      content: Row(
        children: [
          Icon(AppIcons.insights, color: AppColors.primary),
          const SizedBox(width: AppSpacing.s),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  context.l10n.insightsTitle,
                  style: AppTextStyles.titleMedium.copyWith(
                    color: AppColors.onSurfaceHighlight,
                  ),
                ),
                const SizedBox(height: AppSpacing.xxs),
                Text(
                  dateText,
                  style: AppTextStyles.labelMedium.copyWith(
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          Wrap(
            spacing: AppSpacing.xs,
            runSpacing: AppSpacing.xs,
            children: [
              _PresetButton(
                label: context.l10n.insightsPresetToday,
                isSelected: state.datePreset == InsightsDatePreset.today,
                onTap: () => notifier.setDatePreset(InsightsDatePreset.today),
              ),
              _PresetButton(
                label: context.l10n.insightsPresetLast7Days,
                isSelected: state.datePreset == InsightsDatePreset.last7Days,
                onTap: () =>
                    notifier.setDatePreset(InsightsDatePreset.last7Days),
              ),
              _PresetButton(
                label: context.l10n.insightsPresetLast30Days,
                isSelected: state.datePreset == InsightsDatePreset.last30Days,
                onTap: () =>
                    notifier.setDatePreset(InsightsDatePreset.last30Days),
              ),
              _PresetButton(
                label: context.l10n.insightsPresetCustom,
                isSelected: state.datePreset == InsightsDatePreset.custom,
                onTap: () => _pickCustomRange(context, notifier, state),
              ),
            ],
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
    final pickedStart = await showDatePicker(
      context: context,
      initialDate: state.startDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (pickedStart == null || !context.mounted) {
      return;
    }
    final pickedEnd = await showDatePicker(
      context: context,
      initialDate: state.endDate,
      firstDate: pickedStart,
      lastDate: DateTime.now(),
    );
    if (pickedEnd == null) {
      return;
    }
    await notifier.setDateRange(pickedStart, pickedEnd);
  }
}

class _PresetButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _PresetButton({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: isSelected
          ? AppColors.primary.withValues(alpha: 0.25)
          : AppColors.surfaceContainerLow.withValues(alpha: 0.35),
      borderRadius: BorderRadius.circular(999),
      child: InkWell(
        borderRadius: BorderRadius.circular(999),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.s,
            vertical: AppSpacing.xs,
          ),
          child: Text(
            label,
            style: AppTextStyles.labelMedium.copyWith(
              color: isSelected ? AppColors.primary : AppColors.onSurface,
            ),
          ),
        ),
      ),
    );
  }
}
