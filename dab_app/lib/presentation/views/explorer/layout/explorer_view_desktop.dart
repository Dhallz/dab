import 'package:flutter/material.dart';

import '../../../core/app_bloc_consumer.dart';
import '../explorer_bloc.dart';
import '../explorer_state.dart';
import '../widgets/activity_card/activity_card.dart';
import '../widgets/explorer_calendar_bar.dart';
import '../widgets/explorer_sidebar.dart';

class ExplorerViewDesktop extends StatelessWidget {
  const ExplorerViewDesktop({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBlocConsumer<ExplorerBloc, ExplorerState>(
      listener: (context, state, bloc) {},
      builder: (context, state, bloc) {
        return Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const ExplorerSidebar(),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Padding(
                    padding: EdgeInsets.fromLTRB(32, 32, 32, 16),
                    child: ExplorerCalendarBar(),
                  ),
                  Expanded(
                    child: state.status == ExplorerStatus.loading
                        ? const Center(child: CircularProgressIndicator())
                        : state.activities.isEmpty
                        ? Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.history_rounded,
                                size: 64,
                                color: const Color(
                                  0xFF94A3B8,
                                ).withValues(alpha: 0.3),
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
                            padding: const EdgeInsets.symmetric(
                              horizontal: 32,
                              vertical: 16,
                            ),
                            itemCount: state.activities.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 16),
                                child: ActivityCard(
                                  activity: state.activities[index],
                                ),
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
