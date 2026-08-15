import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/localization/l10n_extension.dart';
import '../../../core/models/view_status.dart';
import '../../../core/styles/app_colors.dart';
import '../../../core/styles/app_text_styles.dart';
import '../../../../domain/entities/user/jira_project_watch_list.dart';
import '../../../../domain/entities/user/user_provider_credential_summary.dart';
import '../../../features/app/app_notifier.dart';
import '../connected_accounts_notifier.dart';
import 'settings_section_header.dart';

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
  ];
  static const _tokenProviders = ['phorge'];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(connectedAccountsNotifierProvider);
    final notifier = ref.read(connectedAccountsNotifierProvider.notifier);
    final configs = ref.watch(appNotifierProvider.select((s) => s.configs));
    final l10n = context.l10n;

    final names = {
      for (final config in configs) config.id: config.name,
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SettingsSectionHeader(title: l10n.settingsConnectedAccountsTitle),
        const SizedBox(height: 8),
        Text(
          l10n.settingsConnectedAccountsSubtitle,
          style: AppTextStyles.bodySmall.copyWith(
            color: AppColors.secondary,
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
            _OauthProviderCard(
              providerId: id,
              title: names[id] ?? id,
              summary: state.forProvider(id),
              busy: state.busyProviderId == id,
              onConnect: () => notifier.startOauth(id),
              onDisconnect: () => notifier.disconnect(id),
              jiraPicker: id == 'jira' && state.forProvider(id)?.isConnected == true
                  ? _JiraProjectsPicker(
                      watch: state.jiraProjects,
                      draftKeys: state.jiraDraftKeys,
                      loading: state.jiraProjectsLoading,
                      saving: state.jiraProjectsSaving,
                      dirty: state.jiraDraftDirty,
                      onToggle: notifier.toggleJiraProject,
                      onSave: notifier.saveJiraProjects,
                    )
                  : null,
            ),
          for (final id in _tokenProviders)
            _PhorgeTokenCard(
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
}

class _OauthProviderCard extends StatefulWidget {
  final String providerId;
  final String title;
  final UserProviderCredentialSummary? summary;
  final bool busy;
  final Future<String?> Function() onConnect;
  final Future<String?> Function() onDisconnect;
  final Widget? jiraPicker;

  const _OauthProviderCard({
    required this.providerId,
    required this.title,
    required this.summary,
    required this.busy,
    required this.onConnect,
    required this.onDisconnect,
    this.jiraPicker,
  });

  @override
  State<_OauthProviderCard> createState() => _OauthProviderCardState();
}

class _OauthProviderCardState extends State<_OauthProviderCard> {
  String? _message;
  bool _ok = false;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final connected = widget.summary?.isConnected == true;
    final identity = widget.summary?.externalUsername ??
        widget.summary?.externalId;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(widget.title, style: AppTextStyles.titleSmall),
                ),
                if (connected)
                  Text(
                    identity == null
                        ? l10n.settingsCredentialConnected
                        : '@$identity',
                    style: AppTextStyles.labelSmall.copyWith(
                      color: AppColors.secondary,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            if (_message != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text(
                  _message!,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: _ok
                        ? Colors.green
                        : Theme.of(context).colorScheme.error,
                  ),
                ),
              ),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                FilledButton(
                  onPressed: widget.busy
                      ? null
                      : () async {
                          final error = await widget.onConnect();
                          if (!mounted) return;
                          setState(() {
                            _ok = error == null;
                            _message = error ?? l10n.settingsOauthOpened;
                          });
                        },
                  child: Text(
                    l10n.settingsConnectWithProvider(widget.title),
                  ),
                ),
                if (connected)
                  TextButton(
                    onPressed: widget.busy
                        ? null
                        : () async {
                            final error = await widget.onDisconnect();
                            if (!mounted) return;
                            setState(() {
                              _ok = error == null;
                              _message = error ??
                                  l10n.settingsCredentialDisconnected;
                            });
                          },
                    child: Text(l10n.settingsCredentialDisconnect),
                  ),
                if (widget.busy)
                  const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
              ],
            ),
            if (widget.jiraPicker != null) ...[
              const SizedBox(height: 12),
              widget.jiraPicker!,
            ],
          ],
        ),
      ),
    );
  }
}

