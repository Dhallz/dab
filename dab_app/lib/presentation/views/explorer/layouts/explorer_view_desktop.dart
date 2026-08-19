import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/extensions/activity_extensions.dart';
import '../../../core/models/view_status.dart';
import '../../../core/styles/app_icons.dart';
import '../explorer_notifier.dart';
import '../models/explorer_item.dart';
import '../widgets/activity_card/activity_card.dart';
import '../widgets/explorer_island_bar_content.dart';
import '../widgets/explorer_sidebar/explorer_sidebar.dart';

/// Desktop explorer shell — does not subscribe to [explorerNotifierProvider];
/// rebuild scope lives in [ExplorerSidebar], [ExplorerIslandBarContent], and
/// [_ExplorerDesktopActivityPane].
class ExplorerViewDesktop extends StatelessWidget {
  const ExplorerViewDesktop({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const ExplorerSidebar(),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const ExplorerIslandBarContent(),
              const Expanded(child: _ExplorerDesktopActivityPane()),
            ],
          ),
        ),
      ],
    );
  }
}

/// Scrollable activity list only — watches status, items, and users.
class _ExplorerDesktopActivityPane extends ConsumerWidget {
  const _ExplorerDesktopActivityPane();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pane = ref.watch(
      explorerNotifierProvider.select(
        (s) => (status: s.status, items: s.items, users: s.users),
      ),
    );

    final userNameById = {for (final user in pane.users) user.id: user.name};
    final cs = Theme.of(context).colorScheme;
    return pane.status == ViewStatus.loading
        ? const Center(child: CircularProgressIndicator())
        : pane.items.isEmpty
        ? Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                AppIcons.history,
                size: 64,
                color: cs.onSurfaceVariant.withValues(alpha: 0.35),
              ),
              const SizedBox(height: 24),
              Text(
                'No activities found for this date.',
                style: TextStyle(
                  fontSize: 16,
                  color: cs.onSurfaceVariant.withValues(alpha: 0.85),
                ),
              ),
            ],
          )
        : ListView.builder(
            clipBehavior: Clip.hardEdge,
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            itemCount: pane.items.length,
            itemBuilder: (context, index) {
              final item = pane.items[index];
              final isStack =
                  (item is TaskActivityItem && !item.isExpanded) ||
                  (item is SlackConversationItem && !item.isExpanded);
              return Padding(
                padding: EdgeInsets.only(bottom: isStack ? 32 : 16),
                child: switch (item) {
                  SingleActivityItem(:final activity) => ActivityCard(
                    activity: activity,
                    resolvedAuthorName: activity.senderDisplayName(userNameById),
                  ),
                  TaskActivityItem(:final activities) => ActivityCard(
                    activity: activities.first,
                    activities: activities,
                    resolvedAuthorName: activities.first.senderDisplayName(
                      userNameById,
                    ),
                  ),
                  SlackConversationItem(:final activities) => ActivityCard(
                    activity: activities.first,
                    activities: activities,
                    resolvedAuthorName: activities.first.senderDisplayName(
                      userNameById,
                    ),
                  ),
                },
              );
            },
          );
  }
}
