import 'package:flutter/material.dart';

import '../../../core/styles/app_spacing.dart';
import '../widgets/dashboard_island_bar_content.dart';
import '../widgets/dashboard_live_feed_scope/dashboard_live_feed_scope.dart';

/// [ARCH: PRESENTATION_LAYOUT]
/// ROLE: Desktop rendering of the Activity Dashboard.
/// CONTRACT: Toolbar plus two always-visible inbox panes
/// ([DashboardLiveFeedScope]). Body side gutters are [AppSpacing.xxxl] (64).
class DashboardViewDesktop extends StatelessWidget {
  const DashboardViewDesktop({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.transparent,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: AppSpacing.xxxl,
              vertical: 20,
            ),
            child: DashboardIslandBarContent(),
          ),
          Expanded(
            child: DashboardLiveFeedScope(
              axis: Axis.horizontal,
              padding: EdgeInsets.symmetric(
                horizontal: AppSpacing.xxxl,
                vertical: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
