import 'package:flutter/material.dart';

import '../styles/app_icons.dart';
import '../styles/app_spacing.dart';
import '../styles/app_text_styles.dart';

/// [ARCH: PRESENTATION_CORE]
/// ROLE: Collapsible uppercase section header plus optional body.
class FilterSidebarSection extends StatelessWidget {
  final String title;
  final Widget child;
  final bool isExpanded;
  final VoidCallback onToggle;

  const FilterSidebarSection({
    super.key,
    required this.title,
    required this.child,
    required this.isExpanded,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Tooltip(
          message: title,
          child: InkWell(
            onTap: onToggle,
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    title.toUpperCase(),
                    style: AppTextStyles.labelSmall.copyWith(
                      color: cs.onSurfaceVariant,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.2,
                    ),
                  ),
                ),
                Icon(
                  isExpanded ? AppIcons.visibilityOff : AppIcons.visibility,
                  size: AppSpacing.s,
                  color: cs.onSurfaceVariant,
                ),
              ],
            ),
          ),
        ),
        if (isExpanded) ...[const SizedBox(height: AppSpacing.m), child],
      ],
    );
  }
}
