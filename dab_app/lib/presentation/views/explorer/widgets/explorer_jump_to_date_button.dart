import 'package:flutter/material.dart';
import '../../../core/styles/app_icons.dart';
import '../explorer_notifier.dart';

/// [ARCH: PRESENTATION_WIDGET]
/// ROLE: Button that opens a date picker to quickly navigate the explorer.
class ExplorerJumpToDateButton extends StatelessWidget {
  final DateTime selectedDate;
  final ExplorerNotifier notifier;
  final bool compact;

  const ExplorerJumpToDateButton({
    super.key,
    required this.selectedDate,
    required this.notifier,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return InkWell(
      onTap: () async {
        final date = await showDatePicker(
          context: context,
          initialDate: selectedDate,
          firstDate: DateTime(2020),
          lastDate: DateTime.now(),
        );
        if (date != null) {
          notifier.scheduleDateChanged(date);
        }
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: compact ? 10 : 16,
          vertical: compact ? 8 : 12,
        ),
        decoration: BoxDecoration(
          color: cs.onSurface.withValues(alpha: 0.06),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              AppIcons.calendar,
              color: cs.onSurfaceVariant,
              size: compact ? 20 : 18,
            ),
            if (!compact) ...[
              const SizedBox(width: 8),
              Text(
                'Jump to date',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: cs.onSurfaceVariant,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
