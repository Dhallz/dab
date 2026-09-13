import 'package:flutter/material.dart';

import '../../../core/localization/l10n_extension.dart';
import '../../../core/styles/app_icons.dart';
import '../../../core/styles/app_layout.dart';
import '../../../core/styles/app_spacing.dart';
import '../../../core/styles/app_text_styles.dart';

/// [ARCH: PRESENTATION_WIDGET]
/// ROLE: Branding logo for the application.
class HomeLogo extends StatelessWidget {
  final bool showExpandedName;
  final double iconSize;

  const HomeLogo({super.key, this.showExpandedName = true, this.iconSize = 28});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final primaryLabelStyle = AppTextStyles.titleLarge.copyWith(
      color: cs.onSurface,
      fontWeight: FontWeight.w800,
      letterSpacing: -0.3,
    );
    final secondaryLabelStyle = AppTextStyles.labelSmall.copyWith(
      color: cs.onSurfaceVariant,
      fontWeight: FontWeight.w600,
      height: 1.05,
    );

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(AppIcons.brand, color: cs.primary, size: iconSize),
        const SizedBox(width: AppSpacing.s),
        Text(context.l10n.brandShortName, style: primaryLabelStyle),
        if (showExpandedName) ...[
          const SizedBox(width: AppSpacing.xs),
          Container(
            width: 1,
            height: iconSize,
            decoration: BoxDecoration(
              color: cs.outlineVariant.withValues(alpha: 0.75),
              borderRadius: AppLayout.borderSmall,
            ),
          ),
          const SizedBox(width: AppSpacing.xs),
          Text(
            context.l10n.brandTagline,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: secondaryLabelStyle,
          ),
        ],
      ],
    );
  }
}
