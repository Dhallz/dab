import 'package:flutter/material.dart';
import '../../../core/localization/l10n_extension.dart';
import '../../../core/styles/app_spacing.dart';
import '../../../core/styles/app_text_styles.dart';

/// [ARCH: PRESENTATION_WIDGET]
/// ROLE: Main navigation links for switching between application views.
class HomeNavLinks extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  final int adminTabBadgeCount;
  final bool showAdminTab;

  const HomeNavLinks({
    super.key,
    required this.currentIndex,
    required this.onTap,
    this.adminTabBadgeCount = 0,
    this.showAdminTab = true,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final tabs = [
      context.l10n.dashboardTitle,
      context.l10n.navReports,
      context.l10n.navExplorer,
      context.l10n.insightsTitle,
      if (showAdminTab) context.l10n.navAdmin,
    ];
    return Row(
      children: List.generate(tabs.length, (index) {
        final isSelected = currentIndex == index;
        final isAdminTab = showAdminTab && index == 4;
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
                            ? scheme.primary
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
                              ? scheme.onSurface
                              : scheme.onSurfaceVariant,
                          fontWeight: isSelected
                              ? FontWeight.w600
                              : FontWeight.w500,
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
                            color: scheme.error,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          constraints: const BoxConstraints(minWidth: 18),
                          child: Text(
                            adminTabBadgeCount > 99
                                ? '99+'
                                : '$adminTabBadgeCount',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: scheme.onError,
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
