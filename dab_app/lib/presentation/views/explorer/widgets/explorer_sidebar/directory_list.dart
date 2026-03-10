import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../explorer_bloc.dart';
import '../../explorer_event.dart';
import '../../explorer_state.dart';
import 'create_group_button.dart';
import 'selection_tile.dart';

class DirectoryList extends StatelessWidget {
  final ExplorerState state;

  const DirectoryList({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    final bool isUsers = state.directoryType == DirectoryType.users;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (isUsers)
            ...state.users.map((u) {
              final isSelected = state.selectedUserIds.contains(u.id);
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: SelectionTile(
                  label: u.name,
                  isSelected: isSelected,
                  avatarUrl: u.avatarUrl,
                  iconData: u.avatarUrl == null ? Icons.person_rounded : null,
                  onTap: () => context.read<ExplorerBloc>().add(
                    ExplorerUserToggled(u.id),
                  ),
                ),
              );
            })
          else
            ...state.groups.map((g) {
              final isSelected = state.selectedGroupIds.contains(g.id);
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: SelectionTile(
                  label: g.name,
                  isSelected: isSelected,
                  iconData: Icons.group_rounded,
                  onTap: () => context.read<ExplorerBloc>().add(
                    ExplorerGroupToggled(g.id),
                  ),
                ),
              );
            }),
          if (!isUsers) ...[
            const SizedBox(height: 8),
            CreateGroupButton(availableUsers: state.users),
          ],
        ],
      ),
    );
  }
}
