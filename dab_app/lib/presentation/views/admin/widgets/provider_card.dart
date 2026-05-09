import 'package:dab_app/domain/entities/provider/provider_config.dart';
import 'package:dab_app/presentation/core/localization/app_localizations.dart';
import 'package:dab_app/presentation/core/localization/l10n_extension.dart';
import 'package:dab_app/presentation/core/styles/app_icons.dart';
import 'package:dab_app/presentation/core/styles/app_layout.dart';
import 'package:dab_app/presentation/core/styles/app_spacing.dart';
import 'package:dab_app/presentation/core/styles/app_text_styles.dart';
import 'package:dab_app/presentation/views/admin/admin_notifier.dart';
import 'package:dab_app/presentation/views/admin/models/admin_config_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'live_pulsing_icon.dart';

ProviderConfig _pickProviderConfig(
  List<ProviderConfig> configs,
  String id,
  ProviderConfig fallback,
) {
  for (final c in configs) {
    if (c.id == id) return c;
  }
  return fallback;
}

class ProviderCard extends ConsumerStatefulWidget {
  final ProviderConfig config;

  const ProviderCard({super.key, required this.config});

  @override
  ConsumerState<ProviderCard> createState() => _ProviderCardState();
}

class _ProviderCardState extends ConsumerState<ProviderCard> {
  final Map<String, TextEditingController> _controllers = {};
  bool _showDetails = false;

  @override
  void initState() {
    super.initState();
    _syncControllersFromConfig(widget.config, replaceExisting: true);
    _showDetails = false;
  }

  @override
  void didUpdateWidget(ProviderCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    final configChanged =
        oldWidget.config.id != widget.config.id ||
        oldWidget.config.settings != widget.config.settings ||
        oldWidget.config.baseUrl != widget.config.baseUrl;
    if (configChanged) {
      _syncControllersFromConfig(widget.config, replaceExisting: true);
      if (oldWidget.config.id != widget.config.id) {
        _showDetails = false;
      }
    }
  }

  @override
  void dispose() {
    _disposeControllers();
    super.dispose();
  }

  void _disposeControllers() {
    for (final controller in _controllers.values) {
      controller.dispose();
    }
    _controllers.clear();
  }

  void _syncControllersFromConfig(
    ProviderConfig config, {
    required bool replaceExisting,
  }) {
    if (replaceExisting) {
      _disposeControllers();
    }

    final fields = _getFieldsForProvider(
      config.id,
      lookupAppLocalizations(const Locale('en')),
    );
    for (final field in fields) {
      final rawValue = config.settings[field.key];
      final initialValue = _initialValueForField(config, field, rawValue);
      _controllers[field.key] = TextEditingController(text: initialValue);
    }
  }

  String _initialValueForField(
    ProviderConfig config,
    AdminConfigField field,
    dynamic rawValue,
  ) {
    if ((field.key == 'repos' || field.key == 'channels') && rawValue is List) {
      return rawValue.map((e) => e.toString()).join('\n');
    }

    if (field.key == 'botToken') {
      final fallback = config.settings['api.token'] ?? config.settings['token'];
      return (rawValue ?? fallback)?.toString() ?? '';
    }
    if (field.key == 'signingSecret') {
      final fallback =
          config.settings['signing_secret'] ??
          config.settings['slackSigningSecret'];
      return (rawValue ?? fallback)?.toString() ?? '';
    }
    if (field.key == 'webhookSecret') {
      final fallback = config.settings['webhook_secret'];
      return (rawValue ?? fallback)?.toString() ?? '';
    }

    return rawValue?.toString() ?? '';
  }

