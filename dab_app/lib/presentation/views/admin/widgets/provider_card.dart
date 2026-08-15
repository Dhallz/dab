import 'package:dab_app/domain/entities/provider/provider_config.dart';
import 'package:dab_app/presentation/core/localization/app_localizations.dart';
import 'package:dab_app/presentation/core/localization/l10n_extension.dart';
import 'package:dab_app/presentation/core/styles/app_icons.dart';
import 'package:dab_app/presentation/core/styles/app_layout.dart';
import 'package:dab_app/presentation/core/styles/app_spacing.dart';
import 'package:dab_app/presentation/core/styles/app_text_styles.dart';
import 'package:dab_app/presentation/features/app/app_notifier.dart';
import 'package:dab_app/presentation/views/admin/admin_notifier.dart';
import 'package:dab_app/presentation/views/admin/models/admin_config_field.dart';
import 'package:dab_app/presentation/views/admin/models/admin_provider_field_manifest.dart';
import 'package:dab_app/presentation/views/admin/models/admin_webhook_url.dart';
import 'package:dab_app/presentation/views/admin/widgets/provider_config_section_panel.dart';
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
  late final TextEditingController _pollingRateController;

  @override
  void initState() {
    super.initState();
    _pollingRateController = TextEditingController(
      text:
          (widget.config.settings['pollingRateSeconds'] ??
                  widget.config.settings['polling_rate_seconds'] ??
                  '60')
              .toString(),
    );
    _syncControllersFromConfig(
      widget.config,
      replaceExisting: true,
      systemSettings: ref.read(adminNotifierProvider).systemSettings,
    );
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
      _pollingRateController.text =
          (widget.config.settings['pollingRateSeconds'] ??
                  widget.config.settings['polling_rate_seconds'] ??
                  '60')
              .toString();
      final systemSettings = ref.read(adminNotifierProvider).systemSettings;
      _syncControllersFromConfig(
        widget.config,
        replaceExisting: true,
        systemSettings: systemSettings,
      );
      if (oldWidget.config.id != widget.config.id) {
        _showDetails = false;
      }
    }
  }

  @override
  void dispose() {
    _pollingRateController.dispose();
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
    Map<String, String> systemSettings = const {},
  }) {
    if (replaceExisting) {
      _disposeControllers();
    }

    final manifest = ProviderFieldManifest.forProvider(
      config.id,
      lookupAppLocalizations(const Locale('en')),
    );
    final personalManifest = ProviderFieldManifest.forProvider(
      config.id,
      lookupAppLocalizations(const Locale('en')),
      personal: true,
    );
    final seen = <String>{};
    final fields = <AdminConfigField>[];
    for (final field in [
      ...manifest[ProviderConfigSection.core] ?? const [],
      ...manifest[ProviderConfigSection.live] ?? const [],
      ...manifest[ProviderConfigSection.polling] ?? const [],
      ...personalManifest[ProviderConfigSection.core] ?? const [],
      ...personalManifest[ProviderConfigSection.live] ?? const [],
      ...personalManifest[ProviderConfigSection.polling] ?? const [],
    ]) {
      if (!seen.add(field.key)) continue;
      fields.add(field);
    }
    for (final field in fields) {
      final rawValue = config.settings[field.key];
      final initialValue = _initialValueForField(
        config,
        field,
        rawValue,
        systemSettings: systemSettings,
      );
      _controllers[field.key] = TextEditingController(text: initialValue);
    }
  }

  String _initialValueForField(
    ProviderConfig config,
    AdminConfigField field,
    dynamic rawValue, {
    Map<String, String> systemSettings = const {},
  }) {
    if ((field.key == 'repos' ||
            field.key == 'channels' ||
            field.key == 'projectKeys' ||
            field.key == 'teamKeys') &&
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
    if (field.key == 'webhookUrl') {
      return _displayWebhookUrl(config, systemSettings);
    }

    return rawValue?.toString() ?? '';
  }

  String? _fieldHelperText({
    required AdminConfigField field,
    required AppLocalizations l10n,
    required String providerId,
    required Map<String, String> systemSettings,
    required bool isWebhookUrlField,
    required bool isMultiValueField,
  }) {
    final parts = <String>[
      if (field.hint != null && field.hint!.isNotEmpty) field.hint!,
      if (isWebhookUrlField)
        _defaultWebhookUrlHint(providerId, systemSettings, l10n),
      if (isMultiValueField) l10n.providerCardMultilineHint,
      if (field.key == 'clientId')
        _oauthCallbackHint(providerId, systemSettings, l10n),
    ];
    if (parts.isEmpty) return null;
    return parts.join('\n');
  }

  String _oauthCallbackHint(
    String providerId,
    Map<String, String> systemSettings,
    AppLocalizations l10n,
  ) {
    final base = normalizePublicApiBase(systemSettings['public_api_url']);
    if (base.isEmpty) {
      return l10n.adminOauthCallbackMustMatch(
        'Set Public API URL in Security first',
      );
    }
    return l10n.adminOauthCallbackMustMatch(
      '$base/integrations/$providerId/oauth/callback',
    );
  }

  String _defaultWebhookUrlHint(
    String providerId,
    Map<String, String> systemSettings,
    AppLocalizations l10n,
  ) {
    final defaultUrl = derivedWebhookUrl(
      providerId: providerId,
      systemSettings: systemSettings,
    );
    if (defaultUrl.isEmpty) {
      return l10n.adminFieldWebhookEndpointUrlHint(
        'Set Public API URL in Security settings',
      );
    }
    return l10n.adminFieldWebhookEndpointUrlHint(defaultUrl);
  }

  String _storedWebhookUrl(ProviderConfig config) {
    return (config.settings['webhookUrl'] ?? config.settings['webhook_url'])
            ?.toString()
            .trim() ??
        '';
  }

  String _displayWebhookUrl(
    ProviderConfig config,
    Map<String, String> systemSettings,
  ) {
    return displayWebhookUrl(
      stored: _storedWebhookUrl(config),
      publicApiDerived: derivedWebhookUrl(
        providerId: config.id,
        systemSettings: systemSettings,
      ),
      clientDerived: clientFallbackWebhookUrl(
        providerId: config.id,
        restClientBaseUrl: sl.restApiClient.baseUrl,
      ),
    );
  }

  void _ensureWebhookUrlDefaults(
    ProviderConfig config,
    Map<String, String> systemSettings,
  ) {
    final controller = _controllers['webhookUrl'];
    if (controller == null) return;

    final publicDerived = derivedWebhookUrl(
      providerId: config.id,
      systemSettings: systemSettings,
    );
    final clientDerived = clientFallbackWebhookUrl(
      providerId: config.id,
      restClientBaseUrl: sl.restApiClient.baseUrl,
    );
    final stored = _storedWebhookUrl(config);
    final current = controller.text.trim();
    final userIsEditingCustom =
        !isStaleOrDefaultWebhookUrl(
          url: current,
          publicApiDerived: publicDerived,
          clientDerived: clientDerived,
        ) &&
        current != stored;
    if (userIsEditingCustom) return;

    final next = displayWebhookUrl(
      stored: stored,
      publicApiDerived: publicDerived,
      clientDerived: clientDerived,
    );
    if (controller.text == next) return;
    controller.text = next;
  }

  List<Widget> _buildFieldWidgets({
    required BuildContext context,
    required List<AdminConfigField> fields,
    required AppLocalizations l10n,
    required ColorScheme cs,
    required String providerId,
    required Map<String, String> systemSettings,
  }) {
    return fields.map((field) {
      final isMultiValueField =
          field.key == 'repos' ||
          field.key == 'channels' ||
          field.key == 'projectKeys' ||
          field.key == 'teamKeys' ||
          field.key == 'projects';
      final isWebhookUrlField = field.key == 'webhookUrl';
      return Padding(
        padding: const EdgeInsets.only(bottom: AppSpacing.m),
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
              keyboardType: isMultiValueField || isWebhookUrlField
                  ? TextInputType.multiline
                  : TextInputType.text,
              minLines: isMultiValueField ? 3 : 1,
              maxLines: isMultiValueField ? 6 : (isWebhookUrlField ? 2 : 1),
              style: AppTextStyles.bodyMedium.copyWith(
                color: cs.onSurface,
                fontFamily: isWebhookUrlField ? 'monospace' : null,
                fontSize: isWebhookUrlField ? 12 : null,
              ),
              decoration: InputDecoration(
                filled: true,
                fillColor: cs.surfaceContainer.withValues(alpha: 0.65),
                hintText: l10n.providerCardEnterField(field.label),
                helperMaxLines: 6,
                helperText: _fieldHelperText(
                  field: field,
                  l10n: l10n,
                  providerId: providerId,
                  systemSettings: systemSettings,
                  isWebhookUrlField: isWebhookUrlField,
                  isMultiValueField: isMultiValueField,
                ),
                hintStyle: AppTextStyles.bodyMedium.copyWith(
                  color: cs.onSurfaceVariant.withValues(alpha: 0.35),
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
                  borderSide: BorderSide(color: cs.primary, width: 1.5),
                ),
              ),
            ),
          ],
        ),
      );
    }).toList();
  }

  void _saveProvider({
    required AdminNotifier notifier,
    required ProviderConfig config,
    required Map<String, String> systemSettings,
  }) {
    final newSettings = _buildSettings(config, systemSettings);
    final newBaseUrl = _resolveBaseUrl(config);
    final updatedConfig = config.copyWith(
      settings: newSettings,
      baseUrl: newBaseUrl.trim(),
    );

    notifier.saveProviderConfig(updatedConfig);
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
    final isPersonal = ref.watch(
      appNotifierProvider.select((s) => s.isPersonalDeployment),
    );
    final manifest = ProviderFieldManifest.forProvider(
      config.id,
      l10n,
      personal: isPersonal,
    );
    final systemSettings = ref.watch(
      adminNotifierProvider.select((s) => s.systemSettings),
    );
    if (isExpanded) {
      _ensureWebhookUrlDefaults(config, systemSettings);
    }
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
                LivePulsingIcon(status: config.isActive ? status : null),
                if (isExpanded && !isPersonal) ...[
                  SizedBox(width: AppSpacing.xs),
                  TextButton.icon(
                    onPressed: status?.status.isLoading == true
                        ? null
                        : () {
                            final currentSettings = _buildSettings(
                              config,
                              systemSettings,
                            );
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
                    inactiveTrackColor: cs.surfaceContainerHigh.withValues(
                      alpha: 0.5,
                    ),
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
                        ProviderConfigSectionPanel(
                          title: 'CORE',
                          sectionStatus: isPersonal ? null : status?.core,
                          children: _buildFieldWidgets(
                            context: context,
                            fields:
                                manifest[ProviderConfigSection.core] ??
                                const [],
                            l10n: l10n,
                            cs: cs,
                            providerId: config.id,
                            systemSettings: systemSettings,
                          ),
                        ),
                        if (!isPersonal ||
                            (manifest[ProviderConfigSection.live] ?? const [])
                                .isNotEmpty)
                          ProviderConfigSectionPanel(
                            title: 'LIVE',
                            sectionStatus: isPersonal ? null : status?.live,
                            children: [
                              if (!isPersonal &&
                                  config.id.toLowerCase() == 'discord')
                                Text(
                                  'Live ingestion uses the Discord Gateway WebSocket (no inbound webhook).',
                                  style: AppTextStyles.labelSmall.copyWith(
                                    color: cs.onSurfaceVariant,
                                  ),
                                ),
                              ..._buildFieldWidgets(
                                context: context,
                                fields:
                                    manifest[ProviderConfigSection.live] ??
                                    const [],
                                l10n: l10n,
                                cs: cs,
                                providerId: config.id,
                                systemSettings: systemSettings,
                              ),
                            ],
                          ),
                        if (!isPersonal ||
                            (manifest[ProviderConfigSection.polling] ??
                                    const [])
                                .isNotEmpty)
                          ProviderConfigSectionPanel(
                            title: 'POLLING',
                            sectionStatus: isPersonal ? null : status?.polling,
                            children: [
                              if (!isPersonal)
                                providerPollingRateField(
                                  context: context,
                                  controller: _pollingRateController,
                                ),
                              ..._buildFieldWidgets(
                                context: context,
                                fields:
                                    manifest[ProviderConfigSection.polling] ??
                                    const [],
                                l10n: l10n,
                                cs: cs,
                                providerId: config.id,
                                systemSettings: systemSettings,
                              ),
                            ],
                          ),
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
                              _saveProvider(
                                notifier: notifier,
                                config: config,
                                systemSettings: systemSettings,
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

  Map<String, dynamic> _buildSettings(
    ProviderConfig config,
    Map<String, String> systemSettings,
  ) {
    final Map<String, dynamic> settings = Map.from(config.settings);
    settings['pollingRateSeconds'] =
        int.tryParse(_pollingRateController.text) ?? 60;

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
      } else if (key == 'teamKeys' && value.isEmpty) {
        settings.remove('teamKeys');
      } else if (key == 'webhookSecret' && value.isEmpty) {
        settings.remove('webhookSecret');
        settings.remove('webhook_secret');
      } else if (key == 'webhookHmacKey' && value.isEmpty) {
        settings.remove('webhookHmacKey');
        settings.remove('webhook_hmac_key');
      } else if (key == 'webhookUrl') {
        final publicDerived = derivedWebhookUrl(
          providerId: config.id,
          systemSettings: systemSettings,
        );
        final clientDerived = clientFallbackWebhookUrl(
          providerId: config.id,
          restClientBaseUrl: sl.restApiClient.baseUrl,
        );
        if (!shouldPersistWebhookUrl(
          value: value,
          publicApiDerived: publicDerived,
          clientDerived: clientDerived,
        )) {
          settings.remove('webhookUrl');
          settings.remove('webhook_url');
        } else {
          settings['webhookUrl'] = value;
        }
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
