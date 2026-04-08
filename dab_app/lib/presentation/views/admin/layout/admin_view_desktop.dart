import 'package:dab_app/domain/entities/provider_config.dart';
import 'package:dab_app/domain/entities/user.dart';
import 'package:dab_app/domain/entities/user_identity.dart';
import 'package:dab_app/presentation/core/app_bloc_consumer.dart';
import 'package:dab_app/presentation/core/styles/app_colors.dart';
import 'package:dab_app/presentation/core/widgets/dab_app_bar.dart';
import 'package:dab_app/presentation/views/admin/admin_bloc.dart';
import 'package:dab_app/presentation/views/admin/admin_event.dart';
import 'package:dab_app/presentation/views/admin/admin_state.dart';
import 'package:dab_app/presentation/views/admin/layout/admin_sidebar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AdminViewDesktop extends StatelessWidget {
  const AdminViewDesktop({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBlocConsumer<AdminBloc, AdminState>(
      listener: (context, state, bloc) {
        if (state.errorMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage!),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      builder: (context, state, bloc) {
        return Scaffold(
          backgroundColor: Colors.transparent,
          body: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AdminSidebar(selectedSection: state.selectedSection),
              Expanded(
                child: Column(
                  children: [
                    const Padding(
                      padding: EdgeInsets.fromLTRB(32, 24, 32, 16),
                      child: DabAppBar(),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 32.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _getSectionTitle(state.selectedSection),
                              style: const TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.w900,
                                color: AppColors.white,
                                letterSpacing: -1,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              _getSectionSubtitle(state.selectedSection),
                              style: TextStyle(
                                fontSize: 16,
                                color: AppColors.onSurfaceVariantLow.withValues(alpha: 0.8),
                              ),
                            ),
                            const SizedBox(height: 32),
                            Expanded(
                              child: _buildMainContent(state, bloc),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  String _getSectionTitle(AdminSection section) {
    switch (section) {
      case AdminSection.providers:
        return 'Provider Config';
      case AdminSection.identities:
        return 'Identity Management';
      case AdminSection.security:
        return 'System Security';
    }
  }

  String _getSectionSubtitle(AdminSection section) {
    switch (section) {
      case AdminSection.providers:
        return 'Define and manage external service connections.';
      case AdminSection.identities:
        return 'Resolve and link platform identities to users.';
      case AdminSection.security:
        return 'Manage user roles and deployment security.';
    }
  }

  Widget _buildMainContent(AdminState state, AdminBloc bloc) {
    switch (state.selectedSection) {
      case AdminSection.providers:
        return _ProvidersTab(configs: state.configs, bloc: bloc);
      case AdminSection.identities:
        return _IdentitiesTab(identities: state.identities, bloc: bloc);
      case AdminSection.security:
        return _SecurityTab(users: state.users, bloc: bloc);
    }
  }
}

class _ProvidersTab extends StatelessWidget {
  final List<ProviderConfig> configs;
  final AdminBloc bloc;

  const _ProvidersTab({required this.configs, required this.bloc});

  @override
  Widget build(BuildContext context) {
    if (configs.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.cloud_off, size: 64, color: AppColors.onSurfaceVariantLow),
            const SizedBox(height: 16),
            Text(
              'No providers configured yet',
              style: TextStyle(color: AppColors.onSurfaceVariantLow),
            ),
          ],
        ),
      );
    }

    // Sort: Active first, then name
    final sortedConfigs = List<ProviderConfig>.from(configs)
      ..sort((a, b) {
        if (a.isActive != b.isActive) {
          return a.isActive ? -1 : 1;
        }
        return a.name.compareTo(b.name);
      });

    return ListView.separated(
      padding: const EdgeInsets.all(24),
      itemCount: sortedConfigs.length,
      separatorBuilder: (context, index) => const SizedBox(height: 16),
      itemBuilder: (context, index) => _ProviderCard(
        key: ValueKey(sortedConfigs[index].id),
        config: sortedConfigs[index],
        bloc: bloc,
      ),
    );
  }
}

class _ProviderCard extends StatefulWidget {
  final ProviderConfig config;
  final AdminBloc bloc;

  const _ProviderCard({super.key, required this.config, required this.bloc});

  @override
  State<_ProviderCard> createState() => _ProviderCardState();
}

class _ProviderCardState extends State<_ProviderCard> {
  final Map<String, TextEditingController> _controllers = {};
  late List<_ConfigField> _fields;

  @override
  void initState() {
    super.initState();
    _fields = _getFieldsForProvider(widget.config.id);
    for (final field in _fields) {
      _controllers[field.key] = TextEditingController(text: widget.config.settings[field.key]?.toString() ?? '');
    }
  }

  @override
  void didUpdateWidget(_ProviderCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.config.id != widget.config.id) {
      _fields = _getFieldsForProvider(widget.config.id);
      _controllers.clear();
      for (final field in _fields) {
        _controllers[field.key] = TextEditingController(text: widget.config.settings[field.key]?.toString() ?? '');
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
        prev.connectionStatuses[widget.config.id] != next.connectionStatuses[widget.config.id],
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
              // Header section (Always visible)
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
                      child: Icon(icon, color: AppColors.onSurfaceVariant, size: 24),
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
                              color: AppColors.onSurfaceVariantLow.withValues(alpha: 0.6),
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (isExpanded) ...[
                      _ConnectionStatusIcon(status: status),
                      const SizedBox(width: 8),
                      TextButton.icon(
                        onPressed: status?.status == AdminStatus.loading 
                          ? null 
                          : () {
                              final Map<String, dynamic> currentSettings = Map.from(widget.config.settings);
                              _controllers.forEach((key, controller) {
                                currentSettings[key] = controller.text;
                              });

                              // Ensure UI values for URL are mapped to the top-level baseUrl property
                              final newBaseUrl = _controllers['baseUrl']?.text ?? 
                                                 _controllers['instanceUrl']?.text ?? 
                                                 widget.config.baseUrl;

                              final configToTest = widget.config.copyWith(
                                settings: currentSettings,
                                baseUrl: newBaseUrl.trim(),
                              );
                              widget.bloc.add(AdminTestConnection(configToTest));
                            },
                        icon: status?.status == AdminStatus.loading 
                          ? const SizedBox(width: 14, height: 14, child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.accentIndigo))
                          : const Icon(Icons.bolt, size: 16),
                        label: const Text('Try', style: TextStyle(fontWeight: FontWeight.bold)),
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
                        onChanged: (val) => widget.bloc.add(AdminProviderToggled(id: widget.config.id, isActive: val)),
                        activeThumbColor: AppColors.accentIndigo,
                        activeTrackColor: AppColors.accentIndigo.withValues(alpha: 0.3),
                        inactiveThumbColor: AppColors.onSurfaceVariantLow,
                        inactiveTrackColor: AppColors.white.withValues(alpha: 0.1),
                      ),
                    ),
                  ],
                ),
              ),
              
              // Collapsible Settings section
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
                          const Divider(color: AppColors.white, height: 1, thickness: 0.05),
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
                                    style: const TextStyle(color: AppColors.white, fontSize: 14),
                                    decoration: InputDecoration(
                                      filled: true,
                                      fillColor: AppColors.white.withValues(alpha: 0.05),
                                      hintText: 'Enter ${field.label}...',
                                      hintStyle: TextStyle(color: AppColors.onSurfaceVariantLow.withValues(alpha: 0.3)),
                                      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(16),
                                        borderSide: BorderSide.none,
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(16),
                                        borderSide: const BorderSide(color: AppColors.accentIndigo, width: 1.5),
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
                                padding: const EdgeInsets.symmetric(vertical: 20),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                elevation: 0,
                              ),
                              onPressed: () {
                                final Map<String, dynamic> newSettings = Map.from(widget.config.settings);
                                _controllers.forEach((key, controller) {
                                  newSettings[key] = controller.text;
                                });

                                // Ensure UI values for URL are mapped to the top-level baseUrl property
                                final newBaseUrl = _controllers['baseUrl']?.text ?? 
                                                   _controllers['instanceUrl']?.text ?? 
                                                   widget.config.baseUrl;

                                final updatedConfig = widget.config.copyWith(
                                  settings: newSettings,
                                  baseUrl: newBaseUrl.trim(),
                                );
                                widget.bloc.add(AdminConfigUpdated(updatedConfig));
                              },
                              child: const Text('Save Provider Credentials', style: TextStyle(fontWeight: FontWeight.w900)),
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

  List<_ConfigField> _getFieldsForProvider(String id) {
    final lowerId = id.toLowerCase();
    if (lowerId.contains('phorge')) {
      return [
        _ConfigField(key: 'apiToken', label: 'API Token', isSecret: true),
        _ConfigField(key: 'baseUrl', label: 'Base URL'),
      ];
    }
    if (lowerId.contains('linear')) {
      return [
        _ConfigField(key: 'apiKey', label: 'API Key', isSecret: true),
      ];
    }
    if (lowerId.contains('jira')) {
      return [
        _ConfigField(key: 'apiToken', label: 'API Token', isSecret: true),
        _ConfigField(key: 'email', label: 'Atlassian Email'),
        _ConfigField(key: 'instanceUrl', label: 'Jira Instance URL (e.g. company.atlassian.net)'),
      ];
    }
    if (lowerId.contains('teams')) {
      return [
        _ConfigField(key: 'clientId', label: 'Application (Client) ID'),
        _ConfigField(key: 'clientSecret', label: 'Client Secret', isSecret: true),
        _ConfigField(key: 'tenantId', label: 'Directory (Tenant) ID'),
      ];
    }
    if (lowerId.contains('slack')) {
      return [
        _ConfigField(key: 'botToken', label: 'Bot Token', isSecret: true),
      ];
    }
    if (lowerId.contains('discord')) {
      return [
        _ConfigField(key: 'botToken', label: 'Bot Token', isSecret: true),
        _ConfigField(key: 'guildId', label: 'Guild (Server) ID'),
      ];
    }
    if (lowerId.contains('github')) {
      return [
        _ConfigField(key: 'clientId', label: 'Client ID'),
        _ConfigField(key: 'clientSecret', label: 'Client Secret', isSecret: true),
      ];
    }
    if (lowerId.contains('gitlab')) {
      return [
        _ConfigField(key: 'apiToken', label: 'API Token', isSecret: true),
        _ConfigField(key: 'instanceUrl', label: 'GitLab Instance URL (e.g. gitlab.com)'),
      ];
    }
    return [
      _ConfigField(key: 'token', label: 'API Token / Secret', isSecret: true),
    ];
  }
}

class _ConnectionStatusIcon extends StatelessWidget {
  final ProviderConnectionStatus? status;

  const _ConnectionStatusIcon({this.status});

  @override
  Widget build(BuildContext context) {
    if (status == null) return const SizedBox.shrink();

    switch (status!.status) {
      case AdminStatus.success:
        return const Icon(Icons.check_circle_rounded, color: Colors.green, size: 16);
      case AdminStatus.failure:
        return Tooltip(
          message: status?.message ?? 'Connection failed',
          child: const Icon(Icons.error_rounded, color: Colors.red, size: 16),
        );
      case AdminStatus.loading:
        return const SizedBox.shrink(); // Handled by button indicator
      case AdminStatus.initial:
        return const SizedBox.shrink();
    }
  }
}

class _ConfigField {
  final String key;
  final String label;
  final bool isSecret;

  _ConfigField({required this.key, required this.label, this.isSecret = false});
}

class _IdentitiesTab extends StatelessWidget {
  final List<UserIdentity> identities;
  final AdminBloc bloc;

  const _IdentitiesTab({required this.identities, required this.bloc});

  @override
  Widget build(BuildContext context) {
    if (identities.isEmpty) {
      return const Center(
        child: Text(
          'No pending identities.',
          style: TextStyle(color: AppColors.onSurfaceVariantLow),
        ),
      );
    }

    return ListView.builder(
      itemCount: identities.length,
      itemBuilder: (context, index) {
        final identity = identities[index];
        final isLinked = identity.status == 'linked';

        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.white.withValues(alpha: 0.03),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.white.withValues(alpha: 0.05)),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.white.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  _getProviderIcon(identity.providerId),
                  color: AppColors.onSurfaceVariant,
                  size: 20,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      identity.externalId,
                      style: const TextStyle(
                        color: AppColors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                    Text(
                      'Provider: ${identity.providerId}',
                      style: const TextStyle(color: AppColors.onSurfaceVariantLow, fontSize: 12),
                    ),
                  ],
                ),
              ),
              _StatusChip(isLinked: isLinked),
              const SizedBox(width: 16),
              if (!isLinked)
                TextButton(
                  onPressed: () => _showLinkDialog(context, identity, bloc),
                  child: const Text(
                    'Link User',
                    style: TextStyle(
                      color: AppColors.accentIndigo,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  IconData _getProviderIcon(String providerId) {
    final lowerId = providerId.toLowerCase();
    if (lowerId.contains('phorge')) return Icons.hub_outlined;
    if (lowerId.contains('linear')) return Icons.linear_scale;
    if (lowerId.contains('jira')) return Icons.task_alt;
    if (lowerId.contains('teams')) return Icons.groups_outlined;
    if (lowerId.contains('slack')) return Icons.chat_bubble_outline;
    if (lowerId.contains('discord')) return Icons.forum_outlined;
    if (lowerId.contains('github')) return Icons.code;
    if (lowerId.contains('gitlab')) return Icons.account_tree_outlined;
    return Icons.account_circle_outlined;
  }

  void _showLinkDialog(
    BuildContext context,
    UserIdentity identity,
    AdminBloc bloc,
  ) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF0F172A),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text(
          'Link External Identity',
          style: TextStyle(color: AppColors.white, fontWeight: FontWeight.bold),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Associate ${identity.externalId} with a DAB user account.',
              style: const TextStyle(color: AppColors.onSurfaceVariantLow, fontSize: 13),
            ),
            const SizedBox(height: 24),
            TextField(
              controller: controller,
              style: const TextStyle(color: AppColors.white),
              decoration: InputDecoration(
                filled: true,
                fillColor: AppColors.white.withValues(alpha: 0.05),
                labelText: 'Target User ID',
                labelStyle: const TextStyle(color: AppColors.onSurfaceVariantLow),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                prefixIcon: const Icon(Icons.person_outline, color: AppColors.onSurfaceVariantLow),
              ),
            ),
          ],
        ),
        actionsPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: AppColors.onSurfaceVariantLow)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.accentIndigo,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            onPressed: () {
              bloc.add(
                AdminIdentityLinked(
                  userId: controller.text,
                  providerId: identity.providerId,
                  externalId: identity.externalId,
                ),
              );
              Navigator.pop(context);
            },
            child: const Text('Confirm Link', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  final bool isLinked;

  const _StatusChip({required this.isLinked});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: (isLinked ? Colors.green : Colors.orange).withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: (isLinked ? Colors.green : Colors.orange).withValues(alpha: 0.2)),
      ),
      child: Text(
        isLinked ? 'LINKED' : 'PENDING',
        style: TextStyle(
          color: isLinked ? Colors.green : Colors.orange,
          fontSize: 10,
          fontWeight: FontWeight.w900,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}

class _SecurityTab extends StatelessWidget {
  final List<User> users;
  final AdminBloc bloc;

  const _SecurityTab({required this.users, required this.bloc});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _BootstrapStatusCard(),
        const SizedBox(height: 32),
        const Text(
          'USER MANAGEMENT',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: AppColors.onSurfaceVariantLow,
            letterSpacing: 1.1,
          ),
        ),
        const SizedBox(height: 16),
        Expanded(
          child: users.isEmpty
              ? const Center(child: CircularProgressIndicator())
              : ListView.builder(
                  itemCount: users.length,
                  itemBuilder: (context, index) {
                    final user = users[index];
                    return _UserTile(user: user, bloc: bloc);
                  },
                ),
        ),
      ],
    );
  }
}

