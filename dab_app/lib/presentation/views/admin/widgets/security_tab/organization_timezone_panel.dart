import 'package:dab_app/presentation/core/localization/l10n_extension.dart';
import 'package:dab_app/presentation/core/styles/app_icons.dart';
import 'package:flutter/material.dart';

import '../org_timezone_options.dart';

/// [ARCH: PRESENTATION_WIDGET]
/// ROLE: Organization timezone dropdown on the Admin Security tab.
class OrganizationTimezonePanel extends StatelessWidget {
  final String selectedTimezone;
  final ValueChanged<String> onTimezoneChanged;

  const OrganizationTimezonePanel({
    super.key,
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
