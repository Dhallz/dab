import 'package:flutter/material.dart';

import '../../../../core/styles/app_text_styles.dart';

/// [ARCH: PRESENTATION_WIDGET]
/// ROLE: Multi-select chip list for watched Jira/Linear/git objects.
class SettingsWatchListPicker extends StatelessWidget {
  final String title;
  final String subtitle;
  final String empty;
  final String saveLabel;
  final List<({String key, String name})> items;
  final List<String> draftKeys;
  final bool loading;
  final bool saving;
  final bool dirty;
  final bool hasLoaded;
  final String? errorMessage;
  final void Function(String key) onToggle;
  final Future<String?> Function() onSave;
  final Widget? extra;

  const SettingsWatchListPicker({
    super.key,
    required this.title,
    required this.subtitle,
    required this.empty,
    required this.saveLabel,
    required this.items,
    required this.draftKeys,
    required this.loading,
    required this.saving,
    required this.dirty,
    required this.hasLoaded,
    this.errorMessage,
    required this.onToggle,
    required this.onSave,
    this.extra,
  });

  @override
  Widget build(BuildContext context) {
    if (loading && !hasLoaded) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 8),
        child: LinearProgressIndicator(),
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTextStyles.labelSmall.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          subtitle,
          style: AppTextStyles.bodySmall.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 8),
        if (errorMessage != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(
              errorMessage!,
              style: AppTextStyles.bodySmall.copyWith(
                color: Theme.of(context).colorScheme.error,
              ),
            ),
          ),
        if (items.isEmpty && errorMessage == null)
          Text(
            empty,
            style: AppTextStyles.bodySmall.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          )
        else if (items.isNotEmpty)
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final item in items)
                FilterChip(
                  label: Text(
                    item.name == item.key
                        ? item.key
                        : '${item.key} · ${item.name}',
                  ),
                  selected: draftKeys.contains(item.key),
                  onSelected: saving ? null : (_) => onToggle(item.key),
                ),
            ],
          ),
        if (extra != null) extra!,
        if (dirty) ...[
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerRight,
            child: FilledButton(
              onPressed: saving ? null : onSave,
              child: Text(saveLabel),
            ),
          ),
        ],
      ],
    );
  }
}
