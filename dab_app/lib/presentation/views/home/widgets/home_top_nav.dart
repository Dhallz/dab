import 'dart:ui';
import 'package:flutter/material.dart';
import '../../../core/styles/app_colors.dart';
import '../../../core/styles/app_spacing.dart';

import 'home_logo.dart';
import 'home_nav_links.dart';
import 'home_right_section.dart';

/// [ARCH: PRESENTATION_WIDGET]
/// ROLE: Top navigation bar for the home view.
class HomeTopNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  final int adminTabBadgeCount;
  final String userName;
  final String userInitials;

  const HomeTopNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
    this.adminTabBadgeCount = 0,
    required this.userName,
    required this.userInitials,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.xl,
            vertical: AppSpacing.m,
          ),
          decoration: BoxDecoration(
            color: AppColors.surfaceContainer.withValues(alpha: 0.6),
            border: Border(
              bottom: BorderSide(color: AppColors.white.withValues(alpha: 0.1)),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const HomeLogo(),
                  const SizedBox(width: AppSpacing.xxl),
                  HomeNavLinks(
                    currentIndex: currentIndex,
                    onTap: onTap,
                    adminTabBadgeCount: adminTabBadgeCount,
                  ),
                ],
              ),
              HomeRightSection(userName: userName, userInitials: userInitials),
            ],
          ),
        ),
      ),
    );
  }
}
