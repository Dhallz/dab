import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// [ARCH: PRESENTATION_WIDGET]
/// ROLE: Bottom-docked (or top-tab) navigation for the mobile home view.
class HomeMobileNav extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const HomeMobileNav({
    super.key,
    required this.navigationShell,
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
          return GestureDetector(
            onTap: () {
              navigationShell.goBranch(
                index,
                initialLocation: index == navigationShell.currentIndex,
              );
            },
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
              child: Text(
                tabs[index],
                style: TextStyle(
                  color: isSelected ? Colors.white : const Color(0xFF94A3B8),
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  fontSize: 14,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