  @override
  Widget build(BuildContext context) {
    final icon = _getProviderIcon(widget.config.id);

    final slice = ref.watch(
      adminNotifierProvider.select(
        (s) => (
          config: _pickProviderConfig(
            s.configs,
            widget.config.id,
            widget.config,
          ),
          connection: s.connectionStatuses[widget.config.id],
        ),
      ),
    );
    final notifier = ref.read(adminNotifierProvider.notifier);

    final status = slice.connection;
    final config = slice.config;
    final isExpanded = _showDetails;
    final cs = Theme.of(context).colorScheme;
    final l10n = context.l10n;
    final fields = _getFieldsForProvider(config.id, l10n);
    final isLight = Theme.of(context).brightness == Brightness.light;
    // Elevation shadow only: do not use [AppLayout.glassBlur] here — that sigma is
    // for backdrop blur; large blur + shadow color reads as muddy stripes between list cards.
    final cardShadows = <BoxShadow>[
      BoxShadow(
        color: cs.shadow.withValues(alpha: isLight ? 0.06 : 0.16),
        blurRadius: isLight ? 10 : 14,
        offset: Offset(0, isLight ? 2 : 4),
      ),
    ];

    return Container(
      decoration: BoxDecoration(
        color: cs.surfaceContainerLow,
        borderRadius: AppLayout.borderLarge,
        border: Border.all(color: cs.outline.withValues(alpha: 0.45)),
        boxShadow: cardShadows,
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(AppSpacing.l),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(AppSpacing.s),
                  decoration: BoxDecoration(
                    color: cs.surfaceContainer.withValues(alpha: 0.9),
                    borderRadius: AppLayout.borderMedium,
                    border: Border.all(
                      color: cs.outline.withValues(alpha: 0.35),
                    ),
                  ),
                  child: Icon(
                    icon,
                    color: cs.onSurfaceVariant,
                    size: AppLayout.iconMedium,
                  ),
                ),
                SizedBox(width: AppSpacing.m),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        config.name,
                        style: AppTextStyles.titleMedium.copyWith(
                          color: cs.onSurface,
                          fontWeight: FontWeight.w700,
                          letterSpacing: -0.25,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xxs),
                      Text(
                        config.id.toUpperCase(),
                        style: AppTextStyles.labelSmall.copyWith(
                          color: cs.onSurfaceVariant,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ],
                  ),
                ),
                LivePulsingIcon(status: status),
                if (isExpanded) ...[
                  SizedBox(width: AppSpacing.xs),
                  TextButton.icon(
                    onPressed: status?.status.isLoading == true
                        ? null
                        : () {
                            final currentSettings = _buildSettings(config);
                            final newBaseUrl = _resolveBaseUrl(config);

                            final configToTest = config.copyWith(
                              settings: currentSettings,
                              baseUrl: newBaseUrl.trim(),
                            );
                            notifier.testConnection(configToTest);
                          },
                    icon: status?.status.isLoading == true
                        ? SizedBox(
                            width: 14,
                            height: 14,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: cs.primary,
                            ),
                          )
                        : Icon(
                            AppIcons.testConnection,
                            size: AppLayout.iconSmall,
                          ),
                    label: Text(
                      l10n.commonTry,
                      style: AppTextStyles.labelLarge.copyWith(
                        color: cs.primary,
                      ),
                    ),
                    style: TextButton.styleFrom(
                      foregroundColor: cs.primary,
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.m,
                      ),
                    ),
                  ),
                ],
                TextButton.icon(
                  onPressed: () => setState(() => _showDetails = !_showDetails),
                  icon: Icon(
                    _showDetails
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    size: AppLayout.iconSmall,
                  ),
                  label: Text(
                    _showDetails
                        ? l10n.providerCardHideFields
                        : l10n.providerCardShowFields,
                    style: AppTextStyles.labelMedium.copyWith(
                      color: cs.onSurfaceVariant,
                    ),
                  ),
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.s,
                    ),
                  ),
                ),
                Transform.scale(
                  scale: 0.85,
                  child: Switch(
                    value: config.isActive,
                    onChanged: (val) => notifier.toggleProvider(config.id, val),
                    activeThumbColor: cs.primary,
                    activeTrackColor: cs.primary.withValues(alpha: 0.35),
                    inactiveThumbColor: cs.onSurfaceVariant,
                    inactiveTrackColor: cs.surfaceContainerHigh
                        .withValues(alpha: 0.5),
                  ),
                ),
              ],
            ),
          ),

          AnimatedSize(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOutQuart,
            alignment: Alignment.topCenter,
            child: !isExpanded
                ? const SizedBox(width: double.infinity)
                : Padding(
                    padding: const EdgeInsets.fromLTRB(
                      AppSpacing.l,
                      0,
                      AppSpacing.l,
                      AppSpacing.l,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Divider(
                          height: 1,
                          thickness: 1,
                          color: cs.outline.withValues(alpha: 0.4),
                        ),
                        SizedBox(height: AppSpacing.l),
                        ...fields.map((field) {
                          final isMultiValueField =
                              field.key == 'repos' || field.key == 'channels';
                          return Padding(
                            padding: const EdgeInsets.only(
                              bottom: AppSpacing.m,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  field.label.toUpperCase(),
                                  style: AppTextStyles.labelSmall.copyWith(
                                    color: cs.onSurfaceVariant,
                                    letterSpacing: 1.1,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                SizedBox(height: AppSpacing.xs),
                                TextField(
                                  controller: _controllers[field.key],
                                  obscureText: field.isSecret,
                                  keyboardType: isMultiValueField
                                      ? TextInputType.multiline
                                      : TextInputType.text,
                                  minLines: isMultiValueField ? 3 : 1,
                                  maxLines: isMultiValueField ? 6 : 1,
                                  style: AppTextStyles.bodyMedium.copyWith(
                                    color: cs.onSurface,
                                  ),
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: cs.surfaceContainer
                                        .withValues(alpha: 0.65),
                                    hintText: l10n.providerCardEnterField(
                                      field.label,
                                    ),
                                    helperText: isMultiValueField
                                        ? l10n.providerCardMultilineHint
                                        : null,
                                    hintStyle: AppTextStyles.bodyMedium
                                        .copyWith(
                                          color: cs.onSurfaceVariant
                                              .withValues(alpha: 0.35),
                                        ),
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: AppSpacing.m,
                                      vertical: AppSpacing.m,
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: AppLayout.borderMedium,
                                      borderSide: BorderSide.none,
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: AppLayout.borderMedium,
                                      borderSide: BorderSide(
                                        color: cs.primary,
                                        width: 1.5,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),
                        SizedBox(height: AppSpacing.xs),
                        SizedBox(
                          width: double.infinity,
                          child: FilledButton(
                            style: FilledButton.styleFrom(
                              backgroundColor: cs.primary,
                              foregroundColor: cs.onPrimary,
                              padding: const EdgeInsets.symmetric(
                                vertical: AppSpacing.m,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: AppLayout.borderMedium,
                              ),
                              elevation: 0,
                            ),
                            onPressed: () {
                              final newSettings = _buildSettings(config);
                              final newBaseUrl = _resolveBaseUrl(config);

                              final updatedConfig = config.copyWith(
                                settings: newSettings,
                                baseUrl: newBaseUrl.trim(),
                              );
                              notifier.saveProviderConfig(updatedConfig);
                            },
                            child: Text(
                              l10n.providerCardSaveCredentials,
                              style: AppTextStyles.labelLarge.copyWith(
                                color: cs.onPrimary,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  IconData _getProviderIcon(String id) {
    final lowerId = id.toLowerCase();
    if (lowerId.contains('phorge')) return AppIcons.phorge;
    if (lowerId.contains('linear')) return AppIcons.linear;
    if (lowerId.contains('jira')) return AppIcons.jira;
    if (lowerId.contains('teams')) return AppIcons.teams;
    if (lowerId.contains('slack')) return AppIcons.slack;
    if (lowerId.contains('discord')) return AppIcons.discord;
    if (lowerId.contains('github')) return AppIcons.github;
    if (lowerId.contains('gitlab')) return AppIcons.gitlab;
    return AppIcons.unknownProvider;
  }

  List<AdminConfigField> _getFieldsForProvider(String id, AppLocalizations l10n) {
    final lowerId = id.toLowerCase();
    if (lowerId.contains('phorge')) {
      return [
        AdminConfigField(
          key: 'apiToken',
          label: l10n.adminFieldApiToken,
          isSecret: true,
        ),
        AdminConfigField(key: 'baseUrl', label: l10n.adminFieldBaseUrl),
      ];
    }
    if (lowerId.contains('linear')) {
      return [
        AdminConfigField(
          key: 'apiKey',
          label: l10n.adminFieldApiKey,
          isSecret: true,
        ),
      ];
    }
    if (lowerId.contains('jira')) {
      return [
        AdminConfigField(
          key: 'apiToken',
          label: l10n.adminFieldApiToken,
          isSecret: true,
        ),
        AdminConfigField(key: 'email', label: l10n.adminFieldAtlassianEmail),
        AdminConfigField(
          key: 'instanceUrl',
          label: l10n.adminFieldJiraInstanceUrl,
        ),
      ];
    }
    if (lowerId.contains('teams')) {
      return [
        AdminConfigField(
          key: 'clientId',
          label: l10n.adminFieldApplicationClientId,
        ),
        AdminConfigField(
          key: 'clientSecret',
          label: l10n.adminFieldClientSecret,
          isSecret: true,
        ),
        AdminConfigField(
          key: 'tenantId',
          label: l10n.adminFieldDirectoryTenantId,
        ),
      ];
    }
    if (lowerId.contains('slack')) {
      return [
        AdminConfigField(
          key: 'botToken',
          label: l10n.adminFieldBotToken,
          isSecret: true,
        ),
        AdminConfigField(
          key: 'signingSecret',
          label: l10n.adminFieldSigningSecret,
          isSecret: true,
        ),
        AdminConfigField(
          key: 'workspaceId',
          label: l10n.adminFieldWorkspaceTeamId,
        ),
        AdminConfigField(
          key: 'channels',
          label: l10n.adminFieldChannelIdsOnePerLine,
        ),
        AdminConfigField(
          key: 'apiBaseUrl',
          label: l10n.adminFieldSlackApiBaseOptional,
        ),
      ];
    }
    if (lowerId.contains('discord')) {
      return [
        AdminConfigField(
          key: 'botToken',
          label: l10n.adminFieldBotToken,
          isSecret: true,
        ),
        AdminConfigField(
          key: 'guildId',
          label: l10n.adminFieldGuildServerId,
        ),
      ];
    }
    if (lowerId.contains('github')) {
      return [
        AdminConfigField(
          key: 'api.token',
          label: l10n.adminFieldPersonalAccessToken,
          isSecret: true,
        ),
        AdminConfigField(
          key: 'webhookSecret',
          label: l10n.adminFieldWebhookSecret,
          isSecret: true,
        ),
        AdminConfigField(key: 'owner', label: l10n.adminFieldRepositoryOwner),
        AdminConfigField(key: 'repo', label: l10n.adminFieldRepositoryName),
        AdminConfigField(
          key: 'branch',
          label: l10n.adminFieldBranchOptional,
        ),
        AdminConfigField(
          key: 'repos',
          label: l10n.adminFieldRepositoriesOnePerLine,
        ),
        AdminConfigField(
          key: 'apiBaseUrl',
          label: l10n.adminFieldGithubApiBaseOptional,
        ),
      ];
    }
    if (lowerId.contains('gitlab')) {
      return [
        AdminConfigField(
          key: 'apiToken',
          label: l10n.adminFieldApiToken,
          isSecret: true,
        ),
        AdminConfigField(
          key: 'instanceUrl',
          label: l10n.adminFieldGitLabInstanceUrl,
        ),
      ];
    }
    return [
      AdminConfigField(
        key: 'token',
        label: l10n.adminFieldApiTokenOrSecret,
        isSecret: true,
      ),
    ];
  }

  Map<String, dynamic> _buildSettings(ProviderConfig config) {
    final Map<String, dynamic> settings = Map.from(config.settings);
    _controllers.forEach((key, controller) {
      final value = controller.text.trim();
      if (key == 'repos' || key == 'channels') {
        if (value.isEmpty) {
          settings.remove(key);
        } else {
          settings[key] = value
              .split(RegExp(r'[\n,]+'))
              .map((e) => e.trim())
              .where((e) => e.isNotEmpty)
              .toList();
        }
      } else if (key == 'apiBaseUrl' && value.isEmpty) {
        settings.remove('apiBaseUrl');
      } else if (key == 'webhookSecret' && value.isEmpty) {
        settings.remove('webhookSecret');
        settings.remove('webhook_secret');
      } else {
        settings[key] = value;
      }
    });
    return settings;
  }

  String _resolveBaseUrl(ProviderConfig config) {
    return (_controllers['baseUrl']?.text ??
            _controllers['instanceUrl']?.text ??
            config.baseUrl)
        .trim();
  }
}
