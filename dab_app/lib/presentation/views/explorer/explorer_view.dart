import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../features/auth/auth_cubit.dart';
import '../../../../services/service_locator.dart';
import 'explorer_bloc.dart';
import 'explorer_event.dart';
import 'layouts/explorer_view_desktop.dart';
import 'layouts/explorer_view_mobile.dart';

class ExplorerView extends StatelessWidget {
  const ExplorerView({super.key});

  @override
  Widget build(BuildContext context) {
    final connectedUserId = context.read<AuthCubit>().state.user?.id;
    return BlocProvider(
      create: (context) => ExplorerBloc(
        sl.activityUseCases,
        sl.userUseCases,
        sl.metadataUseCases,
      )..add(ExplorerStarted(connectedUserId: connectedUserId)),
      child: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth > 900) {
            return const ExplorerViewDesktop();
          }
          return const ExplorerViewMobile();
        },
      ),
    );
  }
}
