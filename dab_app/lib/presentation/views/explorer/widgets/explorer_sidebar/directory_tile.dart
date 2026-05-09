import 'package:flutter/material.dart';

class DirectoryTile extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const DirectoryTile({
    super.key,
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isLight = Theme.of(context).brightness == Brightness.light;
    final subtleFillDark = cs.onSurface.withValues(alpha: 0.06);

    late final Color rowFill;
    late final Color borderColor;
    late final List<BoxShadow> shadows;

    if (isLight) {
      rowFill = isSelected
          ? cs.surfaceContainerHigh
          : cs.surfaceContainerLow;
      borderColor = isSelected
          ? cs.outline
          : cs.outlineVariant.withValues(alpha: 0.75);
      shadows = [];
    } else {
      rowFill = subtleFillDark;
      borderColor = isSelected
          ? cs.primary.withValues(alpha: 0.55)
          : cs.outline.withValues(alpha: 0.35);
      shadows = isSelected
          ? [
              BoxShadow(
                color: cs.primary.withValues(alpha: 0.15),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ]
          : [];
    }

    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          height: 72,
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: 8),
          decoration: BoxDecoration(
            color: rowFill,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: borderColor, width: 1),
            boxShadow: shadows,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 20,
                color: isSelected ? cs.primary : cs.onSurfaceVariant,
              ),
              const SizedBox(height: 8),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                  color: isSelected ? cs.onSurface : cs.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
