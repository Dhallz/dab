import 'package:flutter/material.dart';

import '../../../core/app_bloc_consumer.dart';
import '../dashboard_bloc.dart';
import '../dashboard_state.dart';

class DashboardViewMobile extends StatelessWidget {
  const DashboardViewMobile({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBlocConsumer<DashboardBloc, DashboardState>(
      listener: (context, state, bloc) {},
      builder: (context, state, bloc) {
        return Scaffold(
          backgroundColor: Colors.transparent,
          body: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.dashboard_customize_rounded,
                  size: 64,
                  color: const Color(0xFF94A3B8).withOpacity(0.3),
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
                    color: const Color(0xFF94A3B8).withOpacity(0.8),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
