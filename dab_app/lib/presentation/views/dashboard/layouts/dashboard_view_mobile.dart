import 'package:flutter/material.dart';

import '../../../core/app_bloc_consumer.dart';
import '../../../core/widgets/island_bar.dart';
import '../dashboard_bloc.dart';
import '../dashboard_state.dart';
import '../widgets/dashboard_island_bar_content.dart';
import '../widgets/dashboard_live_feed.dart';

class DashboardViewMobile extends StatelessWidget {
  const DashboardViewMobile({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBlocConsumer<DashboardBloc, DashboardState>(
      listener: (context, state, bloc) {},
      builder: (context, state, bloc) {
        return Scaffold(
          backgroundColor: Colors.transparent,
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const IslandBar(content: DashboardIslandBarContent()),
              Expanded(
                child: DashboardLiveFeed(
                  state: state,
                  padding: const EdgeInsets.all(16),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
