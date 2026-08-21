import 'package:flutter/material.dart';

/// [ARCH: PRESENTATION_WIDGET]
/// ROLE: Centered error copy when a dashboard inbox fails to load.
class DashboardFailurePlaceholder extends StatelessWidget {
  final String? message;
  final String fallbackMessage;

  const DashboardFailurePlaceholder({
    super.key,
    this.message,
    required this.fallbackMessage,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 24),
        child: Text(
          message ?? fallbackMessage,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
