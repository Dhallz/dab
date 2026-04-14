import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/styles/app_spacing.dart';
import '../../../../core/styles/provider_icon_resolver.dart';
import '../../explorer_bloc.dart';
import '../../explorer_event.dart';
import 'selection_tile.dart';

class ProviderFilterChecklist extends StatelessWidget {
  final List<String> availableProviders;
  final Set<String> selectedProviders;

  const ProviderFilterChecklist({
    super.key,
    required this.availableProviders,
    required this.selectedProviders,
  });

  @override
  Widget build(BuildContext context) {
    if (availableProviders.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      children: availableProviders.map((provider) {
        return Padding(
          padding: const EdgeInsets.only(bottom: AppSpacing.xs),
          child: SelectionTile(
            label: provider,
            isSelected: selectedProviders.contains(provider),
            iconData: ProviderIconResolver.resolveFallbackIcon(
              context,
              provider,
            ),
            onTap: () => context.read<ExplorerBloc>().add(
              ExplorerProviderToggled(provider),
            ),
          ),
        );
      }).toList(),
    );
  }
}
