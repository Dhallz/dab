import 'package:flutter/material.dart';

import '../../../../domain/entities/user/daily_report_line_role.dart';
import '../../../core/localization/l10n_extension.dart';
import '../../../core/styles/app_text_styles.dart';

/// [ARCH: PRESENTATION_WIDGET]
/// ROLE: Compact inbound / authored / both chip on a report line.
class ReportsRoleChip extends StatelessWidget {
  final DailyReportLineRole role;

  const ReportsRoleChip({super.key, required this.role});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final label = switch (role) {
      DailyReportLineRole.directed => context.l10n.reportsRoleDirected,
      DailyReportLineRole.authored => context.l10n.reportsRoleAuthored,
      DailyReportLineRole.both => context.l10n.reportsRoleBoth,
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: scheme.secondaryContainer.withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: AppTextStyles.labelMedium.copyWith(
          color: scheme.onSecondaryContainer,
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
