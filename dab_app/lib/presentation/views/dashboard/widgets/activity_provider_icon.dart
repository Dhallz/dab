import 'package:flutter/material.dart';
import '../../../../domain/entities/activity/activity.dart';
import '../../../../domain/entities/activity/activity_category.dart';
import '../../../../presentation/core/extensions/activity_provider_extensions.dart';

/// [ARCH: PRESENTATION_WIDGET]
/// ROLE: Circular icon representing the provider and category of an activity.
class ActivityProviderIcon extends StatelessWidget {
  final Activity activity;
  final Color color;

  const ActivityProviderIcon({
    super.key,
    required this.activity,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        shape: BoxShape.circle,
        border: Border.all(color: color.withValues(alpha: 0.2), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.1),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Icon(
        _getIconForType() ?? activity.provider.icon(context),
        color: color,
        size: 22,
      ),
    );
  }

  IconData? _getIconForType() {
    switch (activity.provider.category) {
      case ActivityCategory.commit:
        return Icons.terminal_rounded;
      case ActivityCategory.revision:
        return Icons.code_rounded;
      case ActivityCategory.task:
        return Icons.task_alt_rounded;
      case ActivityCategory.message:
        return Icons.chat_bubble_outline_rounded;
      case ActivityCategory.generic:
        return null; // Will fallback to the default provider icon
    }
  }
}
