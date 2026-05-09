import 'package:dab_app/domain/entities/user/user.dart';
import 'package:dab_app/presentation/core/localization/l10n_extension.dart';
import 'package:dab_app/presentation/views/admin/admin_notifier.dart';
import 'package:flutter/material.dart';

import 'bootstrap_status_card.dart';
import 'user_tile.dart';

class SecurityTab extends StatefulWidget {
  final List<User> users;
  final AdminNotifier notifier;

  const SecurityTab({super.key, required this.users, required this.notifier});

  @override
  State<SecurityTab> createState() => _SecurityTabState();
}

class _SecurityTabState extends State<SecurityTab> {
  String _query = '';

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
        const SizedBox(height: 32),
        Text(
          l10n.adminSecuritySectionTitle,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: cs.onSurfaceVariant,
            letterSpacing: 1.1,
          ),
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
