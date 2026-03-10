import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/widgets/app_sidebar.dart';
import '../../explorer_bloc.dart';
import '../../explorer_state.dart';
import 'active_events.dart';
import 'directory_list.dart';
import 'directory_toggle.dart';

class ExplorerSidebar extends StatelessWidget {
  const ExplorerSidebar({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ExplorerBloc, ExplorerState>(
      builder: (context, state) {
        return AppSidebar(
          children: [
            DirectoryToggle(directoryType: state.directoryType),
            const SizedBox(height: 24),
            Expanded(child: DirectoryList(state: state)),
            const SizedBox(height: 16),
            ActiveEvents(
              availableProviders: state.availableProviders,
              selectedProviders: state.selectedProviders,
            ),
          ],
        );
      },
    );
  }
}
