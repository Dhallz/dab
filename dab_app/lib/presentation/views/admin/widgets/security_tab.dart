import 'package:dab_app/domain/core/deployment_mode.dart';
import 'package:dab_app/domain/core/org_calendar.dart';
import 'package:dab_app/domain/entities/user/user.dart';
import 'package:dab_app/presentation/core/localization/l10n_extension.dart';
import 'package:dab_app/presentation/core/models/view_status.dart';
import 'package:dab_app/presentation/core/styles/app_icons.dart';
import 'package:dab_app/presentation/views/admin/admin_notifier.dart';
import 'package:flutter/material.dart';

import 'bootstrap_status_card.dart';
import 'org_timezone_options.dart';
import 'user_create_dialog.dart';
import 'user_tile.dart';

/// [ARCH: PRESENTATION_WIDGET]
/// ROLE: Admin Security section — domain validation settings and user
/// management (list, roles, admin-driven account creation).
class SecurityTab extends StatefulWidget {
  final List<User> users;
  final AdminNotifier notifier;
  final Map<String, String> systemSettings;
  final ViewStatus status;
  final String? errorMessage;

  const SecurityTab({
    super.key,
    required this.users,
    required this.notifier,
    required this.systemSettings,
    this.status = ViewStatus.success,
    this.errorMessage,
  });

  @override
  State<SecurityTab> createState() => _SecurityTabState();
}

class _SecurityTabState extends State<SecurityTab> {
  String _query = '';
  late final TextEditingController _domainController;
  late final TextEditingController _publicApiUrlController;
  late String _selectedTimezone;
  late String _deploymentMode;

  @override
  void initState() {
    super.initState();
    _domainController = TextEditingController(
      text: widget.systemSettings['allowed_domain'] ?? '',
    );
    _publicApiUrlController = TextEditingController(
      text: widget.systemSettings['public_api_url'] ?? '',
    );
    _selectedTimezone = resolveOrgTimezoneId(
      widget.systemSettings[kSystemTimezoneSettingKey],
    );
    _deploymentMode = normalizeDeploymentMode(
      widget.systemSettings[kDeploymentModeSettingKey],
    );
  }

