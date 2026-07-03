import 'package:dab_app/domain/entities/provider/provider_config.dart';
import 'package:dab_app/presentation/core/localization/app_localizations.dart';
import 'package:dab_app/presentation/core/localization/l10n_extension.dart';
import 'package:dab_app/presentation/core/styles/app_icons.dart';
import 'package:dab_app/presentation/core/styles/app_layout.dart';
import 'package:dab_app/presentation/core/styles/app_spacing.dart';
import 'package:dab_app/presentation/core/styles/app_text_styles.dart';
import 'package:dab_app/presentation/views/admin/admin_notifier.dart';
import 'package:dab_app/presentation/views/admin/models/admin_config_field.dart';
import 'package:dab_app/services/service_locator.dart';
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
  String _ingestionMode = 'webhook';
  late final TextEditingController _pollingRateController;
  late final TextEditingController _webhookUrlController;
  late final FocusNode _webhookUrlFocusNode;

  @override
  void initState() {
    super.initState();
    _ingestionMode = widget.config.settings['ingestionMode'] ?? widget.config.settings['ingestion_mode'] ?? 'webhook';
    _pollingRateController = TextEditingController(
      text: (widget.config.settings['pollingRateSeconds'] ?? widget.config.settings['polling_rate_seconds'] ?? '60').toString(),
    );
    _webhookUrlController = TextEditingController();
    _webhookUrlFocusNode = FocusNode();
    _syncControllersFromConfig(widget.config, replaceExisting: true);
    _showDetails = false;
    WidgetsBinding.instance.addPostFrameCallback((_) => _syncWebhookUrlController());
  }

  @override
  void didUpdateWidget(ProviderCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    final configChanged =
        oldWidget.config.id != widget.config.id ||
        oldWidget.config.settings != widget.config.settings ||
        oldWidget.config.baseUrl != widget.config.baseUrl;
    if (configChanged) {
      _ingestionMode = widget.config.settings['ingestionMode'] ?? widget.config.settings['ingestion_mode'] ?? 'webhook';
      _pollingRateController.text = (widget.config.settings['pollingRateSeconds'] ?? widget.config.settings['polling_rate_seconds'] ?? '60').toString();
      _syncControllersFromConfig(widget.config, replaceExisting: true);
      if (oldWidget.config.id != widget.config.id) {
        _showDetails = false;
      }
    }
    _syncWebhookUrlController();
  }

  @override
  void dispose() {
    _pollingRateController.dispose();
    _webhookUrlController.dispose();
    _webhookUrlFocusNode.dispose();
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
    if ((field.key == 'repos' ||
            field.key == 'channels' ||
            field.key == 'projectKeys') &&
        rawValue is List) {
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

  String _webhookPathForProvider(String providerId) {
    if (providerId == 'slack') {
      return '/integrations/slack/events';
    }
    return '/integrations/$providerId/webhook';
  }

  String _resolvePublicApiBase(Map<String, String> systemSettings) {
    final configured = systemSettings['public_api_url']?.trim();
    if (configured != null && configured.isNotEmpty) {
      return configured.replaceAll(RegExp(r'/+$'), '');
    }
    return sl.restApiClient.baseUrl.replaceAll(RegExp(r'/+$'), '');
  }

  String _buildWebhookUrl(String providerId, Map<String, String> systemSettings) {
    return '${_resolvePublicApiBase(systemSettings)}${_webhookPathForProvider(providerId)}';
  }

  String _publicApiBaseFromWebhookUrl(String webhookUrl, String providerId) {
    final trimmed = webhookUrl.trim();
    if (trimmed.isEmpty) {
      return '';
    }
    final path = _webhookPathForProvider(providerId);
    if (trimmed.endsWith(path)) {
      return trimmed
          .substring(0, trimmed.length - path.length)
          .replaceAll(RegExp(r'/+$'), '');
    }
    return trimmed.replaceAll(RegExp(r'/+$'), '');
  }

  void _syncWebhookUrlController() {
    if (_webhookUrlFocusNode.hasFocus) {
      return;
    }
    final systemSettings = ref.read(adminNotifierProvider).systemSettings;
    final nextUrl = _buildWebhookUrl(widget.config.id, systemSettings);
    if (_webhookUrlController.text != nextUrl) {
      _webhookUrlController.text = nextUrl;
    }
  }

  void _saveProviderAndWebhookBase({
    required AdminNotifier notifier,
    required ProviderConfig config,
  }) {
    final newSettings = _buildSettings(config);
    final newBaseUrl = _resolveBaseUrl(config);
    final updatedConfig = config.copyWith(
      settings: newSettings,
      baseUrl: newBaseUrl.trim(),
    );

    final priorSettings = ref.read(adminNotifierProvider).systemSettings;
    final publicApiBase = _publicApiBaseFromWebhookUrl(
      _webhookUrlController.text,
      config.id,
    );
    final systemSettings = Map<String, String>.from(priorSettings);
    if (publicApiBase.isEmpty) {
      systemSettings.remove('public_api_url');
    } else {
      systemSettings['public_api_url'] = publicApiBase;
    }

    notifier.saveProviderConfig(updatedConfig);
    if ((priorSettings['public_api_url'] ?? '') !=
        (systemSettings['public_api_url'] ?? '')) {
      notifier.saveSystemSettings(systemSettings);
    }
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
                        
                        // Ingestion Mode Configuration
                        Text(
                          'INGESTION MODE',
                          style: AppTextStyles.labelSmall.copyWith(
                            color: cs.onSurfaceVariant,
                            letterSpacing: 1.1,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          decoration: BoxDecoration(
                            color: cs.onSurface.withValues(alpha: 0.05),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: cs.outline.withValues(alpha: 0.1)),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: InkWell(
                                  onTap: () {
                                    setState(() {
                                      _ingestionMode = 'webhook';
                                    });
                                  },
                                  borderRadius: const BorderRadius.horizontal(left: Radius.circular(11)),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(vertical: 10),
                                    decoration: BoxDecoration(
                                      color: _ingestionMode == 'webhook'
                                          ? cs.primary
                                          : Colors.transparent,
                                      borderRadius: const BorderRadius.horizontal(left: Radius.circular(11)),
                                    ),
                                    child: Center(
                                      child: Text(
                                        'Webhook',
                                        style: TextStyle(
                                          color: _ingestionMode == 'webhook' ? Colors.white : cs.onSurfaceVariant,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 13,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: InkWell(
                                  onTap: () {
                                    setState(() {
                                      _ingestionMode = 'polling';
                                    });
                                  },
                                  borderRadius: const BorderRadius.horizontal(right: Radius.circular(11)),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(vertical: 10),
                                    decoration: BoxDecoration(
                                      color: _ingestionMode == 'polling'
                                          ? cs.primary
                                          : Colors.transparent,
                                      borderRadius: const BorderRadius.horizontal(right: Radius.circular(11)),
                                    ),
                                    child: Center(
                                      child: Text(
                                        'Polling',
                                        style: TextStyle(
                                          color: _ingestionMode == 'polling' ? Colors.white : cs.onSurfaceVariant,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 13,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        
                        if (_ingestionMode == 'polling') ...[
                          Text(
                            'POLLING RATE (SECONDS)',
                            style: AppTextStyles.labelSmall.copyWith(
                              color: cs.onSurfaceVariant,
                              letterSpacing: 1.1,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 8),
                          TextField(
                            controller: _pollingRateController,
                            keyboardType: TextInputType.number,
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: cs.onSurface,
                            ),
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: cs.surfaceContainer.withValues(alpha: 0.65),
                              hintText: 'e.g. 60',
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
                          const SizedBox(height: 16),
                        ],
                        
                        if (_ingestionMode == 'webhook') ...[
                          Text(
                            'WEBHOOK ENDPOINT URL',
                            style: AppTextStyles.labelSmall.copyWith(
                              color: cs.onSurfaceVariant,
                              letterSpacing: 1.1,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 8),
                          TextField(
                            controller: _webhookUrlController,
                            focusNode: _webhookUrlFocusNode,
                            keyboardType: TextInputType.url,
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: cs.onSurface,
                              fontFamily: 'monospace',
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: cs.onSurface.withValues(alpha: 0.05),
                              hintText:
                                  'https://your-domain.com${_webhookPathForProvider(config.id)}',
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: AppSpacing.m,
                                vertical: AppSpacing.m,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: AppLayout.borderMedium,
                                borderSide: BorderSide(
                                  color: cs.outline.withValues(alpha: 0.1),
                                ),
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
                          const SizedBox(height: 16),
                        ],
                        
                        ...fields.map((field) {
                          final isMultiValueField =
                              field.key == 'repos' ||
                              field.key == 'channels' ||
                              field.key == 'projectKeys';
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
                              _saveProviderAndWebhookBase(
                                notifier: notifier,
                                config: config,
                              );
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
    if (lowerId.contains('slack')) return AppIcons.slack;
    if (lowerId.contains('discord')) return AppIcons.discord;
    if (lowerId.contains('github')) return AppIcons.github;
    if (lowerId.contains('gitlab')) return AppIcons.gitlab;
    if (lowerId.contains('bitbucket')) return AppIcons.bitbucket;
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
        AdminConfigField(
          key: 'webhookHmacKey',
          label: 'Herald webhook HMAC key',
          isSecret: true,
        ),
      ];
    }
    if (lowerId.contains('linear')) {
      return [
        AdminConfigField(
          key: 'apiKey',
          label: l10n.adminFieldApiKey,
          isSecret: true,
        ),
        AdminConfigField(
          key: 'webhookSecret',
          label: l10n.adminFieldWebhookSecret,
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
        AdminConfigField(
          key: 'projectKeys',
          label: 'Project Keys (comma or newline separated)',
        ),
        AdminConfigField(
          key: 'webhookSecret',
          label: l10n.adminFieldWebhookSecret,
          isSecret: true,
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
        AdminConfigField(
          key: 'channels',
          label: l10n.adminFieldChannelIdsOnePerLine,
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
        AdminConfigField(
          key: 'projects',
          label: 'Projects (group/project, one per line)',
        ),
        AdminConfigField(
          key: 'branch',
          label: l10n.adminFieldBranchOptional,
        ),
        AdminConfigField(
          key: 'webhookSecret',
          label: l10n.adminFieldWebhookSecret,
          isSecret: true,
        ),
      ];
    }
    if (lowerId.contains('bitbucket')) {
      return [
        AdminConfigField(key: 'username', label: 'Username'),
        AdminConfigField(
          key: 'apiToken',
          label: 'App password / API token',
          isSecret: true,
        ),
        AdminConfigField(key: 'workspace', label: 'Workspace'),
        AdminConfigField(
          key: 'repos',
          label: l10n.adminFieldRepositoriesOnePerLine,
        ),
        AdminConfigField(
          key: 'webhookSecret',
          label: l10n.adminFieldWebhookSecret,
          isSecret: true,
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
    settings['ingestionMode'] = _ingestionMode;
    settings['pollingRateSeconds'] = int.tryParse(_pollingRateController.text) ?? 60;
    
    _controllers.forEach((key, controller) {
      final value = controller.text.trim();
      if (key == 'repos' || key == 'channels' || key == 'projects') {
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
      } else if (key == 'projectKeys' && value.isEmpty) {
        settings.remove('projectKeys');
      } else if (key == 'webhookSecret' && value.isEmpty) {
        settings.remove('webhookSecret');
        settings.remove('webhook_secret');
      } else if (key == 'webhookHmacKey' && value.isEmpty) {
        settings.remove('webhookHmacKey');
        settings.remove('webhook_hmac_key');
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
