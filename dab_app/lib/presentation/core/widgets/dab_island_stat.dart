import 'package:flutter/material.dart';

import '../styles/app_layout.dart';
import '../styles/app_spacing.dart';
import '../styles/app_text_styles.dart';

/// [ARCH: PRESENTATION_CORE]
/// ROLE: Glanceable Island Bar snapshot (icon + value + label).
class DabIslandStat extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final String? tooltip;
  final Color? iconColor;

  const DabIslandStat({
    super.key,
    required this.icon,
    required this.title,
    required this.value,
    this.tooltip,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final content = Padding(
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
              Icon(
                icon,
                size: AppLayout.iconSmall,
                color: iconColor ?? cs.onSurfaceVariant,
              ),
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

    if (tooltip == null || tooltip!.isEmpty) {
      return content;
    }
    return Tooltip(message: tooltip!, child: content);
  }
}
