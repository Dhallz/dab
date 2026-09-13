import 'package:flutter/material.dart';

import '../widgets/dashboard_island_bar_content.dart';
import '../widgets/dashboard_live_feed_scope/dashboard_live_feed_scope.dart';

class DashboardViewMobile extends StatelessWidget {
  const DashboardViewMobile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const DashboardIslandBarContent(),
          const Expanded(
            child: DashboardLiveFeedScope(
              axis: Axis.vertical,
              padding: EdgeInsets.all(16),
            ),
          ),
        ],
      ),
    );
  }
}
