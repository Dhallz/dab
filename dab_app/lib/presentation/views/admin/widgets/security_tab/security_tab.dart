import 'package:dab_app/domain/core/daily_report_lock_policy.dart';
import 'package:dab_app/domain/core/deployment_mode.dart';
import 'package:dab_app/domain/core/org_calendar.dart';
import 'package:dab_app/domain/entities/user/user.dart';
import 'package:dab_app/presentation/core/localization/l10n_extension.dart';
import 'package:dab_app/presentation/core/models/view_status.dart';
import 'package:dab_app/presentation/core/styles/app_icons.dart';
import 'package:dab_app/presentation/views/admin/admin_notifier.dart';
import 'package:flutter/material.dart';

import '../bootstrap_status_card.dart';
import '../user_create_dialog.dart';
import '../user_tile.dart';
import 'deployment_mode_panel.dart';
import 'domain_validation_panel.dart';
import 'organization_timezone_panel.dart';
import 'public_api_url_panel.dart';
import 'report_deadline_panel.dart';

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
  late int _reportLockOffsetDays;
  late String _reportLockTime;

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
    _deploymentMode = (widget.systemSettings[kDeploymentModeSettingKey]).normalizeDeploymentMode();
    final reportLock = DailyReportLockPolicy.fromSettings(
      offsetDays: widget.systemSettings[kDailyReportLockOffsetDaysKey],
      time: widget.systemSettings[kDailyReportLockTimeKey],
    );
    _reportLockOffsetDays = reportLock.offsetDays;
    _reportLockTime = reportLock.time;
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
    final nextMode = (widget.systemSettings[kDeploymentModeSettingKey]).normalizeDeploymentMode();
    if (nextMode !=
        (oldWidget.systemSettings[kDeploymentModeSettingKey]).normalizeDeploymentMode()) {
      _deploymentMode = nextMode;
    }
    final nextLock = DailyReportLockPolicy.fromSettings(
      offsetDays: widget.systemSettings[kDailyReportLockOffsetDaysKey],
      time: widget.systemSettings[kDailyReportLockTimeKey],
    );
    if (nextLock.offsetDays != _reportLockOffsetDays ||
        nextLock.time != _reportLockTime) {
      _reportLockOffsetDays = nextLock.offsetDays;
      _reportLockTime = nextLock.time;
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
    int? reportLockOffsetDays,
    String? reportLockTime,
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
    if (reportLockOffsetDays != null) {
      settings[kDailyReportLockOffsetDaysKey] = reportLockOffsetDays.toString();
    }
    if (reportLockTime != null) {
      settings[kDailyReportLockTimeKey] = reportLockTime;
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
              if (!_deploymentMode.isIndividualDeploymentMode) ...[
                DomainValidationPanel(
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
                  final timezonePanel = OrganizationTimezonePanel(
                    selectedTimezone: _selectedTimezone,
                    onTimezoneChanged: (timezone) {
                      setState(() => _selectedTimezone = timezone);
                      _saveSettings(timezone: timezone);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(l10n.adminTimezoneSavedSnack)),
                      );
                    },
                  );
                  final deploymentPanel = DeploymentModePanel(
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
                          _deploymentMode = (widget.systemSettings[kDeploymentModeSettingKey]).normalizeDeploymentMode();
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
              ReportDeadlinePanel(
                offsetDays: _reportLockOffsetDays,
                time: _reportLockTime,
                onChanged: (policy) async {
                  setState(() {
                    _reportLockOffsetDays = policy.offsetDays;
                    _reportLockTime = policy.time;
                  });
                  final messenger = ScaffoldMessenger.of(context);
                  final savedMessage = l10n.adminReportDeadlineSavedSnack;
                  final ok = await _saveSettings(
                    reportLockOffsetDays: policy.offsetDays,
                    reportLockTime: policy.time,
                  );
                  if (!mounted) return;
                  if (ok) {
                    messenger.showSnackBar(
                      SnackBar(content: Text(savedMessage)),
                    );
                  }
                },
              ),
              const SizedBox(height: 24),
              PublicApiUrlPanel(
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