  @override
  void didUpdateWidget(covariant SecurityTab oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.systemSettings['allowed_domain'] !=
        oldWidget.systemSettings['allowed_domain']) {
      _domainController.text = widget.systemSettings['allowed_domain'] ?? '';
    }
    if (widget.systemSettings['public_api_url'] !=
        oldWidget.systemSettings['public_api_url']) {
      _publicApiUrlController.text =
          widget.systemSettings['public_api_url'] ?? '';
    }
    final nextTz = resolveOrgTimezoneId(
      widget.systemSettings[kSystemTimezoneSettingKey],
    );
    if (nextTz != _selectedTimezone) {
      _selectedTimezone = nextTz;
    }
    final nextMode = normalizeDeploymentMode(
      widget.systemSettings[kDeploymentModeSettingKey],
    );
    if (nextMode !=
        normalizeDeploymentMode(
          oldWidget.systemSettings[kDeploymentModeSettingKey],
        )) {
      _deploymentMode = nextMode;
    }
  }

  @override
  void dispose() {
    _domainController.dispose();
    _publicApiUrlController.dispose();
    super.dispose();
  }

  bool get _isValidationEnabled =>
      widget.systemSettings['allowed_domain_enabled'] == 'true';

  /// Accounts whose email falls outside the allowed domain. Grandfathered:
  /// they keep working — this is informational only.
  List<User> get _nonCompliantUsers {
    final domain = (widget.systemSettings['allowed_domain'] ?? '')
        .trim()
        .toLowerCase();
    if (!_isValidationEnabled || domain.isEmpty) return const [];
    return widget.users
        .where((u) => !u.email.toLowerCase().endsWith('@$domain'))
        .toList();
  }

  Future<bool> _saveSettings({
    bool? enabled,
    String? domain,
    String? timezone,
    String? deploymentMode,
    String? publicApiUrl,
  }) {
    final settings = Map<String, String>.from(widget.systemSettings);
    if (enabled != null) {
      settings['allowed_domain_enabled'] = enabled.toString();
    }
    if (domain != null) {
      settings['allowed_domain'] = domain;
    }
    if (timezone != null) {
      settings[kSystemTimezoneSettingKey] = timezone;
    }
    if (deploymentMode != null) {
      settings[kDeploymentModeSettingKey] = deploymentMode;
    }
    if (publicApiUrl != null) {
      settings['public_api_url'] = publicApiUrl;
    }
    return widget.notifier.saveSystemSettings(settings);
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final l10n = context.l10n;
    final q = _query.trim().toLowerCase();
    final filtered = q.isEmpty
        ? widget.users
        : widget.users.where((u) {
            return u.name.toLowerCase().contains(q) ||
                u.email.toLowerCase().contains(q);
          }).toList();

    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const BootstrapStatusCard(),
              const SizedBox(height: 24),
              if (!isIndividualDeploymentMode(_deploymentMode)) ...[
                _DomainValidationPanel(
                  isEnabled: _isValidationEnabled,
                  domainController: _domainController,
                  nonCompliantUsers: _nonCompliantUsers,
                  onToggled: (enabled) => _saveSettings(
                    enabled: enabled,
                    domain: _domainController.text.trim(),
                  ),
                  onDomainSaved: () {
                    _saveSettings(domain: _domainController.text.trim());
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(l10n.adminDomainSavedSnack)),
                    );
                  },
                ),
                const SizedBox(height: 24),
              ],
              LayoutBuilder(
                builder: (context, constraints) {
                  final timezonePanel = _OrganizationTimezonePanel(
                    selectedTimezone: _selectedTimezone,
                    onTimezoneChanged: (timezone) {
                      setState(() => _selectedTimezone = timezone);
                      _saveSettings(timezone: timezone);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(l10n.adminTimezoneSavedSnack)),
                      );
                    },
                  );
                  final deploymentPanel = _DeploymentModePanel(
                    mode: _deploymentMode,
                    onChanged: (mode) async {
                      setState(() => _deploymentMode = mode);
                      final messenger = ScaffoldMessenger.of(context);
                      final savedMessage = l10n.adminDeploymentModeSavedSnack;
                      final ok = await _saveSettings(deploymentMode: mode);
                      if (!mounted) return;
                      if (ok) {
                        messenger.showSnackBar(
                          SnackBar(content: Text(savedMessage)),
                        );
                      } else {
                        setState(() {
                          _deploymentMode = normalizeDeploymentMode(
                            widget.systemSettings[kDeploymentModeSettingKey],
                          );
                        });
                      }
                    },
                  );
                  if (constraints.maxWidth < 720) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        timezonePanel,
                        const SizedBox(height: 24),
                        deploymentPanel,
                      ],
                    );
                  }
                  return IntrinsicHeight(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(child: timezonePanel),
                        const SizedBox(width: 24),
                        Expanded(child: deploymentPanel),
                      ],
                    ),
                  );
                },
              ),
              const SizedBox(height: 24),
              _PublicApiUrlPanel(
                controller: _publicApiUrlController,
                onSaved: () {
                  _saveSettings(
                    publicApiUrl: _publicApiUrlController.text.trim(),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(l10n.adminPublicApiUrlSavedSnack)),
                  );
                },
              ),
              const SizedBox(height: 32),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      l10n.adminSecuritySectionTitle,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: cs.onSurfaceVariant,
                        letterSpacing: 1.1,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton.icon(
                    onPressed: () => showDialog<void>(
                      context: context,
                      builder: (_) => const UserCreateDialog(),
                    ),
                    icon: Icon(AppIcons.personAdd, size: 18),
                    label: Text(
                      l10n.adminAddUser,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: cs.primary,
                      foregroundColor: cs.onPrimary,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextField(
                onChanged: (v) => setState(() => _query = v),
                style: TextStyle(color: cs.onSurface, fontSize: 14),
                decoration: InputDecoration(
                  hintText: l10n.adminSecuritySearchHint,
                  hintStyle: TextStyle(
                    color: cs.onSurfaceVariant.withValues(alpha: 0.5),
                  ),
                  filled: true,
                  fillColor: cs.surfaceContainerLow,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
        if (widget.status.isLoading && widget.users.isEmpty)
          const SliverFillRemaining(
            hasScrollBody: false,
            child: Center(child: CircularProgressIndicator()),
          )
        else if (widget.users.isEmpty)
          SliverFillRemaining(
            hasScrollBody: false,
            child: Center(
              child: Text(
                widget.errorMessage ?? l10n.adminSecuritySectionTitle,
                textAlign: TextAlign.center,
                style: TextStyle(color: cs.onSurfaceVariant),
              ),
            ),
          )
        else
          SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
              final user = filtered[index];
              return UserTile(user: user, notifier: widget.notifier);
            }, childCount: filtered.length),
          ),
        const SliverToBoxAdapter(child: SizedBox(height: 24)),
      ],
    );
  }
}

class _DomainValidationPanel extends StatelessWidget {
  final bool isEnabled;
  final TextEditingController domainController;
  final List<User> nonCompliantUsers;
  final ValueChanged<bool> onToggled;
  final VoidCallback onDomainSaved;

