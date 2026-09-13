import 'package:flutter/material.dart';

import '../styles/app_layout.dart';
import '../styles/app_spacing.dart';
import '../styles/app_text_styles.dart';

/// [ARCH: PRESENTATION_CORE]
/// ROLE: Glanceable snapshot (icon + value + label) for toolbars and sidebars.
class DabIslandStat extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final String? tooltip;
  final Color? iconColor;

  /// Single-line toolbar metric. Sidebar keeps the two-line tile when false.
  final bool compact;

  const DabIslandStat({
    super.key,
    required this.icon,
    required this.title,
    required this.value,
    this.tooltip,
    this.iconColor,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final iconTone = iconColor ?? cs.onSurfaceVariant;
    final Widget content;
    if (compact) {
      content = Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.s,
          vertical: AppSpacing.xs,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: AppLayout.iconSmall, color: iconTone),
            const SizedBox(width: AppSpacing.xs),
            Text(
              title,
              style: AppTextStyles.labelMedium.copyWith(
                color: cs.onSurfaceVariant,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(width: AppSpacing.xs),
            Text(
              value,
              style: AppTextStyles.titleSmall.copyWith(
                color: cs.onSurface,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      );
    } else {
      content = Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.s,
          vertical: AppSpacing.xs,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, size: AppLayout.iconSmall, color: iconTone),
                const SizedBox(width: AppSpacing.xs),
                Flexible(
                  child: Text(
                    title,
                    style: AppTextStyles.labelSmall.copyWith(
                      color: cs.onSurfaceVariant,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: AppTextStyles.titleMedium.copyWith(
                color: cs.onSurface,
                fontWeight: FontWeight.w700,
                letterSpacing: -0.2,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      );
    }

    if (tooltip == null || tooltip!.isEmpty) {
      return content;
    }
    return Tooltip(message: tooltip!, child: content);
  }
}
