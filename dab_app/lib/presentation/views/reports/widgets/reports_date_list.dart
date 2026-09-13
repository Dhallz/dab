import 'package:flutter/material.dart';

import '../../../core/localization/l10n_extension.dart';
import '../../../core/styles/app_icons.dart';
import '../../../core/styles/app_spacing.dart';
import '../../../core/styles/app_text_styles.dart';
import '../../../core/widgets/dab_toggle_chip.dart';
import '../../../core/widgets/selection_tile.dart';

/// [ARCH: PRESENTATION_WIDGET]
/// ROLE: Dated report index for the selected Directory person.
class ReportsDateList extends StatelessWidget {
  final List<String> dates;
  final String selectedDate;
  final String todayDate;
  final ValueChanged<String> onSelect;
  final Axis scrollDirection;

  const ReportsDateList({
    super.key,
    required this.dates,
    required this.selectedDate,
    required this.todayDate,
    required this.onSelect,
    this.scrollDirection = Axis.vertical,
  });

  @override
  Widget build(BuildContext context) {
    if (dates.isEmpty) {
      return Text(
        context.l10n.reportsNoSavedReports,
        style: AppTextStyles.bodySmall.copyWith(
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
      );
    }
    if (scrollDirection == Axis.horizontal) {
      return SizedBox(
        height: 36,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: dates.length,
          separatorBuilder: (_, __) => const SizedBox(width: AppSpacing.xs),
          itemBuilder: (context, index) {
            final date = dates[index];
            return DabToggleChip(
              label: _label(context, date),
              isSelected: date == selectedDate,
              onTap: () => onSelect(date),
            );
          },
        ),
      );
    }
    return Column(
      children: [
        for (final date in dates)
          Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.xs),
            child: SelectionTile(
              label: _label(context, date),
              subtitle: date == todayDate ? date : null,
              isSelected: date == selectedDate,
              iconData: AppIcons.calendar,
              onTap: () => onSelect(date),
            ),
          ),
      ],
    );
  }

  String _label(BuildContext context, String date) {
    if (date == todayDate) return context.l10n.reportsDateToday;
    return date;
  }
}
