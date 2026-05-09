import 'package:flutter/material.dart';
import '../../../core/styles/app_colors.dart';
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
    return InkWell(
      onTap: () async {
        final date = await showDatePicker(
          context: context,
          initialDate: selectedDate,
          firstDate: DateTime(2020),
          lastDate: DateTime.now(),
          builder: (context, child) {
            return Theme(
              data: Theme.of(context).copyWith(
                colorScheme: const ColorScheme.dark(
                  primary: AppColors.primary,
                  onPrimary: AppColors.onPrimary,
                  surface: AppColors.surfaceContainer,
                  onSurface: AppColors.onSurface,
                ),
              ),
              child: child!,
            );
          },
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
          color: Colors.white.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              AppIcons.calendar,
              color: AppColors.onSurfaceVariantLow,
              size: compact ? 20 : 18,
            ),
            if (!compact) ...[
              const SizedBox(width: 8),
              const Text(
                'Jump to date',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppColors.onSurfaceVariantLow,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
