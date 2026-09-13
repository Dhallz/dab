import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../domain/core/daily_report_lock_policy.dart';
import '../../../core/localization/l10n_extension.dart';
import '../../../core/models/view_status.dart';
import '../../../core/styles/app_spacing.dart';
import '../../../core/styles/app_text_styles.dart';
import '../../../core/widgets/view_toolbar.dart';
import '../../../features/app/app_notifier.dart';
import '../reports_notifier.dart';
import 'reports_activity_search/reports_activity_search.dart';
import 'reports_line_tile.dart';

/// [ARCH: PRESENTATION_WIDGET]
/// ROLE: Scrollable list of daily-report lines, plus add-from-search when editing.
class ReportsBodyContent extends ConsumerWidget {
  const ReportsBodyContent({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scheme = Theme.of(context).colorScheme;
    final state = ref.watch(reportsNotifierProvider);
    final notifier = ref.read(reportsNotifierProvider.notifier);
    final horizontal = ViewToolbar.horizontalPadding(context);

    if (state.status == ViewStatus.loading ||
        state.status == ViewStatus.initial) {
      return const Center(child: CircularProgressIndicator());
    }

    Widget body;
    if (state.status == ViewStatus.failure) {
      body = Center(
        child: Text(
          state.errorMessage ?? context.l10n.reportsEmpty,
          style: AppTextStyles.bodyMedium.copyWith(color: scheme.error),
        ),
      );
    } else if (state.date.isEmpty) {
      body = Center(
        child: Text(
          context.l10n.reportsNoSavedReports,
          style: AppTextStyles.bodyMedium.copyWith(
            color: scheme.onSurfaceVariant,
          ),
        ),
      );
    } else if (state.lines.isEmpty) {
      body = Center(
        child: Text(
          state.isOwnReport
              ? context.l10n.reportsEmpty
              : context.l10n.reportsTeamEmpty,
          style: AppTextStyles.bodyMedium.copyWith(
            color: scheme.onSurfaceVariant,
          ),
        ),
      );
    } else {
      body = ListView.separated(
        padding: EdgeInsets.fromLTRB(horizontal, AppSpacing.s, horizontal, 28),
        itemCount: state.lines.length,
        separatorBuilder: (context, index) =>
            const SizedBox(height: AppSpacing.s),
        itemBuilder: (context, index) {
          final line = state.lines[index];
          return ReportsLineTile(
            line: line,
            readOnly: state.isReadOnly,
            onIncludedChanged: (included) =>
                notifier.setLineIncluded(line.subjectKey, included),
            onNoteChanged: (note) =>
                notifier.setLineNote(line.subjectKey, note),
          );
        },
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (state.isOwnReport && state.isPastDeadline && state.date.isNotEmpty)
          Padding(
            padding: EdgeInsets.fromLTRB(
              horizontal,
              AppSpacing.s,
              horizontal,
              0,
            ),
            child: _DeadlineBanner(date: state.date),
          ),
        if (!state.isReadOnly && state.date.isNotEmpty)
          Padding(
            padding: EdgeInsets.fromLTRB(
              horizontal,
              AppSpacing.s,
              horizontal,
              0,
            ),
            child: ReportsActivitySearch(
              state: state,
              onQueryChanged: notifier.setSearchQuery,
              onAdd: notifier.addFromSearch,
            ),
          ),
        Expanded(child: body),
      ],
    );
  }
}

class _DeadlineBanner extends ConsumerWidget {
  final String date;

  const _DeadlineBanner({required this.date});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final app = ref.watch(appNotifierProvider);
    final clock = parseDailyReportLockTime(app.dailyReportLockTime);
    final time = TimeOfDay(hour: clock.hour, minute: clock.minute);
    return Text(
      context.l10n.reportsLockedBanner(
        time.format(context),
        date,
        app.orgTimezoneId,
      ),
      style: AppTextStyles.bodySmall.copyWith(
        color: Theme.of(context).colorScheme.onSurfaceVariant,
      ),
    );
  }
}