class _PhorgeTokenCard extends StatefulWidget {
  final String title;
  final UserProviderCredentialSummary? summary;
  final bool busy;
  final Future<String?> Function(Map<String, dynamic> settings) onConnect;
  final Future<String?> Function() onDisconnect;

  const _PhorgeTokenCard({
    required this.title,
    required this.summary,
    required this.busy,
    required this.onConnect,
    required this.onDisconnect,
  });

  @override
  State<_PhorgeTokenCard> createState() => _PhorgeTokenCardState();
}

class _PhorgeTokenCardState extends State<_PhorgeTokenCard> {
  final _token = TextEditingController();
  String? _message;
  bool _ok = false;

  @override
  void dispose() {
    _token.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final connected = widget.summary?.isConnected == true;
    final identity = widget.summary?.externalUsername ??
        widget.summary?.externalId;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(widget.title, style: AppTextStyles.titleSmall),
                ),
                if (connected)
                  Text(
                    identity == null
                        ? l10n.settingsCredentialConnected
                        : '@$identity',
                    style: AppTextStyles.labelSmall.copyWith(
                      color: AppColors.secondary,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              l10n.settingsPhorgeTokenHint,
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.secondary,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _token,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Conduit API token',
                isDense: true,
              ),
            ),
            const SizedBox(height: 8),
            if (_message != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text(
                  _message!,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: _ok
                        ? Colors.green
                        : Theme.of(context).colorScheme.error,
                  ),
                ),
              ),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                FilledButton(
                  onPressed: widget.busy
                      ? null
                      : () async {
                          final error = await widget.onConnect({
                            'api.token': _token.text.trim(),
                          });
                          if (!mounted) return;
                          setState(() {
                            _ok = error == null;
                            _message = error ?? l10n.settingsCredentialConnected;
                          });
                        },
                  child: Text(l10n.settingsCredentialConnect),
                ),
                if (connected)
                  TextButton(
                    onPressed: widget.busy
                        ? null
                        : () async {
                            final error = await widget.onDisconnect();
                            if (!mounted) return;
                            setState(() {
                              _ok = error == null;
                              _message = error ??
                                  l10n.settingsCredentialDisconnected;
                              if (error == null) _token.clear();
                            });
                          },
                    child: Text(l10n.settingsCredentialDisconnect),
                  ),
                if (widget.busy)
                  const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _JiraProjectsPicker extends StatelessWidget {
  final JiraProjectWatchList? watch;
  final List<String> draftKeys;
  final bool loading;
  final bool saving;
  final bool dirty;
  final void Function(String key) onToggle;
  final Future<String?> Function() onSave;

  const _JiraProjectsPicker({
    required this.watch,
    required this.draftKeys,
    required this.loading,
    required this.saving,
    required this.dirty,
    required this.onToggle,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    if (loading && watch == null) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 8),
        child: LinearProgressIndicator(),
      );
    }
    final projects = watch?.available ?? const [];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.settingsJiraProjectsTitle,
          style: AppTextStyles.labelSmall.copyWith(
            color: AppColors.secondary,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          l10n.settingsJiraProjectsSubtitle,
          style: AppTextStyles.bodySmall.copyWith(
            color: AppColors.secondary,
          ),
        ),
        const SizedBox(height: 8),
        if (projects.isEmpty)
          Text(
            l10n.settingsJiraProjectsEmpty,
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.secondary,
            ),
          )
        else
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final project in projects)
                FilterChip(
                  label: Text(
                    project.name == project.key
                        ? project.key
                        : '${project.key} · ${project.name}',
                  ),
                  selected: draftKeys.contains(project.key),
                  onSelected: saving ? null : (_) => onToggle(project.key),
                ),
            ],
          ),
        if (dirty) ...[
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerRight,
            child: FilledButton(
              onPressed: saving ? null : onSave,
              child: Text(l10n.settingsJiraProjectsSave),
            ),
          ),
        ],
      ],
    );
  }
}
