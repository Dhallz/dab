import 'dart:ui';

import 'package:flutter/material.dart';

enum DabViewTab { feed, history, stats, admin }

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
                _TabItem(
                  label: 'Feed',
                  icon: Icons.dashboard_rounded,
                  isSelected: activeTab == DabViewTab.feed,
                  onTap: () => onTabChanged(DabViewTab.feed),
                ),
                _TabItem(
                  label: 'History',
                  icon: Icons.history_rounded,
                  isSelected: activeTab == DabViewTab.history,
                  onTap: () => onTabChanged(DabViewTab.history),
                ),
                _TabItem(
                  label: 'Stats',
                  icon: Icons.insights_rounded,
                  isSelected: activeTab == DabViewTab.stats,
                  onTap: () => onTabChanged(DabViewTab.stats),
                ),
                _TabItem(
                  label: 'Admin',
                  icon: Icons.admin_panel_settings_rounded,
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

class _TabItem extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _TabItem({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutCubic,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFF6366F1).withOpacity(0.15)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 18,
              color: isSelected
                  ? const Color(0xFF6366F1)
                  : const Color(0xFF94A3B8).withOpacity(0.7),
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                color: isSelected
                    ? Colors.white
                    : const Color(0xFF94A3B8).withOpacity(0.7),
                letterSpacing: 0.2,
              ),
            ),
            if (isSelected) ...[
              const SizedBox(width: 4),
              Container(
                width: 4,
                height: 4,
                decoration: const BoxDecoration(
                  color: Color(0xFF6366F1),
                  shape: BoxShape.circle,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
