import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/extensions/activity_extensions.dart';
import '../../../core/styles/app_icons.dart';
import '../explorer_notifier.dart';
import '../explorer_state.dart';
import '../models/explorer_item.dart';
import 'activity_card/activity_card.dart';

/// [ARCH: PRESENTATION_WIDGET]
/// ROLE: Explorer activity feed with a top linear loader while providers fetch.
/// CONTRACT: Paints [ExplorerState.items] as they arrive; does not hide the list
/// while [OnExplorerState.isFetchingProviders] is true.
class ExplorerActivityList extends ConsumerWidget {
  final EdgeInsetsGeometry padding;
  final double emptyIconSize;
  final double emptySpacing;
  final double emptyFontSize;
  final String emptyMessage;
  final double stackSpacing;
  final double itemSpacing;

  const ExplorerActivityList({
    super.key,
    required this.padding,
    required this.emptyIconSize,
    required this.emptySpacing,
    required this.emptyFontSize,
    required this.emptyMessage,
    required this.stackSpacing,
    required this.itemSpacing,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pane = ref.watch(
      explorerNotifierProvider.select(
        (s) =>
            (items: s.items, users: s.users, isFetching: s.isFetchingProviders),
      ),
    );

    final userNameById = {for (final user in pane.users) user.id: user.name};
    final cs = Theme.of(context).colorScheme;

    final body = !pane.isFetching && pane.items.isEmpty
        ? Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  AppIcons.history,
                  size: emptyIconSize,
                  color: cs.onSurfaceVariant.withValues(alpha: 0.35),
                ),
                SizedBox(height: emptySpacing),
                Text(
                  emptyMessage,
                  style: TextStyle(
                    fontSize: emptyFontSize,
                    color: cs.onSurfaceVariant.withValues(alpha: 0.85),
                  ),
                ),
              ],
            ),
          )
        : ListView.builder(
            clipBehavior: Clip.hardEdge,
            padding: padding,
            itemCount: pane.items.length,
            itemBuilder: (context, index) {
              final item = pane.items[index];
              final isStack =
                  (item is TaskActivityItem && !item.isExpanded) ||
                  (item is SlackConversationItem && !item.isExpanded);
              return Padding(
                padding: EdgeInsets.only(
                  bottom: isStack ? stackSpacing : itemSpacing,
                ),
                child: switch (item) {
                  SingleActivityItem(:final activity) => ActivityCard(
                    activity: activity,
                    resolvedAuthorName: activity.senderDisplayName(
                      userNameById,
                    ),
                  ),
                  TaskActivityItem(:final activities) => ActivityCard(
                    activity: item.latestActivity,
                    activities: activities,
                    resolvedAuthorName: item.latestActivity.senderDisplayName(
                      userNameById,
                    ),
                  ),
                  SlackConversationItem(:final activities) => ActivityCard(
                    activity: item.latestActivity,
                    activities: activities,
                    resolvedAuthorName: item.latestActivity.senderDisplayName(
                      userNameById,
                    ),
                  ),
                },
              );
            },
          );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (pane.isFetching) const LinearProgressIndicator(minHeight: 2),
        Expanded(child: body),
      ],
    );
  }
}
