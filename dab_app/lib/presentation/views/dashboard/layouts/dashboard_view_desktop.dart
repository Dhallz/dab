import 'package:dab_app/presentation/core/widgets/app_sidebar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/widgets/island_bar.dart';
import '../dashboard_notifier.dart';
import '../widgets/dashboard_island_bar_content.dart';
import '../widgets/dashboard_live_feed_scope.dart';
import '../widgets/dashboard_sidebar_content.dart';

/// [ARCH: PRESENTATION_LAYOUT]
/// ROLE: Desktop rendering of the Activity Dashboard.
/// CONTRACT: Two-column shell — [AppSidebar] plus main column with [IslandBar]
/// and [DashboardLiveFeed]. Sidebar children are populated when dashboard
/// chrome (e.g. shortcuts, filters) is defined.
class DashboardViewDesktop extends StatelessWidget {
  const DashboardViewDesktop({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppSidebar(
            children: const [Expanded(child: _DashboardSidebarPane())],
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const IslandBar(content: DashboardIslandBarContent()),
                const Expanded(
                  child: DashboardLiveFeedScope(
                    padding: EdgeInsets.symmetric(horizontal: 28, vertical: 20),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Sidebar metrics — avoids rebuilding when only the main feed slice changes.
class _DashboardSidebarPane extends ConsumerWidget {
  const _DashboardSidebarPane();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(
      dashboardNotifierProvider.select(
        (s) => (
          providerHealth: s.providerHealth,
          snoozedCount: s.snoozedCount,
          reviewQueueCount: s.reviewQueueCount,
          lastSyncedAt: s.lastSyncedAt,
        ),
      ),
    );
    final state = ref.read(dashboardNotifierProvider);
    return DashboardSidebarContent(state: state);
  }
}
