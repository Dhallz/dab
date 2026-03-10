import 'dart:ui';

import 'package:flutter/material.dart';

class EventChip extends StatelessWidget {
  final String provider;
  final bool isSelected;
  final VoidCallback onTap;

  const EventChip({
    super.key,
    required this.provider,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorMap = {
      'GitHub': Colors.blue,
      'Phorge': Colors.purple,
      'Slack': Colors.green,
      'Jira': Colors.blueAccent,
    };

    final color = colorMap[provider] ?? Colors.grey;

    final displayColor = HSLColor.fromColor(
      color,
    ).withSaturation(isSelected ? 0.3 : 0.15).withLightness(0.5).toColor();

    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(100),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(100),
              border: Border.all(
                color: isSelected
                    ? displayColor.withValues(alpha: 0.6)
                    : displayColor.withValues(alpha: 0.2),
                width: 1,
              ),
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: displayColor.withValues(alpha: 0.1),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ]
                  : [],
            ),
            child: Text(
              provider.toUpperCase(),
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: isSelected
                    ? displayColor
                    : displayColor.withValues(alpha: 0.6),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
