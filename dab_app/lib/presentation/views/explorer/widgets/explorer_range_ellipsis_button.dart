import 'package:flutter/material.dart';

import '../../../core/styles/app_colors.dart';
import '../../../core/styles/app_layout.dart';

/// [ARCH: PRESENTATION_WIDGET]
/// ROLE: Opens date-range picker for Explorer range mode strip.
class ExplorerRangeEllipsisButton extends StatefulWidget {
  final VoidCallback onTap;

  const ExplorerRangeEllipsisButton({super.key, required this.onTap});

  @override
  State<ExplorerRangeEllipsisButton> createState() =>
      _ExplorerRangeEllipsisButtonState();
}

class _ExplorerRangeEllipsisButtonState
    extends State<ExplorerRangeEllipsisButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: 70,
          padding: const EdgeInsets.symmetric(vertical: 6),
          decoration: BoxDecoration(
            color: _isHovered
                ? Colors.white.withValues(alpha: 0.05)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(AppLayout.radiusMedium),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: AppColors.onSurfaceVariant.withValues(alpha: 0.9),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                ' ... ',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.onSurfaceVariant.withValues(alpha: 0.9),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
