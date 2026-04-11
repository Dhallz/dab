import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// [ARCH: PRESENTATION_WIDGET]
/// ROLE: Individual date button in the calendar selector.
class ExplorerCalendarDateButton extends StatefulWidget {
  final DateTime date;
  final bool isSelected;
  final VoidCallback onTap;

  const ExplorerCalendarDateButton({
    super.key,
    required this.date,
    required this.isSelected,
    required this.onTap,
  });

  @override
  State<ExplorerCalendarDateButton> createState() => _ExplorerCalendarDateButtonState();
}

class _ExplorerCalendarDateButtonState extends State<ExplorerCalendarDateButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final isWeekend =
        widget.date.weekday == DateTime.saturday ||
        widget.date.weekday == DateTime.sunday;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: 70,
          padding: EdgeInsets.symmetric(vertical: widget.isSelected ? 12 : 8),
          decoration: BoxDecoration(
            color: _isHovered && !widget.isSelected
                ? Colors.white.withValues(alpha: 0.05)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                DateFormat('E').format(widget.date).toUpperCase(),
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: widget.isSelected
                      ? const Color(0xFF6366F1)
                      : isWeekend
                      ? const Color(0xFF64748B).withValues(alpha: 0.5)
                      : const Color(0xFF94A3B8).withValues(alpha: 0.6),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                DateFormat('d').format(widget.date),
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: widget.isSelected
                      ? const Color(0xFF6366F1)
                      : isWeekend
                      ? const Color(0xFF94A3B8).withValues(alpha: 0.7)
                      : const Color(0xFF94A3B8),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