class _BootstrapStatusCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.white.withValues(alpha: 0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.green.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.verified_user_outlined, color: Colors.green, size: 20),
              ),
              const SizedBox(width: 16),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Bootstrap Lock: ACTIVE',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.white,
                      ),
                    ),
                    Text(
                      'System is locked and requires an administrative account.',
                      style: TextStyle(color: AppColors.onSurfaceVariantLow, fontSize: 13),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _UserTile extends StatelessWidget {
  final User user;
  final AdminBloc bloc;

  const _UserTile({required this.user, required this.bloc});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white.withValues(alpha: 0.03),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.white.withValues(alpha: 0.05)),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: AppColors.accentIndigo.withValues(alpha: 0.1),
            child: Text(
              user.name.isNotEmpty ? user.name[0].toUpperCase() : '?',
              style: const TextStyle(color: AppColors.accentIndigo, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user.name,
                  style: const TextStyle(
                    color: AppColors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                Text(
                  user.email,
                  style: const TextStyle(color: AppColors.onSurfaceVariantLow, fontSize: 12),
                ),
              ],
            ),
          ),
          _RoleDropdown(user: user, bloc: bloc),
        ],
      ),
    );
  }
}

class _RoleDropdown extends StatelessWidget {
  final User user;
  final AdminBloc bloc;

  const _RoleDropdown({required this.user, required this.bloc});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.white.withValues(alpha: 0.1)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: user.role,
          dropdownColor: const Color(0xFF1E293B),
          style: const TextStyle(color: AppColors.white, fontSize: 13, fontWeight: FontWeight.w600),
          icon: const Icon(Icons.keyboard_arrow_down, color: AppColors.onSurfaceVariantLow, size: 18),
          items: ['admin', 'user'].map((role) {
            return DropdownMenuItem(
              value: role,
              child: Text(role.toUpperCase()),
            );
          }).toList(),
          onChanged: (newRole) {
            if (newRole != null && newRole != user.role) {
              bloc.add(AdminUserRoleUpdated(userId: user.id, role: newRole));
            }
          },
        ),
      ),
    );
  }
}
