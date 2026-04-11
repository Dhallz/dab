import 'package:flutter/material.dart';

/// [ARCH: PRESENTATION_WIDGET]
/// ROLE: Main navigation links for switching between application views.
class HomeNavLinks extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const HomeNavLinks({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final tabs = ['Dashboard', 'Explorer', 'Insights', 'Admin'];
    return Row(
      children: List.generate(tabs.length, (index) {
        final isSelected = currentIndex == index;
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
                child: Text(
                  tabs[index],
                  style: TextStyle(
                    color: isSelected
                        ? const Color(0xFFF1F5F9) // slate-100
                        : const Color(0xFF94A3B8), // slate-400
                    fontSize: 14,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  ),
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}
