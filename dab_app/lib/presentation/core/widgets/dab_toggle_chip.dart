import 'package:flutter/material.dart';

import '../styles/app_layout.dart';
import '../styles/app_spacing.dart';
import '../styles/app_text_styles.dart';

/// [ARCH: PRESENTATION_CORE]
/// ROLE: Exclusive-select pill used in view toolbars and similar chrome.
class DabToggleChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback? onTap;
  final IconData? icon;

  const DabToggleChip({
    super.key,
    required this.label,
    required this.isSelected,
    this.onTap,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final selected = isSelected;
    return Material(
      color: selected
          ? scheme.primary.withValues(alpha: 0.2)
          : scheme.surfaceContainerHighest.withValues(alpha: 0.55),
      shape: StadiumBorder(
        side: BorderSide(
          color: selected
              ? scheme.primary.withValues(alpha: 0.45)
              : scheme.outline.withValues(alpha: 0.35),
        ),
      ),
      child: InkWell(
        customBorder: const StadiumBorder(),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.m,
            vertical: 10,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Icon(
                  icon,
                  size: AppLayout.iconSmall,
                  color: selected ? scheme.primary : scheme.onSurfaceVariant,
                ),
                const SizedBox(width: AppSpacing.xs),
              ],
              Text(
                label,
                style: AppTextStyles.labelLarge.copyWith(
                  color: selected ? scheme.primary : scheme.onSurface,
                  fontWeight: selected ? FontWeight.w700 : FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
