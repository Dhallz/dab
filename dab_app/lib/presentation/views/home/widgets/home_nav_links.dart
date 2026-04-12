import 'package:flutter/material.dart';
import '../../../core/styles/app_colors.dart';
import '../../../core/styles/app_spacing.dart';
import '../../../core/styles/app_text_styles.dart';

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
          padding: EdgeInsets.only(right: index == tabs.length - 1 ? 0 : 20),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => onTap(index),
              borderRadius: BorderRadius.circular(6),
              hoverColor: Colors.transparent,
              focusColor: Colors.transparent,
              highlightColor: Colors.transparent,
              splashColor: Colors.transparent,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.only(bottom: AppSpacing.xxs),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: isSelected
                            ? AppColors.primary
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
                        style: AppTextStyles.labelLarge.copyWith(
                          color: isSelected
                              ? AppColors.onSurfaceHighlight
                              : AppColors.onSurfaceVariantLow,
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
                            color: AppColors.error,
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
          ),
        );
      }),
    );
  }
}
