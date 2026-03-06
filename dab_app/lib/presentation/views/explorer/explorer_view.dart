import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../services/service_locator.dart';
import 'explorer_bloc.dart';
import 'explorer_event.dart';
import 'layout/explorer_view_desktop.dart';
import 'layout/explorer_view_mobile.dart';

class ExplorerView extends StatelessWidget {
  const ExplorerView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          ExplorerBloc(sl.activityUseCases)..add(const ExplorerStarted()),
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
