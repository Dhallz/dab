import 'package:flutter/material.dart';

import '../../../../core/localization/l10n_extension.dart';
import '../../../../core/styles/app_text_styles.dart';
import '../../connected_accounts_notifier.dart';

/// [ARCH: PRESENTATION_WIDGET]
/// ROLE: Branch chip picker nested under a git watch list in Settings.
class SettingsGitBranchPicker extends StatefulWidget {
  final GitWatchDraft draft;
  final ValueChanged<String> onAdd;
  final ValueChanged<String> onRemove;

  const SettingsGitBranchPicker({
    super.key,
    required this.draft,
    required this.onAdd,
    required this.onRemove,
  });

  @override
  State<SettingsGitBranchPicker> createState() =>
      _SettingsGitBranchPickerState();
}

class _SettingsGitBranchPickerState extends State<SettingsGitBranchPicker> {
  int _menuEpoch = 0;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final cs = Theme.of(context).colorScheme;
    final draft = widget.draft;
    final selectedLower = {
      for (final name in draft.draftBranches) name.toLowerCase(),
    };
    final choices = [
      for (final name in draft.availableBranches)
        if (!selectedLower.contains(name.toLowerCase())) name,
    ];

    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.settingsGitWatchesBranchesTitle,
            style: AppTextStyles.labelSmall.copyWith(
              color: cs.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            l10n.settingsGitWatchesBranchesSubtitle,
            style: AppTextStyles.bodySmall.copyWith(color: cs.onSurfaceVariant),
          ),
          if (draft.draftRepos.isEmpty) ...[
            const SizedBox(height: 8),
            Text(
              l10n.settingsGitWatchesBranchesNeedRepos,
              style: AppTextStyles.bodySmall.copyWith(
                color: cs.onSurfaceVariant,
              ),
            ),
          ] else ...[
            if (draft.draftBranches.isNotEmpty) ...[
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final branch in draft.draftBranches)
                    InputChip(
                      label: Text(branch),
                      onDeleted: draft.saving
                          ? null
                          : () => widget.onRemove(branch),
                    ),
                ],
              ),
            ],
            if (draft.branchesError != null) ...[
              const SizedBox(height: 8),
              Text(
                draft.branchesError!,
                style: AppTextStyles.bodySmall.copyWith(color: cs.error),
              ),
            ],
            const SizedBox(height: 8),
            if (draft.branchesLoading)
              const LinearProgressIndicator()
            else
              DropdownMenu<String>(
                key: ValueKey(_menuEpoch),
                expandedInsets: EdgeInsets.zero,
                requestFocusOnTap: true,
                enableFilter: true,
                enabled: !draft.saving && choices.isNotEmpty,
                hintText: l10n.settingsGitWatchesBranchesSearch,
                dropdownMenuEntries: [
                  for (final name in choices)
                    DropdownMenuEntry<String>(value: name, label: name),
                ],
                onSelected: (value) {
                  if (value == null || value.trim().isEmpty) return;
                  widget.onAdd(value);
                  setState(() => _menuEpoch++);
                },
              ),
            if (draft.branchesTruncated) ...[
              const SizedBox(height: 8),
              Text(
                l10n.settingsGitWatchesBranchesTruncated(
                  draft.availableBranches.length,
                ),
                style: AppTextStyles.bodySmall.copyWith(
                  color: cs.onSurfaceVariant,
                ),
              ),
            ],
          ],
        ],
      ),
    );
  }
}
