import 'package:flutter/material.dart';

import '../../../../core/styles/app_spacing.dart';
import '../../../../core/styles/app_text_styles.dart';

/// [ARCH: PRESENTATION_WIDGET]
/// ROLE: Small section heading in the Insights filter sidebar.
class InsightsSectionTitle extends StatelessWidget {
  final String title;

  const InsightsSectionTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.xxs),
      child: Text(
        title,
        style: AppTextStyles.labelMedium.copyWith(
          color: cs.onSurfaceVariant,
        ),
      ),
    );
  }
}
