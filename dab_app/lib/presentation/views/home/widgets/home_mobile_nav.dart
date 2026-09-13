import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/localization/l10n_extension.dart';

/// [ARCH: PRESENTATION_WIDGET]
/// ROLE: Bottom-docked (or top-tab) navigation for the mobile home view.
class HomeMobileNav extends StatelessWidget {
  final StatefulNavigationShell navigationShell;
  final int adminTabBadgeCount;
  final ValueChanged<int> onBranchSelected;
  final bool showAdminTab;

  const HomeMobileNav({
    super.key,
    required this.navigationShell,
    this.adminTabBadgeCount = 0,
    required this.onBranchSelected,
    this.showAdminTab = true,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final tabs = [
      context.l10n.dashboardTitle,
      context.l10n.navExplorer,
      context.l10n.insightsTitle,
      context.l10n.navReports,
      if (showAdminTab) context.l10n.navAdmin,
    ];
    return SizedBox(
      height: 48,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        scrollDirection: Axis.horizontal,
        itemCount: tabs.length,
        itemBuilder: (context, index) {
          final isSelected = navigationShell.currentIndex == index;
          final isAdminTab = showAdminTab && index == 4;
          final showBadge = isAdminTab && adminTabBadgeCount > 0;
          return GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => onBranchSelected(index),
            child: Container(
              margin: const EdgeInsets.only(right: 16),
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
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    tabs[index],
                    style: TextStyle(
                      color: isSelected
                          ? scheme.onSurface
                          : scheme.onSurfaceVariant,
                      fontWeight: isSelected
                          ? FontWeight.w600
                          : FontWeight.w500,
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
                        color: scheme.error,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      constraints: const BoxConstraints(minWidth: 18),
                      child: Text(
                        adminTabBadgeCount > 99 ? '99+' : '$adminTabBadgeCount',
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
          );
        },
      ),
    );
  }
}
