import 'package:flutter/material.dart';

/// [ARCH: PRESENTATION_WIDGET]
/// ROLE: Main navigation links for switching between application views.
class HomeNavLinks extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  final int adminTabBadgeCount;

  const HomeNavLinks({
    super.key,
    required this.currentIndex,
    required this.onTap,
    this.adminTabBadgeCount = 0,
  });

  @override
  Widget build(BuildContext context) {
    final tabs = ['Dashboard', 'Explorer', 'Insights', 'Admin'];
    return Row(
      children: List.generate(tabs.length, (index) {
        final isSelected = currentIndex == index;
        final isAdminTab = index == 3;
        final showBadge = isAdminTab && adminTabBadgeCount > 0;
        return Padding(
          padding: const EdgeInsets.only(right: 32),
          child: MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTap: () => onTap(index),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.only(bottom: 4),
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
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      tabs[index],
                      style: TextStyle(
                        color: isSelected
                            ? const Color(0xFFF1F5F9) // slate-100
                            : const Color(0xFF94A3B8), // slate-400
                        fontSize: 14,
                        fontWeight:
                            isSelected ? FontWeight.w600 : FontWeight.w500,
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
            ),
          ),
        );
      }),
    );
  }
}