  const _DomainValidationPanel({
    required this.isEnabled,
    required this.domainController,
    required this.nonCompliantUsers,
    required this.onToggled,
    required this.onDomainSaved,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final l10n = context.l10n;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: cs.onSurface.withValues(alpha: 0.03),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: cs.outline.withValues(alpha: 0.15)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: cs.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(AppIcons.admin, color: cs.primary, size: 20),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.adminDomainValidationTitle,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: cs.onSurface,
                      ),
                    ),
                    Text(
                      l10n.adminDomainValidationSubtitle,
                      style: TextStyle(
                        color: cs.onSurfaceVariant,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              Switch(
                value: isEnabled,
                onChanged: onToggled,
                activeThumbColor: cs.onPrimary,
                activeTrackColor: cs.primary,
              ),
            ],
          ),
          const SizedBox(height: 24),
          Text(
            l10n.adminAllowedDomainLabel,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: cs.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: domainController,
                  style: TextStyle(color: cs.onSurface, fontSize: 14),
                  decoration: InputDecoration(
                    hintText: l10n.adminAllowedDomainHint,
                    hintStyle: TextStyle(
                      color: cs.onSurfaceVariant.withValues(alpha: 0.5),
                    ),
                    filled: true,
                    fillColor: cs.onSurface.withValues(alpha: 0.05),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: cs.outline.withValues(alpha: 0.2),
                      ),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              ElevatedButton(
                onPressed: onDomainSaved,
                style: ElevatedButton.styleFrom(
                  backgroundColor: cs.primary,
                  foregroundColor: cs.onPrimary,
                  padding: const EdgeInsets.symmetric(
                    vertical: 16,
                    horizontal: 20,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  l10n.adminSaveDomain,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          if (nonCompliantUsers.isNotEmpty) ...[
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: cs.errorContainer.withValues(alpha: 0.35),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: cs.error.withValues(alpha: 0.3)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(AppIcons.warning, color: cs.error, size: 18),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          l10n.adminNonCompliantAccountsWarning,
                          style: TextStyle(
                            color: cs.onSurface,
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ...nonCompliantUsers.map(
                    (u) => Padding(
                      padding: const EdgeInsets.only(left: 26, top: 2),
                      child: Text(
                        '${u.name} — ${u.email}',
                        style: TextStyle(
                          color: cs.onSurfaceVariant,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _OrganizationTimezonePanel extends StatelessWidget {
  final String selectedTimezone;
  final ValueChanged<String> onTimezoneChanged;

  const _OrganizationTimezonePanel({
    required this.selectedTimezone,
    required this.onTimezoneChanged,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final l10n = context.l10n;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: cs.onSurface.withValues(alpha: 0.03),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: cs.outline.withValues(alpha: 0.15)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: cs.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(AppIcons.calendar, color: cs.primary, size: 20),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.adminOrgTimezoneTitle,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: cs.onSurface,
                      ),
                    ),
                    Text(
                      l10n.adminOrgTimezoneSubtitle,
                      style: TextStyle(
                        color: cs.onSurfaceVariant,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Text(
            l10n.adminOrgTimezoneLabel,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: cs.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 8),
          DropdownMenu<String>(
            initialSelection: selectedTimezone,
            expandedInsets: EdgeInsets.zero,
            requestFocusOnTap: true,
            enableFilter: true,
            label: Text(l10n.adminOrgTimezoneLabel),
            onSelected: (value) {
              if (value != null) onTimezoneChanged(value);
            },
            dropdownMenuEntries: kOrgTimezoneOptions
                .map((tz) => DropdownMenuEntry<String>(value: tz, label: tz))
                .toList(),
          ),
        ],
      ),
    );
  }
}

class _DeploymentModePanel extends StatelessWidget {
  final String mode;
  final ValueChanged<String> onChanged;

  const _DeploymentModePanel({required this.mode, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final l10n = context.l10n;
    final selected = isIndividualDeploymentMode(mode)
        ? kDeploymentModeIndividual
        : kDeploymentModeManaged;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: cs.onSurface.withValues(alpha: 0.03),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: cs.outline.withValues(alpha: 0.15)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.adminDeploymentModeTitle,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: cs.onSurface,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            l10n.adminDeploymentModeSubtitle,
            style: TextStyle(color: cs.onSurfaceVariant, fontSize: 12),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: SegmentedButton<String>(
              showSelectedIcon: false,
              segments: [
                ButtonSegment(
                  value: kDeploymentModeManaged,
                  label: Text(l10n.adminDeploymentModeManaged),
                ),
                ButtonSegment(
                  value: kDeploymentModeIndividual,
                  label: Text(l10n.adminDeploymentModeIndividual),
                ),
              ],
              selected: {selected},
              onSelectionChanged: (next) {
                if (next.isEmpty) return;
                onChanged(next.first);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _PublicApiUrlPanel extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onSaved;

  const _PublicApiUrlPanel({required this.controller, required this.onSaved});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final l10n = context.l10n;
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: cs.onSurface.withValues(alpha: 0.03),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: cs.outline.withValues(alpha: 0.15)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.adminPublicApiUrlTitle,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: cs.onSurface,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            l10n.adminPublicApiUrlSubtitle,
            style: TextStyle(color: cs.onSurfaceVariant, fontSize: 12),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: controller,
            decoration: InputDecoration(
              labelText: l10n.adminPublicApiUrlLabel,
              hintText: 'https://dab.example.com',
              isDense: true,
            ),
          ),
          const SizedBox(height: 12),
          Align(
            alignment: Alignment.centerRight,
            child: FilledButton(
              onPressed: onSaved,
              child: Text(l10n.settingsSave),
            ),
          ),
        ],
      ),
    );
  }
}
