import 'package:flutter/material.dart';

import '../../../core/app_bloc_consumer.dart';
import '../../../core/models/view_status.dart';
import '../explorer_bloc.dart';
import '../explorer_item.dart';
import '../explorer_state.dart';
import '../widgets/activity_card/activity_card.dart';
import '../widgets/explorer_island_bar_content.dart';

class ExplorerViewMobile extends StatelessWidget {
  const ExplorerViewMobile({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBlocConsumer<ExplorerBloc, ExplorerState>(
      listener: (context, state, bloc) {},
      builder: (context, state, bloc) {
        final userNameById = {
          for (final user in state.users) user.id: user.name,
        };
        return Column(
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
                          Icons.history_rounded,
                          size: 48,
                          color: const Color(0xFF94A3B8).withValues(alpha: 0.3),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No activities found.',
                          style: TextStyle(
                            fontSize: 14,
                            color: const Color(
                              0xFF94A3B8,
                            ).withValues(alpha: 0.8),
                          ),
                        ),
                      ],
                    )
                  : ListView.builder(
                      clipBehavior: Clip.none,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: state.items.length,
                      itemBuilder: (context, index) {
                        final item = state.items[index];
                        final isStack =
                            item is TaskActivityItem && !item.isExpanded;
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
                          },
                        );
                      },
                    ),
            ),
          ],
        );
      },
    );
  }
}
