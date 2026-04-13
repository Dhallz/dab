import 'package:flutter/material.dart';

import '../../../../core/app_bloc_consumer.dart';
import '../../../../core/widgets/app_sidebar.dart';
import '../../explorer_bloc.dart';
import '../../explorer_state.dart';
import 'directory_list.dart';
import 'directory_toggle.dart';

class ExplorerSidebar extends StatelessWidget {
  const ExplorerSidebar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBlocConsumer<ExplorerBloc, ExplorerState>(
      listenWhen: (previous, current) => false,
      listener: (context, state, bloc) {},
      builder: (context, state, _) {
        return AppSidebar(
          children: [
            DirectoryToggle(directoryType: state.directoryType),
            const SizedBox(height: 24),
            Expanded(child: DirectoryList(state: state)),
          ],
        );
      },
    );
  }
}
