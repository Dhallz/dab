import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../domain/entities/activity/activity.dart';
import '../../../core/localization/app_localizations.dart';
import '../../../core/localization/l10n_extension.dart';
import '../../../core/models/view_status.dart';
import '../../../core/styles/app_colors.dart';
import '../../../core/styles/app_icons.dart';
import '../dashboard_notifier.dart';
import '../dashboard_state.dart';
import 'dab_activity_card.dart';
import 'dashboard_archive_toggle.dart';
import 'dashboard_banner_widget.dart';
import 'upcoming_soon_section.dart';

/// [ARCH: PRESENTATION_WIDGET]
/// ROLE: Renders the dashboard body as a feed:
/// Upcoming Soon -> Awaiting Your Reply -> Live Now.
/// Dispatches archive/unarchive/toggle actions to [DashboardNotifier].
class DashboardLiveFeed extends ConsumerWidget {
  final DashboardState state;
  final EdgeInsetsGeometry padding;

  const DashboardLiveFeed({
    super.key,
    required this.state,
    this.padding = const EdgeInsets.all(20),
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (state.status == ViewStatus.loading && state.activities.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    final notifier = ref.read(dashboardNotifierProvider.notifier);
    final theme = Theme.of(context);
    final l10n = context.l10n;
    final visibleActivities = state.visibleActivities;
    final sections = _ActivitySections.from(visibleActivities);

    return ListView(
      padding: padding,
      children: [
        _SyncPill(lastSyncedAt: state.lastSyncedAt, l10n: l10n),
        const SizedBox(height: 10),
        if (state.reconnectNoticeAt != null) ...[
          _ReconnectNoticeBanner(
            at: state.reconnectNoticeAt!,
            l10n: l10n,
          ),
          const SizedBox(height: 10),
        ],
        if (state.activeBanner != null) ...[
          DashboardBannerWidget(
            banner: state.activeBanner!,
            onDismiss: notifier.dismissBanner,
          ),
          const SizedBox(height: 12),
        ],
        UpcomingSoonSection(events: state.upcomingEvents),
        const SizedBox(height: 16),
        _SectionHeader(
          title: l10n.dashboardAwaitingReplyTitle,
          subtitle: l10n.dashboardAwaitingReplySubtitle,
        ),
        const SizedBox(height: 8),
        if (sections.awaitingReply.isEmpty)
          _EmptySectionPlaceholder(
            icon: AppIcons.history,
            message: l10n.dashboardNoReplyThreads,
          )
        else
          ...sections.awaitingReply.map(
            (activity) => DabActivityCard(
              activity: activity,
              onArchive: activity.archived
                  ? null
                  : () => notifier.requestArchive(activity.id),
              onUnarchive: activity.archived
                  ? () => notifier.requestUnarchive(activity.id)
                  : null,
            ),
          ),
        const SizedBox(height: 16),
        Row(
          children: [
            Text(
              l10n.dashboardLiveNowTitle,
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
                letterSpacing: 0.6,
                color: AppColors.onSurfaceVariant,
              ),
            ),
            const Spacer(),
            DashboardArchiveToggle(
              showArchived: state.showArchivedActivities,
              archivedCount: state.archivedCount,
              onToggle: notifier.toggleArchivedVisibility,
            ),
          ],
        ),
        const SizedBox(height: 8),
        if (state.status == ViewStatus.failure && state.activities.isEmpty)
          _FailurePlaceholder(
            message: state.errorMessage,
            fallbackMessage: l10n.dashboardFailedLoadLive,
          )
        else if (sections.liveNow.isEmpty)
          _EmptyLivePlaceholder(
            showingArchived: state.showArchivedActivities,
            hasAnyActivities: state.activities.isNotEmpty,
            l10n: l10n,
          )
        else
          ...sections.liveNow.map(
            (activity) => DabActivityCard(
              activity: activity,
              onArchive: activity.archived
                  ? null
                  : () => notifier.requestArchive(activity.id),
              onUnarchive: activity.archived
                  ? () => notifier.requestUnarchive(activity.id)
                  : null,
            ),
          ),
      ],
    );
  }
}

class _SyncPill extends StatelessWidget {
  final DateTime? lastSyncedAt;
  final AppLocalizations l10n;

  const _SyncPill({required this.lastSyncedAt, required this.l10n});

