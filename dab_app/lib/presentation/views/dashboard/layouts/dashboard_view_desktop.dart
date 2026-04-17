import 'package:dab_app/presentation/core/app_bloc_consumer.dart';
import 'package:dab_app/presentation/core/widgets/app_sidebar.dart';
import 'package:flutter/material.dart';

import '../../../core/widgets/island_bar.dart';
import '../widgets/dashboard_island_bar_content.dart';
import '../widgets/dashboard_live_feed.dart';
import '../dashboard_bloc.dart';
import '../dashboard_state.dart';

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
              const AppSidebar(children: []),
              Expanded(
                child: Column(
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
