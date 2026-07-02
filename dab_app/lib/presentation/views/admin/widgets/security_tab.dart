import 'package:dab_app/domain/entities/user/user.dart';
import 'package:dab_app/presentation/core/localization/l10n_extension.dart';
import 'package:dab_app/presentation/views/admin/admin_notifier.dart';
import 'package:flutter/material.dart';

import 'bootstrap_status_card.dart';
import 'user_create_dialog.dart';
import 'user_tile.dart';

/// [ARCH: PRESENTATION_WIDGET]
/// ROLE: Admin Security section — domain validation settings and user
/// management (list, roles, admin-driven account creation).
class SecurityTab extends StatefulWidget {
  final List<User> users;
  final AdminNotifier notifier;
  final Map<String, String> systemSettings;

  const SecurityTab({
    super.key,
    required this.users,
    required this.notifier,
    required this.systemSettings,
  });

  @override
  State<SecurityTab> createState() => _SecurityTabState();
}

class _SecurityTabState extends State<SecurityTab> {
  String _query = '';
  late final TextEditingController _domainController;

  @override
  void initState() {
    super.initState();
    _domainController = TextEditingController(
      text: widget.systemSettings['allowed_domain'] ?? '',
    );
  }

  @override
  void didUpdateWidget(covariant SecurityTab oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.systemSettings['allowed_domain'] !=
        oldWidget.systemSettings['allowed_domain']) {
      _domainController.text = widget.systemSettings['allowed_domain'] ?? '';
    }
  }

  @override
  void dispose() {
    _domainController.dispose();
    super.dispose();
  }

  bool get _isValidationEnabled =>
      widget.systemSettings['allowed_domain_enabled'] == 'true';

  /// Accounts whose email falls outside the allowed domain. Grandfathered:
  /// they keep working — this is informational only.
  List<User> get _nonCompliantUsers {
    final domain =
        (widget.systemSettings['allowed_domain'] ?? '').trim().toLowerCase();
    if (!_isValidationEnabled || domain.isEmpty) return const [];
    return widget.users
        .where((u) => !u.email.toLowerCase().endsWith('@$domain'))
        .toList();
  }

  void _saveSettings({bool? enabled, String? domain}) {
    final settings = Map<String, String>.from(widget.systemSettings);
    if (enabled != null) {
      settings['allowed_domain_enabled'] = enabled.toString();
    }
    if (domain != null) {
      settings['allowed_domain'] = domain;
    }
    widget.notifier.saveSystemSettings(settings);
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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const BootstrapStatusCard(),
        const SizedBox(height: 24),
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
              ),
            ),
            ElevatedButton.icon(
              onPressed: () => showDialog<void>(
                context: context,
                builder: (_) => const UserCreateDialog(),
              ),
              icon: const Icon(Icons.person_add_outlined, size: 18),
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
        Expanded(
          child: widget.users.isEmpty
              ? const Center(child: CircularProgressIndicator())
              : ListView.builder(
                  itemCount: filtered.length,
                  itemBuilder: (context, index) {
                    final user = filtered[index];
                    return UserTile(user: user, notifier: widget.notifier);
                  },
                ),
        ),
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
                child: Icon(
                  Icons.verified_user_outlined,
                  color: cs.primary,
                  size: 20,
                ),
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
                      Icon(
                        Icons.warning_amber_outlined,
                        color: cs.error,
                        size: 18,
                      ),
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
