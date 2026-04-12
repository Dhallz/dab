import 'package:flutter/material.dart';
import '../../../core/styles/app_colors.dart';
import '../../../core/styles/app_spacing.dart';
import 'home_logo.dart';

/// [ARCH: PRESENTATION_WIDGET]
/// ROLE: Header display for the mobile version of the home view.
class HomeMobileHeader extends StatelessWidget {
  final String userInitials;

  const HomeMobileHeader({super.key, required this.userInitials});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final showExpandedName = constraints.maxWidth >= 380;
        return Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.l,
            AppSpacing.m,
            AppSpacing.l,
            AppSpacing.m,
          ),
          child: Row(
            children: [
              Expanded(
                child: HomeLogo(
                  showExpandedName: showExpandedName,
                  iconSize: 24,
                ),
              ),
              const SizedBox(width: AppSpacing.m),
              CircleAvatar(
                radius: 16,
                backgroundColor: AppColors.primary.withValues(alpha: 0.2),
                child: Text(
                  userInitials,
                  style: TextStyle(
                    color: AppColors.onSurfaceHighlight,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
