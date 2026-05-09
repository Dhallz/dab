import 'package:flutter/material.dart';

import '../../../core/widgets/island_bar.dart';
import '../widgets/dashboard_island_bar_content.dart';
import '../widgets/dashboard_live_feed_scope.dart';

class DashboardViewMobile extends StatelessWidget {
  const DashboardViewMobile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const IslandBar(content: DashboardIslandBarContent()),
          const Expanded(
            child: DashboardLiveFeedScope(padding: EdgeInsets.all(16)),
          ),
        ],
      ),
    );
  }
}
