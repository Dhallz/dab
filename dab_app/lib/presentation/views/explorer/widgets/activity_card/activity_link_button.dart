import 'package:flutter/material.dart';
import '../../../../../presentation/core/styles/app_icons.dart';

class ActivityLinkButton extends StatelessWidget {
  final Color accentColor;
  final VoidCallback onTap;
  final bool isVisible;

  const ActivityLinkButton({
    super.key,
    required this.accentColor,
    required this.onTap,
    required this.isVisible,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 200),
      opacity: isVisible ? 1.0 : 0.0,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(8),
          hoverColor: accentColor.withValues(alpha: 0.1),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              border: Border.all(color: accentColor.withValues(alpha: 0.3)),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Open',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: accentColor,
                  ),
                ),
                const SizedBox(width: 4),
                Icon(AppIcons.openExternal, size: 14, color: accentColor),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
