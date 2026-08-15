import 'dart:ui';
import 'package:flutter/material.dart';
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
  final VoidCallback onOpenSettings;
  final bool showAdminTab;

  const HomeTopNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
    this.adminTabBadgeCount = 0,
    required this.userName,
    required this.userInitials,
    required this.onOpenSettings,
    this.showAdminTab = true,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.xl,
            vertical: AppSpacing.m,
          ),
          decoration: BoxDecoration(
            color: scheme.surfaceContainer.withValues(alpha: 0.6),
            border: Border(
              bottom: BorderSide(color: scheme.outline.withValues(alpha: 0.25)),
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
                    showAdminTab: showAdminTab,
                  ),
                ],
              ),
              HomeRightSection(
                userName: userName,
                userInitials: userInitials,
                onOpenSettings: onOpenSettings,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