  @override
  Widget build(BuildContext context) {
    if (lastSyncedAt == null) {
      return const SizedBox.shrink();
    }
    final now = DateTime.now();
    final elapsed = now.difference(lastSyncedAt!);
    final label = elapsed.inSeconds < 60
        ? l10n.commonTimeAgoSeconds(elapsed.inSeconds)
        : l10n.commonTimeAgoMinutes(elapsed.inMinutes);
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: AppColors.onSurface.withValues(alpha: 0.06),
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: AppColors.onSurface.withValues(alpha: 0.1)),
        ),
        child: Text(
          l10n.dashboardLiveUpdated(label),
          style: theme(
            context,
          ).textTheme.labelSmall?.copyWith(color: AppColors.onSurfaceVariant),
        ),
      ),
    );
  }

  ThemeData theme(BuildContext context) => Theme.of(context);
}

class _ReconnectNoticeBanner extends StatelessWidget {
  final DateTime at;
  final AppLocalizations l10n;

  const _ReconnectNoticeBanner({required this.at, required this.l10n});

  @override
  Widget build(BuildContext context) {
    final hh = at.hour.toString().padLeft(2, '0');
    final mm = at.minute.toString().padLeft(2, '0');
    final ss = at.second.toString().padLeft(2, '0');
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.onSurface.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.onSurface.withValues(alpha: 0.12)),
      ),
      child: Text(
        l10n.dashboardReconnectNotice('$hh:$mm:$ss'),
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
          color: AppColors.onSurfaceVariant,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final String subtitle;

  const _SectionHeader({required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.bold,
            letterSpacing: 0.6,
            color: AppColors.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          subtitle,
          style: theme.textTheme.bodySmall?.copyWith(
            color: AppColors.onSurfaceVariantLow,
          ),
        ),
      ],
    );
  }
}

class _EmptySectionPlaceholder extends StatelessWidget {
  final IconData icon;
  final String message;

  const _EmptySectionPlaceholder({required this.icon, required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.onSurface.withValues(alpha: 0.04),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.onSurface.withValues(alpha: 0.08)),
      ),
      child: Row(
        children: [
          Icon(icon, size: 16, color: AppColors.onSurfaceVariantLow),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              message,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColors.onSurfaceVariant,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FailurePlaceholder extends StatelessWidget {
  final String? message;
  final String fallbackMessage;

  const _FailurePlaceholder({
    this.message,
    required this.fallbackMessage,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 24),
        child: Text(
          message ?? fallbackMessage,
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: AppColors.onSurfaceVariant),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

class _ActivitySections {
  final List<Activity> awaitingReply;
  final List<Activity> liveNow;

  const _ActivitySections({required this.awaitingReply, required this.liveNow});

  factory _ActivitySections.from(List<Activity> activities) {
    final awaitingReply = <Activity>[];
    final liveNow = <Activity>[];

    for (final activity in activities) {
      if (_isAwaitingReply(activity)) {
        awaitingReply.add(activity);
      } else {
        liveNow.add(activity);
      }
    }

    return _ActivitySections(awaitingReply: awaitingReply, liveNow: liveNow);
  }

  static final _followUpKeywords = <String>{
    'reply',
    'follow-up',
    'follow up',
    'any update',
    'ping',
    'reminder',
  };

  static bool _isAwaitingReply(Activity activity) {
    final provider = activity.provider;
    if (provider is SlackMessageProvider) {
      if (provider.threadTs != null) return true;
    }
    final haystack = '${activity.title} ${activity.content}'.toLowerCase();
    if (_followUpKeywords.any(haystack.contains)) return true;
    return haystack.endsWith('?');
  }
}

class _EmptyLivePlaceholder extends StatelessWidget {
  final bool showingArchived;
  final bool hasAnyActivities;
  final AppLocalizations l10n;

  const _EmptyLivePlaceholder({
    required this.showingArchived,
    required this.hasAnyActivities,
    required this.l10n,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final message = (!showingArchived && hasAnyActivities)
        ? l10n.dashboardEmptyLiveCaughtUp
        : l10n.dashboardEmptyLiveNoActivities;
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              AppIcons.emptyState,
              size: 48,
              color: AppColors.onSurfaceVariantLow.withValues(alpha: 0.5),
            ),
            const SizedBox(height: 12),
            Text(
              message,
              textAlign: TextAlign.center,
              style: theme.textTheme.titleMedium?.copyWith(
                color: AppColors.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
