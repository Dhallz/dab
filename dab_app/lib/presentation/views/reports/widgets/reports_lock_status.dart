import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../domain/core/daily_report_lock_policy.dart';
import '../../../core/localization/l10n_extension.dart';
import '../../../core/styles/app_icons.dart';
import '../../../core/styles/app_spacing.dart';
import '../../../core/widgets/dab_toggle_chip.dart';
import '../../../features/app/app_notifier.dart';
import '../../../features/app/app_state.dart';
import '../reports_notifier.dart';

/// [ARCH: PRESENTATION_WIDGET]
/// ROLE: Own-report lock chip plus live countdown to the Admin deadline.
class ReportsLockStatus extends ConsumerStatefulWidget {
  const ReportsLockStatus({super.key});

  @override
  ConsumerState<ReportsLockStatus> createState() => _ReportsLockStatusState();
}

class _ReportsLockStatusState extends ConsumerState<ReportsLockStatus> {
  Timer? _ticker;

  @override
  void initState() {
    super.initState();
    _ticker = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _ticker?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final date = ref.watch(reportsNotifierProvider.select((s) => s.date));
    final isOwnReport = ref.watch(
      reportsNotifierProvider.select((s) => s.isOwnReport),
    );
    final isPastDeadline = ref.watch(
      reportsNotifierProvider.select((s) => s.isPastDeadline),
    );
    if (!isOwnReport || date.isEmpty) {
      return const SizedBox.shrink();
    }

    final app = ref.watch(appNotifierProvider);
    final lockAt = dailyReportLockUtc(
      reportDate: date,
      orgTimezoneId: app.orgTimezoneId,
      policy: app.dailyReportLockPolicy,
    );
    final remaining = lockAt == null
        ? Duration.zero
        : lockAt.difference(DateTime.now().toUtc());
    final locked = isPastDeadline || remaining <= Duration.zero;
    if (locked) {
      return DabToggleChip(
        label: context.l10n.reportsLockedChip,
        isSelected: true,
        icon: AppIcons.lock,
        onTap: null,
      );
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        DabToggleChip(
          label: context.l10n.reportsUnlockedChip,
          isSelected: false,
          icon: AppIcons.unlock,
          onTap: null,
        ),
        const SizedBox(width: AppSpacing.xs),
        DabToggleChip(
          label: context.l10n.reportsLockCountdown(
            formatDailyReportLockCountdown(remaining),
          ),
          isSelected: false,
          icon: AppIcons.history,
          onTap: null,
        ),
      ],
    );
  }
}
