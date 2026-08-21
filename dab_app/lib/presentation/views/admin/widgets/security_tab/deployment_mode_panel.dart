import 'package:dab_app/domain/core/deployment_mode.dart';
import 'package:dab_app/presentation/core/localization/l10n_extension.dart';
import 'package:flutter/material.dart';

/// [ARCH: PRESENTATION_WIDGET]
/// ROLE: Managed vs individual deployment-mode control on Admin Security.
class DeploymentModePanel extends StatelessWidget {
  final String mode;
  final ValueChanged<String> onChanged;

  const DeploymentModePanel({
    super.key,
    required this.mode,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final l10n = context.l10n;
    final selected = mode.isIndividualDeploymentMode
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
