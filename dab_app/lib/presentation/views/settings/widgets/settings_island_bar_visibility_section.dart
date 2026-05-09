import 'package:flutter/material.dart';

import '../../../../domain/entities/system/app_settings.dart';
import '../../../core/localization/l10n_extension.dart';
import '../../../core/styles/app_colors.dart';
import '../../../core/styles/app_text_styles.dart';

/// [ARCH: PRESENTATION_WIDGET]
/// ROLE: Per-view island bar item visibility controls.
class SettingsIslandBarVisibilitySection extends StatelessWidget {
  final AppSettings settings;
  final void Function(String viewId, List<String> selectedItems)
  onSelectionChanged;

  const SettingsIslandBarVisibilitySection({
    super.key,
    required this.settings,
    required this.onSelectionChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (final entry in appSettingsIslandBarItemCatalog.entries)
          _ViewSelectionCard(
            viewId: entry.key,
            itemIds: entry.value,
            settings: settings,
            onSelectionChanged: onSelectionChanged,
          ),
      ],
    );
  }
}

class _ViewSelectionCard extends StatelessWidget {
  final String viewId;
  final List<String> itemIds;
  final AppSettings settings;
  final void Function(String viewId, List<String> selectedItems)
  onSelectionChanged;

  const _ViewSelectionCard({
    required this.viewId,
    required this.itemIds,
    required this.settings,
    required this.onSelectionChanged,
  });

  @override
  Widget build(BuildContext context) {
    final selectedIds = (settings.islandBarSelections[viewId] ??
            appSettingsDefaultIslandBarSelections[viewId] ??
            const <String>[])
        .toSet();
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                _viewLabel(context, viewId),
                style: AppTextStyles.titleSmall.copyWith(
                  color: AppColors.onSurface,
                ),
              ),
            ),
            const SizedBox(height: 4),
            for (final itemId in itemIds)
              CheckboxListTile(
                title: Text(
                  _itemLabel(context, itemId),
                  style: AppTextStyles.bodyMedium,
                ),
                value: selectedIds.contains(itemId),
                onChanged: (isSelected) {
                  final nextSelected = {...selectedIds};
                  if (isSelected == true) {
                    nextSelected.add(itemId);
                  } else {
                    nextSelected.remove(itemId);
                  }
                  onSelectionChanged(viewId, nextSelected.toList());
                },
                activeColor: AppColors.primary,
                controlAffinity: ListTileControlAffinity.leading,
              ),
          ],
        ),
      ),
    );
  }

  String _viewLabel(BuildContext context, String id) {
    switch (id) {
      case appSettingsIslandBarViewDashboard:
        return context.l10n.settingsIslandBarDashboard;
      case appSettingsIslandBarViewExplorer:
        return context.l10n.settingsIslandBarExplorer;
      case appSettingsIslandBarViewInsights:
        return context.l10n.settingsIslandBarInsights;
      default:
        return id;
    }
  }

  String _itemLabel(BuildContext context, String id) {
    switch (id) {
      case 'title':
        return context.l10n.settingsIslandBarItemTitle;
      case 'subtitle':
        return context.l10n.settingsIslandBarItemSubtitle;
      case 'dateControls':
        return context.l10n.settingsIslandBarItemDateControls;
      case 'quickPreset':
        return context.l10n.settingsIslandBarItemQuickPreset;
      case 'dateModeToggle':
        return context.l10n.settingsIslandBarItemDateModeToggle;
      case 'activitySummary':
        return context.l10n.settingsIslandBarItemActivitySummary;
      case 'heatBar':
        return context.l10n.settingsIslandBarItemHeatBar;
      case 'dateRange':
        return context.l10n.settingsIslandBarItemDateRange;
      case 'presets':
        return context.l10n.settingsIslandBarItemPresets;
      default:
        return id;
    }
  }
}
