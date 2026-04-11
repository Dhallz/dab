import 'package:dab_app/presentation/core/app_bloc_consumer.dart';
import 'package:dab_app/presentation/core/widgets/app_sidebar.dart';
import 'package:flutter/material.dart';

import '../../../core/widgets/dab_app_bar.dart';
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
                    const Padding(
                      padding: EdgeInsets.fromLTRB(32, 32, 32, 16),
                      child: DabAppBar(),
                    ),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.dashboard_customize_rounded,
                            size: 64,
                            color: const Color(
                              0xFF94A3B8,
                            ).withValues(alpha: 0.3),
                          ),
                          const SizedBox(height: 24),
                          const Text(
                            'Dashboard',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFFF8FAFC),
                              letterSpacing: -0.5,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Coming soon: Live activity feed.',
                            style: TextStyle(
                              fontSize: 14,
                              color: const Color(
                                0xFF94A3B8,
                              ).withValues(alpha: 0.8),
                            ),
                          ),
                        ],
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
