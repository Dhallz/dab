import 'package:dab_app/domain/entities/provider/provider_config.dart';
import 'package:dab_app/presentation/core/styles/app_colors.dart';
import 'package:dab_app/presentation/views/admin/admin_bloc.dart';
import 'package:dab_app/presentation/views/admin/admin_event.dart';
import 'package:dab_app/presentation/views/admin/admin_state.dart';
import 'package:dab_app/presentation/views/admin/models/admin_config_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
    final isExpanded = widget.config.isActive;

    return BlocBuilder<AdminBloc, AdminState>(
      buildWhen: (prev, next) =>
          prev.connectionStatuses[widget.config.id] !=
          next.connectionStatuses[widget.config.id],
      builder: (context, state) {
        final status = state.connectionStatuses[widget.config.id];

        return Container(
          decoration: BoxDecoration(
            color: AppColors.white.withValues(alpha: 0.03),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: AppColors.white.withValues(alpha: 0.08)),
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(24),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.white.withValues(alpha: 0.05),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Icon(
                        icon,
                        color: AppColors.onSurfaceVariant,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.config.name,
                            style: const TextStyle(
                              color: AppColors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w900,
                              letterSpacing: -0.5,
                            ),
                          ),
                          Text(
                            widget.config.id.toUpperCase(),
                            style: TextStyle(
                              color: AppColors.onSurfaceVariantLow.withValues(
                                alpha: 0.6,
                              ),
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (isExpanded) ...[
                      LivePulsingIcon(status: status),
                      const SizedBox(width: 8),
                      TextButton.icon(
                        onPressed: status?.status.isLoading == true
                            ? null
                            : () {
                                final Map<String, dynamic> currentSettings =
                                    Map.from(widget.config.settings);
                                _controllers.forEach((key, controller) {
                                  currentSettings[key] = controller.text;
                                });

                                final newBaseUrl =
                                    _controllers['baseUrl']?.text ??
                                    _controllers['instanceUrl']?.text ??
                                    widget.config.baseUrl;

                                final configToTest = widget.config.copyWith(
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
                                  color: AppColors.accentIndigo,
                                ),
                              )
                            : const Icon(Icons.bolt, size: 16),
                        label: const Text(
                          'Try',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        style: TextButton.styleFrom(
                          foregroundColor: AppColors.accentIndigo,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                        ),
                      ),
                    ],
                    Transform.scale(
                      scale: 0.8,
                      child: Switch(
                        value: widget.config.isActive,
                        onChanged: (val) => widget.bloc.add(
                          AdminProviderToggled(
                            id: widget.config.id,
                            isActive: val,
                          ),
                        ),
                        activeThumbColor: AppColors.accentIndigo,
                        activeTrackColor: AppColors.accentIndigo.withValues(
                          alpha: 0.3,
                        ),
                        inactiveThumbColor: AppColors.onSurfaceVariantLow,
                        inactiveTrackColor: AppColors.white.withValues(
                          alpha: 0.1,
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
                        padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Divider(
                              color: AppColors.white,
                              height: 1,
                              thickness: 0.05,
                            ),
                            const SizedBox(height: 24),
                            ..._fields.map((field) {
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 20),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      field.label.toUpperCase(),
                                      style: const TextStyle(
                                        color: AppColors.onSurfaceVariantLow,
                                        fontSize: 10,
                                        fontWeight: FontWeight.w900,
                                        letterSpacing: 1,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    TextField(
                                      controller: _controllers[field.key],
                                      obscureText: field.isSecret,
                                      style: const TextStyle(
                                        color: AppColors.white,
                                        fontSize: 14,
                                      ),
                                      decoration: InputDecoration(
                                        filled: true,
                                        fillColor: AppColors.white.withValues(
                                          alpha: 0.05,
                                        ),
                                        hintText: 'Enter ${field.label}...',
                                        hintStyle: TextStyle(
                                          color: AppColors.onSurfaceVariantLow
                                              .withValues(alpha: 0.3),
                                        ),
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                              horizontal: 20,
                                              vertical: 16,
                                            ),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            16,
                                          ),
                                          borderSide: BorderSide.none,
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            16,
                                          ),
                                          borderSide: const BorderSide(
                                            color: AppColors.accentIndigo,
                                            width: 1.5,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }),
                            const SizedBox(height: 8),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.accentIndigo,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 20,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  elevation: 0,
                                ),
                                onPressed: () {
                                  final Map<String, dynamic> newSettings =
                                      Map.from(widget.config.settings);
                                  _controllers.forEach((key, controller) {
                                    newSettings[key] = controller.text;
                                  });

                                  final newBaseUrl =
                                      _controllers['baseUrl']?.text ??
                                      _controllers['instanceUrl']?.text ??
                                      widget.config.baseUrl;

                                  final updatedConfig = widget.config.copyWith(
                                    settings: newSettings,
                                    baseUrl: newBaseUrl.trim(),
                                  );
                                  widget.bloc.add(
                                    AdminConfigUpdated(updatedConfig),
                                  );
                                },
                                child: const Text(
                                  'Save Provider Credentials',
                                  style: TextStyle(fontWeight: FontWeight.w900),
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
    if (lowerId.contains('phorge')) return Icons.hub_outlined;
    if (lowerId.contains('linear')) return Icons.linear_scale;
    if (lowerId.contains('jira')) return Icons.task_alt;
    if (lowerId.contains('teams')) return Icons.groups_outlined;
    if (lowerId.contains('slack')) return Icons.chat_bubble_outline;
    if (lowerId.contains('discord')) return Icons.forum_outlined;
    if (lowerId.contains('github')) return Icons.code;
    if (lowerId.contains('gitlab')) return Icons.account_tree_outlined;
    return Icons.hub_outlined;
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
