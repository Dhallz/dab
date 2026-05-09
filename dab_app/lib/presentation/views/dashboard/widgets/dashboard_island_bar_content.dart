import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../domain/entities/system/app_settings.dart';
import '../../../core/localization/l10n_extension.dart';
import '../../../core/styles/app_icons.dart';
import '../../../core/styles/app_text_styles.dart';
import '../../../features/app/app_notifier.dart';

/// [ARCH: PRESENTATION_WIDGET]
/// ROLE: Dashboard body for [IslandBar] — lightweight placeholder until dashboard metrics exist.
class DashboardIslandBarContent extends ConsumerWidget {
  const DashboardIslandBarContent({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scheme = Theme.of(context).colorScheme;
    final settings = ref.watch(appNotifierProvider.select((s) => s.settings));
    final showTitle = settings.isIslandBarItemSelected(
      appSettingsIslandBarViewDashboard,
      'title',
    );
    final showSubtitle = settings.isIslandBarItemSelected(
      appSettingsIslandBarViewDashboard,
      'subtitle',
    );

    return Row(
      children: [
        Icon(AppIcons.emptyState, color: scheme.onSurfaceVariant, size: 28),
        const SizedBox(width: 12),
        Expanded(
          child: showTitle
              ? Text(
                  context.l10n.dashboardTitle,
                  style: AppTextStyles.titleMedium.copyWith(
                    color: scheme.onSurface,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                )
              : const SizedBox.shrink(),
        ),
        if (showSubtitle)
          Text(
            context.l10n.dashboardOverview,
            style: AppTextStyles.labelMedium.copyWith(
              color: scheme.onSurfaceVariant,
            ),
          ),
      ],
    );
  }
}
