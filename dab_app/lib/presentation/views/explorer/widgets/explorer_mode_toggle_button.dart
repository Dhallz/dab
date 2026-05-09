import 'package:flutter/material.dart';

import '../../../core/styles/app_layout.dart';

/// [ARCH: PRESENTATION_WIDGET]
/// ROLE: Compact mode / quick-action control in Explorer island bar date strip.
class ExplorerModeToggleButton extends StatefulWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const ExplorerModeToggleButton({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  State<ExplorerModeToggleButton> createState() =>
      _ExplorerModeToggleButtonState();
}

class _ExplorerModeToggleButtonState extends State<ExplorerModeToggleButton> {
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
          duration: const Duration(milliseconds: 180),
          width: 70,
          padding: EdgeInsets.symmetric(vertical: widget.isSelected ? 8 : 6),
          decoration: BoxDecoration(
            color: _isHovered && !widget.isSelected
                ? cs.onSurface.withValues(alpha: 0.06)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(AppLayout.radiusMedium),
            border: widget.isSelected
                ? Border.all(color: cs.primary.withValues(alpha: 0.35))
                : null,
          ),
          child: Center(
            child: Text(
              widget.label.toUpperCase(),
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: widget.isSelected
                    ? cs.primary
                    : cs.onSurfaceVariant.withValues(alpha: 0.75),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
