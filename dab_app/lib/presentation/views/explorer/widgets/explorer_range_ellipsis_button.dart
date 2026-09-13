import 'package:flutter/material.dart';

import '../../../core/styles/app_layout.dart';

/// [ARCH: PRESENTATION_WIDGET]
/// ROLE: Opens date-range picker for Explorer range mode strip.
class ExplorerRangeEllipsisButton extends StatefulWidget {
  final VoidCallback onTap;
  final bool compact;

  const ExplorerRangeEllipsisButton({
    super.key,
    required this.onTap,
    this.compact = false,
  });

  @override
  State<ExplorerRangeEllipsisButton> createState() =>
      _ExplorerRangeEllipsisButtonState();
}

class _ExplorerRangeEllipsisButtonState
    extends State<ExplorerRangeEllipsisButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: widget.compact ? 52 : 70,
          padding: EdgeInsets.symmetric(vertical: widget.compact ? 4 : 6),
          decoration: BoxDecoration(
            color: _isHovered
                ? cs.onSurface.withValues(alpha: 0.06)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(AppLayout.radiusMedium),
          ),
          child: Center(
            child: Text(
              ' ... ',
              style: TextStyle(
                fontSize: widget.compact ? 14 : 18,
                fontWeight: FontWeight.bold,
                color: cs.onSurfaceVariant.withValues(alpha: 0.9),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
