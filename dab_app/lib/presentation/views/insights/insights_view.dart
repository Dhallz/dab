import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../services/service_locator.dart';
import '../../features/auth/auth_cubit.dart';
import 'insights_bloc.dart';
import 'insights_event.dart';
import 'layouts/insights_view_desktop.dart';
import 'layouts/insights_view_mobile.dart';

class InsightsView extends StatelessWidget {
  const InsightsView({super.key});

  @override
  Widget build(BuildContext context) {
    final connectedUserId = context.read<AuthCubit>().state.user?.id;
    return BlocProvider(
      create: (context) => InsightsBloc(
        sl.activityUseCases,
        sl.userUseCases,
        sl.metadataUseCases,
      )..add(InsightsStarted(connectedUserId: connectedUserId)),
      child: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth > 900) {
            return const InsightsViewDesktop();
          }
          return const InsightsViewMobile();
        },
      ),
    );
  }
}
