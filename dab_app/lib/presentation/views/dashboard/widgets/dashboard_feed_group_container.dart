import 'package:flutter/material.dart';

import '../../../../domain/entities/activity/activity.dart';
import '../../../../domain/entities/activity/activity_category.dart';
import '../../../core/extensions/activity_category_l10n.dart';
import '../../../core/localization/l10n_extension.dart';
import '../../../core/styles/app_icons.dart';
import '../../../core/styles/app_layout.dart';
import '../../../core/styles/app_spacing.dart';
import '../../../core/styles/provider_icon_resolver.dart';
import '../../../core/widgets/dab_glass_surface.dart';
import '../models/dashboard_feed_group.dart';
import '../models/dashboard_watching_placeholder.dart';
import 'dashboard_activity_card.dart';

/// [ARCH: PRESENTATION_WIDGET]
/// ROLE: One Dashboard-style glass container for a category or provider group.
class DashboardFeedGroupContainer extends StatelessWidget {
  final DashboardFeedGroup group;
  final void Function(Activity activity)? onArchive;
  final void Function(Activity activity)? onUnarchive;
  final bool Function(Activity activity)? isFollowing;
  final void Function(Activity activity)? onFollow;
  final void Function(Activity activity)? onUnfollow;
  final bool compact;

  const DashboardFeedGroupContainer({
    super.key,
    required this.group,
    this.onArchive,
    this.onUnarchive,
    this.isFollowing,
    this.onFollow,
    this.onUnfollow,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final l10n = context.l10n;
    final title = group.category?.filterLabel(l10n) ?? group.providerName ?? '';
    final count = group.activities.length;

    return DabGlassSurface(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.s,
        AppSpacing.s,
        AppSpacing.s,
        AppSpacing.xs,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Icon(
                _headerIcon(context),
                size: AppLayout.iconSmall,
                color: _headerColor(context),
              ),
              const SizedBox(width: AppSpacing.xs),
              Expanded(
                child: Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: scheme.onSurface,
                  ),
                ),
              ),
              Text(
                '$count',
                style: theme.textTheme.labelLarge?.copyWith(
                  color: scheme.onSurfaceVariant,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.s),
          if (group.isEmpty)
            Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.s),
              child: Text(
                l10n.dashboardGroupEmptyQuiet,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: scheme.onSurfaceVariant,
                ),
              ),
            )
          else
            for (final activity in group.activities)
              DashboardActivityCard(
                activity: activity,
                onArchive:
                    activity.archived ||
                        isDashboardWatchingPlaceholder(activity)
                    ? null
                    : () => onArchive?.call(activity),
                onUnarchive: activity.archived
                    ? () => onUnarchive?.call(activity)
                    : null,
                isFollowing: isFollowing?.call(activity) ?? false,
                onFollow: () => onFollow?.call(activity),
                onUnfollow: () => onUnfollow?.call(activity),
                compact: compact,
              ),
        ],
      ),
    );
  }

  IconData _headerIcon(BuildContext context) {
    final category = group.category;
    if (category != null) {
      return switch (category) {
        ActivityCategory.commit => AppIcons.commit,
        ActivityCategory.revision => AppIcons.revision,
        ActivityCategory.task => AppIcons.task,
        ActivityCategory.message => AppIcons.chatMessage,
        ActivityCategory.generic => AppIcons.genericActivity,
      };
    }
    return ProviderIconResolver.resolveFallbackIcon(
      context,
      group.providerName ?? group.key,
    );
  }

  Color _headerColor(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    if (group.category != null) return scheme.primary;
    return ProviderIconResolver.resolveBrandColor(
      context,
      group.providerName ?? group.key,
    );
  }
}
