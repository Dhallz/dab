import 'package:flutter/material.dart';

import '../../../core/app_bloc_consumer.dart';
import '../../../core/models/view_status.dart';
import '../../../core/styles/app_colors.dart';
import '../../../core/styles/app_icons.dart';
import '../explorer_bloc.dart';
import '../explorer_item.dart';
import '../explorer_state.dart';
import '../widgets/activity_card/activity_card.dart';
import '../widgets/explorer_island_bar_content.dart';
import '../widgets/explorer_sidebar/explorer_sidebar.dart';

class ExplorerViewDesktop extends StatelessWidget {
  const ExplorerViewDesktop({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBlocConsumer<ExplorerBloc, ExplorerState>(
      listener: (context, state, bloc) {},
      builder: (context, state, bloc) {
        final userNameById = {
          for (final user in state.users) user.id: user.name,
        };
        return Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const ExplorerSidebar(),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const ExplorerIslandBarContent(),
                  Expanded(
                    child: state.status == ViewStatus.loading
                        ? const Center(child: CircularProgressIndicator())
                        : state.items.isEmpty
                        ? Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                AppIcons.history,
                                size: 64,
                                color: AppColors.onSurfaceVariantLow.withValues(
                                  alpha: 0.3,
                                ),
                              ),
                              const SizedBox(height: 24),
                              Text(
                                'No activities found for this date.',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: const Color(
                                    0xFF94A3B8,
                                  ).withValues(alpha: 0.8),
                                ),
                              ),
                            ],
                          )
                        : ListView.builder(
                            clipBehavior: Clip.none,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 32,
                              vertical: 16,
                            ),
                            itemCount: state.items.length,
                            itemBuilder: (context, index) {
                              final item = state.items[index];
                              final isStack =
                                  (item is TaskActivityItem &&
                                      !item.isExpanded) ||
                                  (item is SlackConversationItem &&
                                      !item.isExpanded);
                              return Padding(
                                padding: EdgeInsets.only(
                                  bottom: isStack ? 32 : 16,
                                ),
                                child: switch (item) {
                                  SingleActivityItem(:final activity) =>
                                    ActivityCard(
                                      activity: activity,
                                      resolvedAuthorName:
                                          userNameById[activity.userId],
                                    ),
                                  TaskActivityItem(:final activities) =>
                                    ActivityCard(
                                      activity: activities.first,
                                      activities: activities,
                                      resolvedAuthorName:
                                          userNameById[activities.first.userId],
                                    ),
                                  SlackConversationItem(:final activities) =>
                                    ActivityCard(
                                      activity: activities.first,
                                      activities: activities,
                                      resolvedAuthorName:
                                          userNameById[activities.first.userId],
                                    ),
                                },
                              );
                            },
                          ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
