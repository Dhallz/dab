import 'package:flutter/material.dart';

import '../widgets/explorer_activity_list.dart';
import '../widgets/explorer_island_bar_content.dart';
import '../widgets/explorer_sidebar/explorer_sidebar.dart';

/// Desktop explorer shell — does not subscribe to [explorerNotifierProvider];
/// rebuild scope lives in [ExplorerSidebar], [ExplorerIslandBarContent], and
/// [ExplorerActivityList].
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
              const Expanded(
                child: ExplorerActivityList(
                  padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  emptyIconSize: 64,
                  emptySpacing: 24,
                  emptyFontSize: 16,
                  emptyMessage: 'No activities found for this date.',
                  stackSpacing: 32,
                  itemSpacing: 16,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
