import 'dart:ui';
import 'package:flutter/material.dart';
import '../../../../core/styles/provider_styles.dart';
import '../../../../core/extensions/color_extensions.dart';

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
    final theme = Theme.of(context);
    final providerStyle = theme.extension<ProviderStyles>()?.styleOf(provider) ??
        ProviderStyles.dark().styleOf(provider);
    
    final color = providerStyle.brandColor.toAccessibleBrandColor;

    final displayColor = isSelected
        ? color
        : HSLColor.fromColor(color).withSaturation(0.15).withLightness(0.5).toColor();

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
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  providerStyle.icon,
                  size: 12,
                  color: isSelected
                      ? displayColor
                      : displayColor.withValues(alpha: 0.6),
                ),
                const SizedBox(width: 6),
                Text(
                  provider.toUpperCase(),
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: isSelected
                        ? displayColor
                        : displayColor.withValues(alpha: 0.6),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
