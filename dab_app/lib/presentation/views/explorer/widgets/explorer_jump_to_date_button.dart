import 'package:flutter/material.dart';
import '../explorer_bloc.dart';
import '../explorer_event.dart';

/// [ARCH: PRESENTATION_WIDGET]
/// ROLE: Button that opens a date picker to quickly navigate the explorer.
class ExplorerJumpToDateButton extends StatelessWidget {
  final DateTime selectedDate;
  final ExplorerBloc bloc;

  const ExplorerJumpToDateButton({
    super.key,
    required this.selectedDate,
    required this.bloc,
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
                  primary: Color(0xFF6366F1),
                  onPrimary: Colors.white,
                  surface: Color(0xFF1E293B),
                  onSurface: Colors.white,
                ),
              ),
              child: child!,
            );
          },
        );
        if (date != null) {
          bloc.add(ExplorerDateChanged(date));
        }
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.calendar_month_rounded,
              color: Color(0xFFCBD5E1),
              size: 18,
            ),
            SizedBox(width: 8),
            Text(
              'Jump to date',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Color(0xFFCBD5E1),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
