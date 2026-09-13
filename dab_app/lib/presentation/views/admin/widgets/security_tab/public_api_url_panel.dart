import 'package:dab_app/presentation/core/localization/l10n_extension.dart';
import 'package:flutter/material.dart';

/// [ARCH: PRESENTATION_WIDGET]
/// ROLE: Public API URL field on the Admin Security tab.
class PublicApiUrlPanel extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onSaved;

  const PublicApiUrlPanel({
    super.key,
    required this.controller,
    required this.onSaved,
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
