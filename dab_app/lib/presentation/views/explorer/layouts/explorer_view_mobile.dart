import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/models/view_status.dart';
import '../../../core/styles/app_colors.dart';
import '../../../core/styles/app_icons.dart';
import '../explorer_notifier.dart';
import '../models/explorer_item.dart';
import '../widgets/activity_card/activity_card.dart';
import '../widgets/explorer_island_bar_content.dart';

/// Mobile explorer shell — no broad notifier watch; see [_ExplorerMobileActivityPane].
class ExplorerViewMobile extends StatelessWidget {
  const ExplorerViewMobile({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const ExplorerIslandBarContent(),
        const Expanded(child: _ExplorerMobileActivityPane()),
      ],
    );
  }
}

class _ExplorerMobileActivityPane extends ConsumerWidget {
  const _ExplorerMobileActivityPane();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pane = ref.watch(
      explorerNotifierProvider.select(
        (s) => (status: s.status, items: s.items, users: s.users),
      ),
    );

    final userNameById = {for (final user in pane.users) user.id: user.name};
    return pane.status == ViewStatus.loading
        ? const Center(child: CircularProgressIndicator())
        : pane.items.isEmpty
        ? Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                AppIcons.history,
                size: 48,
                color: AppColors.onSurfaceVariantLow.withValues(alpha: 0.3),
              ),
              const SizedBox(height: 16),
              Text(
                'No activities found.',
                style: TextStyle(
                  fontSize: 14,
                  color: const Color(0xFF94A3B8).withValues(alpha: 0.8),
                ),
              ),
            ],
          )
        : ListView.builder(
            clipBehavior: Clip.hardEdge,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: pane.items.length,
            itemBuilder: (context, index) {
              final item = pane.items[index];
              final isStack =
                  (item is TaskActivityItem && !item.isExpanded) ||
                  (item is SlackConversationItem && !item.isExpanded);
              return Padding(
                padding: EdgeInsets.only(bottom: isStack ? 24 : 12),
                child: switch (item) {
                  SingleActivityItem(:final activity) => ActivityCard(
                    activity: activity,
                    resolvedAuthorName: userNameById[activity.userId],
                  ),
                  TaskActivityItem(:final activities) => ActivityCard(
                    activity: item.latestActivity,
                    activities: activities,
                    resolvedAuthorName:
                        userNameById[item.latestActivity.userId],
                  ),
                  SlackConversationItem(:final activities) => ActivityCard(
                    activity: item.latestActivity,
                    activities: activities,
                    resolvedAuthorName:
                        userNameById[item.latestActivity.userId],
                  ),
                },
              );
            },
          );
  }
}
