import 'package:dab_app/presentation/core/app_bloc_consumer.dart';
import 'package:dab_app/presentation/core/widgets/app_sidebar.dart';
import 'package:flutter/material.dart';

import '../../../core/widgets/island_bar.dart';
import '../widgets/dashboard_island_bar_content.dart';
import '../widgets/dashboard_live_feed.dart';
import '../widgets/dashboard_sidebar_content.dart';
import '../dashboard_bloc.dart';
import '../dashboard_state.dart';

/// [ARCH: PRESENTATION_LAYOUT]
/// ROLE: Desktop rendering of the Activity Dashboard.
/// CONTRACT: Two-column shell — [AppSidebar] plus main column with [IslandBar]
/// and [DashboardLiveFeed]. Sidebar children are populated when dashboard
/// chrome (e.g. shortcuts, filters) is defined.
class DashboardViewDesktop extends StatelessWidget {
  const DashboardViewDesktop({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBlocConsumer<DashboardBloc, DashboardState>(
      listener: (context, state, bloc) {},
      builder: (context, state, bloc) {
        return Scaffold(
          backgroundColor: Colors.transparent,
          body: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AppSidebar(
                children: [
                  Expanded(child: DashboardSidebarContent(state: state)),
                ],
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const IslandBar(content: DashboardIslandBarContent()),
                    Expanded(
                      child: DashboardLiveFeed(
                        state: state,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 28,
                          vertical: 20,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
