import 'package:dab_app/presentation/core/widgets/app_sidebar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../dashboard_notifier.dart';
import '../widgets/dashboard_island_bar_content.dart';
import '../widgets/dashboard_live_feed_scope.dart';
import '../widgets/dashboard_sidebar_content.dart';

/// [ARCH: PRESENTATION_LAYOUT]
/// ROLE: Desktop rendering of the Activity Dashboard.
/// CONTRACT: Two-column shell — [AppSidebar] plus main column with toolbar
/// and two always-visible inbox panes ([DashboardLiveFeedScope]).
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
                const DashboardIslandBarContent(showCounts: false),
                const Expanded(
                  child: DashboardLiveFeedScope(
                    axis: Axis.horizontal,
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
          activities: s.activities,
          showArchived: s.showArchivedActivities,
          follows: s.follows,
        ),
      ),
    );
    final state = ref.read(dashboardNotifierProvider);
    return DashboardSidebarContent(state: state);
  }
}
