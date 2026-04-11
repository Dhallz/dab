import 'package:dab_app/domain/entities/provider/provider_config.dart';
import 'package:dab_app/presentation/core/app_bloc_consumer.dart';
import 'package:dab_app/presentation/core/styles/app_colors.dart';
import 'package:dab_app/presentation/core/styles/app_icons.dart';
import 'package:dab_app/presentation/core/styles/app_layout.dart';
import 'package:dab_app/presentation/core/styles/app_spacing.dart';
import 'package:dab_app/presentation/core/styles/app_text_styles.dart';
import 'package:dab_app/presentation/views/admin/admin_bloc.dart';
import 'package:dab_app/presentation/views/admin/admin_event.dart';
import 'package:dab_app/presentation/views/admin/admin_state.dart';
import 'package:dab_app/presentation/views/admin/models/admin_config_field.dart';
import 'package:flutter/material.dart';

import 'live_pulsing_icon.dart';

class ProviderCard extends StatefulWidget {
  final ProviderConfig config;
  final AdminBloc bloc;

  const ProviderCard({super.key, required this.config, required this.bloc});

  @override
  State<ProviderCard> createState() => _ProviderCardState();
}

class _ProviderCardState extends State<ProviderCard> {
  final Map<String, TextEditingController> _controllers = {};
  late List<AdminConfigField> _fields;

  @override
  void initState() {
    super.initState();
    _fields = _getFieldsForProvider(widget.config.id);
    for (final field in _fields) {
      _controllers[field.key] = TextEditingController(
        text: widget.config.settings[field.key]?.toString() ?? '',
      );
    }
  }

  @override
  void didUpdateWidget(ProviderCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.config.id != widget.config.id) {
      _fields = _getFieldsForProvider(widget.config.id);
      _controllers.clear();
      for (final field in _fields) {
        _controllers[field.key] = TextEditingController(
          text: widget.config.settings[field.key]?.toString() ?? '',
        );
      }
    }
  }

  @override
  void dispose() {
    for (final controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final icon = _getProviderIcon(widget.config.id);

    return AppBlocConsumer<AdminBloc, AdminState>(
      listenWhen: (previous, current) => false,
      listener: (context, state, bloc) {},
      buildWhen: (prev, next) {
        final id = widget.config.id;
        ProviderConfig? cfg(AdminState s) {
          try {
            return s.configs.firstWhere((c) => c.id == id);
          } catch (_) {
            return null;
          }
        }

        final a = cfg(prev);
        final b = cfg(next);
        if (a?.isActive != b?.isActive) return true;
        if (a?.baseUrl != b?.baseUrl) return true;
        if (a?.settings != b?.settings) return true;
        return prev.connectionStatuses[id] != next.connectionStatuses[id];
      },
      builder: (context, state, _) {
        final status = state.connectionStatuses[widget.config.id];
        ProviderConfig config;
        try {
          config = state.configs.firstWhere((c) => c.id == widget.config.id);
        } catch (_) {
          config = widget.config;
        }
        final isExpanded = config.isActive;

        return Container(
          decoration: BoxDecoration(
            color: AppColors.surfaceContainerLow,
            borderRadius: AppLayout.borderLarge,
            border: Border.all(
              color: AppColors.outline.withValues(alpha: 0.45),
            ),
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
                        color: AppColors.surfaceContainer.withValues(
                          alpha: 0.9,
                        ),
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
                    if (isExpanded) ...[
                      LivePulsingIcon(status: status),
                      SizedBox(width: AppSpacing.xs),
                      TextButton.icon(
                        onPressed: status?.status.isLoading == true
                            ? null
                            : () {
                                final Map<String, dynamic> currentSettings =
                                    Map.from(config.settings);
                                _controllers.forEach((key, controller) {
                                  currentSettings[key] = controller.text;
                                });

                                final newBaseUrl =
                                    _controllers['baseUrl']?.text ??
                                    _controllers['instanceUrl']?.text ??
                                    config.baseUrl;

                                final configToTest = config.copyWith(
                                  settings: currentSettings,
                                  baseUrl: newBaseUrl.trim(),
                                );
                                widget.bloc.add(
                                  AdminTestConnection(configToTest),
                                );
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
                    Transform.scale(
                      scale: 0.85,
                      child: Switch(
                        value: config.isActive,
                        onChanged: (val) => widget.bloc.add(
                          AdminProviderToggled(
                            id: config.id,
                            isActive: val,
                          ),
                        ),
                        activeThumbColor: AppColors.primary,
                        activeTrackColor: AppColors.primary.withValues(
                          alpha: 0.35,
                        ),
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
                                      style: AppTextStyles.bodyMedium.copyWith(
                                        color: AppColors.onSurfaceHighlight,
                                      ),
                                      decoration: InputDecoration(
                                        filled: true,
                                        fillColor: AppColors.surfaceContainer
                                            .withValues(alpha: 0.65),
                                        hintText: 'Enter ${field.label}...',
                                        hintStyle:
                                            AppTextStyles.bodyMedium.copyWith(
                                              color: AppColors
                                                  .onSurfaceVariantLow
                                                  .withValues(alpha: 0.35),
                                            ),
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                              horizontal: AppSpacing.m,
                                              vertical: AppSpacing.m,
                                            ),
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              AppLayout.borderMedium,
                                          borderSide: BorderSide.none,
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              AppLayout.borderMedium,
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
                                  final Map<String, dynamic> newSettings =
                                      Map.from(config.settings);
                                  _controllers.forEach((key, controller) {
                                    newSettings[key] = controller.text;
                                  });

                                  final newBaseUrl =
                                      _controllers['baseUrl']?.text ??
                                      _controllers['instanceUrl']?.text ??
                                      config.baseUrl;

                                  final updatedConfig = config.copyWith(
                                    settings: newSettings,
                                    baseUrl: newBaseUrl.trim(),
                                  );
                                  widget.bloc.add(
                                    AdminConfigUpdated(updatedConfig),
                                  );
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
      },
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
        AdminConfigField(key: 'clientId', label: 'Client ID'),
        AdminConfigField(
          key: 'clientSecret',
          label: 'Client Secret',
          isSecret: true,
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
}
