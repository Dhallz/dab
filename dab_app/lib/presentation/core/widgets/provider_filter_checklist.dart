import 'package:flutter/material.dart';

import '../styles/app_spacing.dart';
import '../styles/provider_icon_resolver.dart';
import 'selection_tile.dart';

/// [ARCH: PRESENTATION_CORE]
/// ROLE: Multi-select provider tiles for filter sidebars.
class ProviderFilterChecklist extends StatelessWidget {
  final List<String> availableProviders;
  final Set<String> selectedProviders;
  final ValueChanged<String> onToggle;

  const ProviderFilterChecklist({
    super.key,
    required this.availableProviders,
    required this.selectedProviders,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    if (availableProviders.isEmpty) {
      return const SizedBox.shrink();
    }
    return Column(
      children: [
        for (final provider in availableProviders)
          Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.xs),
            child: SelectionTile(
              label: provider,
              isSelected: selectedProviders.contains(provider),
              iconData: ProviderIconResolver.resolveFallbackIcon(
                context,
                provider,
              ),
              onTap: () => onToggle(provider),
            ),
          ),
      ],
    );
  }
}
