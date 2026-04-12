import 'dart:ui';

import 'package:flutter/material.dart';
import '../../../core/styles/app_icons.dart';

import '../models/dab_view_tab.dart';
import 'dab_tab_item.dart';

class DabTopMenu extends StatelessWidget {
  final DabViewTab activeTab;
  final ValueChanged<DabViewTab> onTabChanged;

  const DabTopMenu({
    super.key,
    required this.activeTab,
    required this.onTabChanged,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
          decoration: BoxDecoration(
            color: const Color(0xFF1E293B).withOpacity(0.7),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white.withOpacity(0.1)),
          ),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                DabTabItem(
                  label: 'Feed',
                  icon: AppIcons.dashboard,
                  isSelected: activeTab == DabViewTab.feed,
                  onTap: () => onTabChanged(DabViewTab.feed),
                ),
                DabTabItem(
                  label: 'Explorer',
                  icon: AppIcons.history,
                  isSelected: activeTab == DabViewTab.explorer,
                  onTap: () => onTabChanged(DabViewTab.explorer),
                ),
                DabTabItem(
                  label: 'Insights',
                  icon: AppIcons.insights,
                  isSelected: activeTab == DabViewTab.insights,
                  onTap: () => onTabChanged(DabViewTab.insights),
                ),
                DabTabItem(
                  label: 'Admin',
                  icon: AppIcons.admin,
                  isSelected: activeTab == DabViewTab.admin,
                  onTap: () => onTabChanged(DabViewTab.admin),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
