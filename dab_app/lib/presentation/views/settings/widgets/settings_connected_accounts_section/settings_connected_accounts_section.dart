import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/localization/app_localizations.dart';
import '../../../../core/localization/l10n_extension.dart';
import '../../../../core/models/view_status.dart';
import '../../../../core/styles/app_text_styles.dart';
import '../../../../features/app/app_notifier.dart';
import '../../connected_accounts_notifier.dart';
import '../settings_section_header.dart';
import 'settings_git_branch_picker.dart';
import 'settings_oauth_provider_card.dart';
import 'settings_phorge_token_card.dart';
import 'settings_watch_list_picker.dart';

/// [ARCH: PRESENTATION_WIDGET]
/// ROLE: Settings cards to connect providers via OAuth (or a Phorge token).
class SettingsConnectedAccountsSection extends ConsumerWidget {
  const SettingsConnectedAccountsSection({super.key});

  static const _oauthProviders = [
    'github',
    'gitlab',
    'bitbucket',
    'jira',
    'linear',
    'figma',
  ];
  static const _tokenProviders = ['phorge'];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(connectedAccountsNotifierProvider);
    final notifier = ref.read(connectedAccountsNotifierProvider.notifier);
    final configs = ref.watch(appNotifierProvider.select((s) => s.configs));
    final l10n = context.l10n;

    final names = {for (final config in configs) config.id: config.name};

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SettingsSectionHeader(title: l10n.settingsConnectedAccountsTitle),
        const SizedBox(height: 8),
        Text(
          l10n.settingsConnectedAccountsSubtitle,
          style: AppTextStyles.bodySmall.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 16),
        if (state.status == ViewStatus.loading)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Center(child: CircularProgressIndicator()),
          )
        else ...[
          for (final id in _oauthProviders)
            SettingsOauthProviderCard(
              providerId: id,
              title: names[id] ?? id,
              summary: state.forProvider(id),
              busy: state.busyProviderId == id,
              onConnect: () => notifier.startOauth(id),
              onDisconnect: () => notifier.disconnect(id),
              jiraPicker: _watchPickerFor(id, state, notifier, l10n),
            ),
          for (final id in _tokenProviders)
            SettingsPhorgeTokenCard(
              title: names[id] ?? id,
              summary: state.forProvider(id),
              busy: state.busyProviderId == id,
              onConnect: (settings) => notifier.connect(id, settings),
              onDisconnect: () => notifier.disconnect(id),
            ),
        ],
      ],
    );
  }

  Widget? _watchPickerFor(
    String id,
    ConnectedAccountsState state,
    ConnectedAccountsNotifier notifier,
    AppLocalizations l10n,
  ) {
    final connected = state.forProvider(id)?.isConnected == true;
    if (!connected) return null;
    if (id == 'jira') {
      return SettingsWatchListPicker(
        title: l10n.settingsJiraProjectsTitle,
        subtitle: l10n.settingsJiraProjectsSubtitle,
        empty: l10n.settingsJiraProjectsEmpty,
        saveLabel: l10n.settingsJiraProjectsSave,
        items: [
          for (final p in state.jiraProjects?.available ?? const [])
            (key: p.key, name: p.name),
        ],
        draftKeys: state.jiraDraftKeys,
        loading: state.jiraProjectsLoading,
        saving: state.jiraProjectsSaving,
        dirty: state.jiraDraftDirty,
        hasLoaded: state.jiraProjects != null,
        errorMessage: state.jiraError,
        onToggle: notifier.toggleJiraProject,
        onSave: notifier.saveJiraProjects,
      );
    }
    if (id == 'linear') {
      return SettingsWatchListPicker(
        title: l10n.settingsLinearTeamsTitle,
        subtitle: l10n.settingsLinearTeamsSubtitle,
        empty: l10n.settingsLinearTeamsEmpty,
        saveLabel: l10n.settingsLinearTeamsSave,
        items: [
          for (final t in state.linearTeams?.available ?? const [])
            (key: t.key, name: t.name),
        ],
        draftKeys: state.linearDraftKeys,
        loading: state.linearTeamsLoading,
        saving: state.linearTeamsSaving,
        dirty: state.linearDraftDirty,
        hasLoaded: state.linearTeams != null,
        errorMessage: state.linearError,
        onToggle: notifier.toggleLinearTeam,
        onSave: notifier.saveLinearTeams,
      );
    }
    if (id == 'github' || id == 'gitlab' || id == 'bitbucket') {
      final draft = state.gitDraft(id);
      return SettingsWatchListPicker(
        title: l10n.settingsGitWatchesTitle,
        subtitle: l10n.settingsGitWatchesSubtitle,
        empty: l10n.settingsGitWatchesEmpty,
        saveLabel: l10n.settingsGitWatchesSave,
        items: [
          for (final repo in draft.watch?.available ?? const [])
            (key: repo.key, name: repo.name),
        ],
        draftKeys: draft.draftRepos,
        loading: draft.loading,
        saving: draft.saving,
        dirty: draft.dirty,
        hasLoaded: draft.hasLoaded,
        errorMessage: draft.error,
        onToggle: (key) => notifier.toggleGitRepo(id, key),
        onSave: () => notifier.saveGitWatches(id),
        extra: SettingsGitBranchPicker(
          draft: draft,
          onAdd: (branch) => notifier.addGitBranch(id, branch),
          onRemove: (branch) => notifier.removeGitBranch(id, branch),
        ),
      );
    }
    return null;
  }
}
