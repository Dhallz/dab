import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/styles/app_spacing.dart';
import '../reports_notifier.dart';
import '../widgets/reports_body_content.dart';
import '../widgets/reports_date_list.dart';
import '../widgets/reports_island_bar_content.dart';

/// [ARCH: PRESENTATION_LAYOUT]
/// ROLE: Mobile rendering of the Reports authoring / team-read surface.
class ReportsViewMobile extends ConsumerWidget {
  const ReportsViewMobile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dates = ref.watch(
      reportsNotifierProvider.select((s) => s.availableDates),
    );
    final selectedDate = ref.watch(
      reportsNotifierProvider.select((s) => s.date),
    );
    final todayDate = ref.watch(
      reportsNotifierProvider.select((s) => s.todayDate),
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const ReportsIslandBarContent(showUserPicker: true),
        Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.m,
            AppSpacing.s,
            AppSpacing.m,
            0,
          ),
          child: ReportsDateList(
            dates: dates,
            selectedDate: selectedDate,
            todayDate: todayDate,
            onSelect: ref.read(reportsNotifierProvider.notifier).selectDate,
            scrollDirection: Axis.horizontal,
          ),
        ),
        const Expanded(child: ReportsBodyContent()),
      ],
    );
  }
}
