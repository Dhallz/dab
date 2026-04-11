import 'package:dab_app/presentation/core/styles/app_colors.dart';
import 'package:flutter/material.dart';

/// [ARCH: PRESENTATION_WIDGET]
/// ROLE: Vertical rule between snapshot and connection metric groups in the admin island bar.
class AdminIslandSectionDivider extends StatelessWidget {
  const AdminIslandSectionDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: VerticalDivider(
        width: 1,
        thickness: 1,
        indent: 6,
        endIndent: 6,
        color: AppColors.outline.withValues(alpha: 0.55),
      ),
    );
  }
}
