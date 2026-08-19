import 'package:flutter/material.dart';

import '../widgets/explorer_activity_list.dart';
import '../widgets/explorer_island_bar_content.dart';

/// Mobile explorer shell — no broad notifier watch; see [ExplorerActivityList].
class ExplorerViewMobile extends StatelessWidget {
  const ExplorerViewMobile({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ExplorerIslandBarContent(),
        Expanded(
          child: ExplorerActivityList(
            padding: EdgeInsets.symmetric(horizontal: 16),
            emptyIconSize: 48,
            emptySpacing: 16,
            emptyFontSize: 14,
            emptyMessage: 'No activities found.',
            stackSpacing: 24,
            itemSpacing: 12,
          ),
        ),
      ],
    );
  }
}
