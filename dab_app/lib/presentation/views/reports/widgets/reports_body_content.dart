import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/localization/l10n_extension.dart';
import '../../../core/models/view_status.dart';
import '../../../core/styles/app_spacing.dart';
import '../../../core/styles/app_text_styles.dart';
import '../../../core/widgets/view_toolbar.dart';
import '../reports_notifier.dart';
import 'reports_line_tile.dart';

/// [ARCH: PRESENTATION_WIDGET]
/// ROLE: Scrollable list of curated daily-report lines.
class ReportsBodyContent extends ConsumerWidget {
  const ReportsBodyContent({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scheme = Theme.of(context).colorScheme;
    final status = ref.watch(reportsNotifierProvider.select((s) => s.status));
    final lines = ref.watch(reportsNotifierProvider.select((s) => s.lines));
    final errorMessage = ref.watch(
      reportsNotifierProvider.select((s) => s.errorMessage),
    );
    final notifier = ref.read(reportsNotifierProvider.notifier);
    final horizontal = ViewToolbar.horizontalPadding(context);

    if (status == ViewStatus.loading || status == ViewStatus.initial) {
      return const Center(child: CircularProgressIndicator());
    }
    if (status == ViewStatus.failure) {
      return Center(
        child: Text(
          errorMessage ?? context.l10n.reportsEmpty,
          style: AppTextStyles.bodyMedium.copyWith(color: scheme.error),
        ),
      );
    }
    if (lines.isEmpty) {
      return Center(
        child: Text(
          context.l10n.reportsEmpty,
          style: AppTextStyles.bodyMedium.copyWith(
            color: scheme.onSurfaceVariant,
          ),
        ),
      );
    }

    return ListView.separated(
      padding: EdgeInsets.fromLTRB(horizontal, AppSpacing.s, horizontal, 28),
      itemCount: lines.length,
      separatorBuilder: (context, index) => const SizedBox(height: AppSpacing.s),
      itemBuilder: (context, index) {
        final line = lines[index];
        return ReportsLineTile(
          line: line,
          onIncludedChanged: (included) =>
              notifier.setLineIncluded(line.subjectKey, included),
          onNoteChanged: (note) =>
              notifier.setLineNote(line.subjectKey, note),
        );
      },
    );
  }
}
