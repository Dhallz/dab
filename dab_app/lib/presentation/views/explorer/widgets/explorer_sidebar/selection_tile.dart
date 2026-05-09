import 'package:flutter/material.dart';

import '../../../../core/styles/app_icons.dart';

class SelectionTile extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final String? avatarUrl;
  final IconData? iconData;
  final Widget? trailing;

  const SelectionTile({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onTap,
    this.avatarUrl,
    this.iconData,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isLight = Theme.of(context).brightness == Brightness.light;

    final subtleFillDark = cs.onSurface.withValues(alpha: 0.06);
    final subtleBorderDark = cs.outline.withValues(alpha: 0.35);

    late final Color rowFill;
    late final Color borderColor;
    late final List<BoxShadow> shadows;
    late final Color iconChipFill;
    late final Color checkColor;
    late final double checkSize;

    if (isLight) {
      rowFill = isSelected
          ? cs.surfaceContainerHigh
          : cs.surfaceContainerLow;
      borderColor = isSelected
          ? cs.outline
          : cs.outlineVariant.withValues(alpha: 0.75);
      shadows = [];
      iconChipFill = isSelected
          ? cs.surfaceContainer
          : cs.surfaceContainerLow;
      checkColor = cs.primary.withValues(alpha: 0.72);
      checkSize = 15;
    } else {
      rowFill = subtleFillDark;
      borderColor = isSelected
          ? cs.primary.withValues(alpha: 0.55)
          : subtleBorderDark;
      shadows = isSelected
          ? [
              BoxShadow(
                color: cs.primary.withValues(alpha: 0.12),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ]
          : [];
      iconChipFill = isSelected
          ? cs.primary.withValues(alpha: 0.12)
          : subtleFillDark;
      checkColor = cs.primary;
      checkSize = 16;
    }

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: 48,
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: rowFill,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: borderColor, width: 1),
          boxShadow: shadows,
        ),
        child: Row(
          children: [
            if (avatarUrl != null)
              CircleAvatar(
                radius: 12,
                backgroundColor: cs.onSurface.withValues(alpha: 0.1),
                backgroundImage: NetworkImage(avatarUrl!),
              )
            else if (iconData != null)
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: iconChipFill,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  iconData,
                  size: 14,
                  color: isSelected ? cs.primary : cs.onSurfaceVariant,
                ),
              ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  color: isSelected ? cs.onSurface : cs.onSurfaceVariant,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (trailing != null)
              trailing!
            else if (isSelected)
              Icon(AppIcons.selected, size: checkSize, color: checkColor),
          ],
        ),
      ),
    );
  }
}
