import 'package:dab_app/domain/entities/provider/provider_config.dart';
import 'package:dab_app/presentation/core/styles/app_colors.dart';
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
  late List<AdminConfigField> _fields;
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

    _fields = _getFieldsForProvider(config.id);
    for (final field in _fields) {
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

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: AppLayout.borderLarge,
        border: Border.all(color: AppColors.outline.withValues(alpha: 0.45)),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow.withValues(alpha: 0.25),
            blurRadius: AppLayout.glassBlur,
            offset: const Offset(0, 8),
          ),
        ],
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
                    color: AppColors.surfaceContainer.withValues(alpha: 0.9),
                    borderRadius: AppLayout.borderMedium,
                    border: Border.all(
                      color: AppColors.outline.withValues(alpha: 0.35),
                    ),
                  ),
                  child: Icon(
                    icon,
                    color: AppColors.onSurfaceVariant,
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
                          color: AppColors.onSurfaceHighlight,
                          fontWeight: FontWeight.w700,
                          letterSpacing: -0.25,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xxs),
                      Text(
                        config.id.toUpperCase(),
                        style: AppTextStyles.labelSmall.copyWith(
                          color: AppColors.onSurfaceVariantLow,
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
                        ? const SizedBox(
                            width: 14,
                            height: 14,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: AppColors.primary,
                            ),
                          )
                        : Icon(
                            AppIcons.testConnection,
                            size: AppLayout.iconSmall,
                          ),
                    label: Text(
                      'Try',
                      style: AppTextStyles.labelLarge.copyWith(
                        color: AppColors.primary,
                      ),
                    ),
                    style: TextButton.styleFrom(
                      foregroundColor: AppColors.primary,
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
                    _showDetails ? 'Hide fields' : 'Show fields',
                    style: AppTextStyles.labelMedium.copyWith(
                      color: AppColors.onSurfaceVariantLow,
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
                    activeThumbColor: AppColors.primary,
                    activeTrackColor: AppColors.primary.withValues(alpha: 0.35),
                    inactiveThumbColor: AppColors.onSurfaceVariantLow,
                    inactiveTrackColor: AppColors.surfaceContainerHigh
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
                          color: AppColors.outline.withValues(alpha: 0.4),
                        ),
                        SizedBox(height: AppSpacing.l),
                        ..._fields.map((field) {
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
                                    color: AppColors.onSurfaceVariantLow,
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
                                    color: AppColors.onSurfaceHighlight,
                                  ),
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: AppColors.surfaceContainer
                                        .withValues(alpha: 0.65),
                                    hintText: 'Enter ${field.label}...',
                                    helperText: isMultiValueField
                                        ? 'Use one value per line (comma-separated also works).'
                                        : null,
                                    hintStyle: AppTextStyles.bodyMedium
                                        .copyWith(
                                          color: AppColors.onSurfaceVariantLow
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
                                      borderSide: const BorderSide(
                                        color: AppColors.primary,
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
                              backgroundColor: AppColors.primary,
                              foregroundColor: AppColors.onPrimary,
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
                              'Save Provider Credentials',
                              style: AppTextStyles.labelLarge.copyWith(
                                color: AppColors.onPrimary,
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

  List<AdminConfigField> _getFieldsForProvider(String id) {
    final lowerId = id.toLowerCase();
    if (lowerId.contains('phorge')) {
      return [
        AdminConfigField(key: 'apiToken', label: 'API Token', isSecret: true),
        AdminConfigField(key: 'baseUrl', label: 'Base URL'),
      ];
    }
    if (lowerId.contains('linear')) {
      return [
        AdminConfigField(key: 'apiKey', label: 'API Key', isSecret: true),
      ];
    }
    if (lowerId.contains('jira')) {
      return [
        AdminConfigField(key: 'apiToken', label: 'API Token', isSecret: true),
        AdminConfigField(key: 'email', label: 'Atlassian Email'),
        AdminConfigField(
          key: 'instanceUrl',
          label: 'Jira Instance URL (e.g. company.atlassian.net)',
        ),
      ];
    }
    if (lowerId.contains('teams')) {
      return [
        AdminConfigField(key: 'clientId', label: 'Application (Client) ID'),
        AdminConfigField(
          key: 'clientSecret',
          label: 'Client Secret',
          isSecret: true,
        ),
        AdminConfigField(key: 'tenantId', label: 'Directory (Tenant) ID'),
      ];
    }
    if (lowerId.contains('slack')) {
      return [
        AdminConfigField(key: 'botToken', label: 'Bot Token', isSecret: true),
        AdminConfigField(
          key: 'signingSecret',
          label: 'Signing Secret',
          isSecret: true,
        ),
        AdminConfigField(
          key: 'workspaceId',
          label: 'Workspace/Team ID (e.g. T0123456789)',
        ),
        AdminConfigField(key: 'channels', label: 'Channel IDs (one per line)'),
        AdminConfigField(
          key: 'apiBaseUrl',
          label: 'API Base URL (optional, defaults to https://slack.com/api)',
        ),
      ];
    }
    if (lowerId.contains('discord')) {
      return [
        AdminConfigField(key: 'botToken', label: 'Bot Token', isSecret: true),
        AdminConfigField(key: 'guildId', label: 'Guild (Server) ID'),
      ];
    }
    if (lowerId.contains('github')) {
      return [
        AdminConfigField(
          key: 'api.token',
          label: 'Personal Access Token',
          isSecret: true,
        ),
        AdminConfigField(
          key: 'webhookSecret',
          label: 'Webhook Secret',
          isSecret: true,
        ),
        AdminConfigField(key: 'owner', label: 'Repository Owner'),
        AdminConfigField(key: 'repo', label: 'Repository Name'),
        AdminConfigField(
          key: 'branch',
          label: 'Branch (optional, defaults to repository default)',
        ),
        AdminConfigField(
          key: 'repos',
          label: 'Repositories (one owner/repo per line, optional)',
        ),
        AdminConfigField(
          key: 'apiBaseUrl',
          label: 'API Base URL (optional, defaults to https://api.github.com)',
        ),
      ];
    }
    if (lowerId.contains('gitlab')) {
      return [
        AdminConfigField(key: 'apiToken', label: 'API Token', isSecret: true),
        AdminConfigField(
          key: 'instanceUrl',
          label: 'GitLab Instance URL (e.g. gitlab.com)',
        ),
      ];
    }
    return [
      AdminConfigField(
        key: 'token',
        label: 'API Token / Secret',
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
