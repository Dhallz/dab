import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// [ARCH: PRESENTATION_WIDGET]
/// ROLE: Bottom-docked (or top-tab) navigation for the mobile home view.
class HomeMobileNav extends StatelessWidget {
  final StatefulNavigationShell navigationShell;
  final int adminTabBadgeCount;
  final ValueChanged<int> onBranchSelected;

  const HomeMobileNav({
    super.key,
    required this.navigationShell,
    this.adminTabBadgeCount = 0,
    required this.onBranchSelected,
  });

  @override
  Widget build(BuildContext context) {
    final tabs = ['Dashboard', 'Explorer', 'Insights', 'Admin'];
    return SizedBox(
      height: 48,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        scrollDirection: Axis.horizontal,
        itemCount: tabs.length,
        itemBuilder: (context, index) {
          final isSelected = navigationShell.currentIndex == index;
          final isAdminTab = index == 3;
          final showBadge = isAdminTab && adminTabBadgeCount > 0;
          return GestureDetector(
            onTap: () => onBranchSelected(index),
            child: Container(
              margin: const EdgeInsets.only(right: 16),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: isSelected
                        ? const Color(0xFF6366F1)
                        : Colors.transparent,
                    width: 2,
                  ),
                ),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    tabs[index],
                    style: TextStyle(
                      color:
                          isSelected ? Colors.white : const Color(0xFF94A3B8),
                      fontWeight:
                          isSelected ? FontWeight.w600 : FontWeight.w500,
                      fontSize: 14,
                    ),
                  ),
                  if (showBadge) ...[
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEF4444),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      constraints: const BoxConstraints(minWidth: 18),
                      child: Text(
                        adminTabBadgeCount > 99
                            ? '99+'
                            : '$adminTabBadgeCount',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
