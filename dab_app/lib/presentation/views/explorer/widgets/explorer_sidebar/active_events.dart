import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/styles/app_colors.dart';
import '../../explorer_notifier.dart';
import 'event_chip.dart';

class ActiveEvents extends ConsumerWidget {
  final List<String> availableProviders;
  final Set<String> selectedProviders;

  const ActiveEvents({
    super.key,
    required this.availableProviders,
    required this.selectedProviders,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (availableProviders.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'ACTIVITY PROVIDERS',
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.bold,
            color: AppColors.outlineVariant,
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: availableProviders.map((provider) {
            final isSelected = selectedProviders.contains(provider);
            return EventChip(
              provider: provider,
              isSelected: isSelected,
              onTap: () {
                ref
                    .read(explorerNotifierProvider.notifier)
                    .toggleProvider(provider);
              },
            );
          }).toList(),
        ),
      ],
    );
  }
}
