import 'package:dab_app/domain/core/daily_report_lock_policy.dart';
import 'package:dab_app/presentation/core/localization/app_localizations.dart';
import 'package:dab_app/presentation/core/localization/l10n_extension.dart';
import 'package:dab_app/presentation/core/styles/app_icons.dart';
import 'package:flutter/material.dart';

/// [ARCH: PRESENTATION_WIDGET]
/// ROLE: Global daily-report edit deadline on the Admin Security tab.
class ReportDeadlinePanel extends StatelessWidget {
  final int offsetDays;
  final String time;
  final ValueChanged<DailyReportLockPolicy> onChanged;

  const ReportDeadlinePanel({
    super.key,
    required this.offsetDays,
    required this.time,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final l10n = context.l10n;
    final clock = parseDailyReportLockTime(time);
    final timeOfDay = TimeOfDay(hour: clock.hour, minute: clock.minute);
    final policy = DailyReportLockPolicy(offsetDays: offsetDays, time: time);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: cs.onSurface.withValues(alpha: 0.03),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: cs.outline.withValues(alpha: 0.15)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: cs.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(AppIcons.lock, color: cs.primary, size: 20),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.adminReportDeadlineTitle,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: cs.onSurface,
                      ),
                    ),
                    Text(
                      l10n.adminReportDeadlineSubtitle,
                      style: TextStyle(
                        color: cs.onSurfaceVariant,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Text(
            l10n.adminReportDeadlineOffsetLabel,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: cs.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 8),
          DropdownMenu<int>(
            key: ValueKey(offsetDays),
            initialSelection: offsetDays,
            expandedInsets: EdgeInsets.zero,
            label: Text(l10n.adminReportDeadlineOffsetLabel),
            onSelected: (value) {
              if (value == null) return;
              onChanged(DailyReportLockPolicy(offsetDays: value, time: time));
            },
            dropdownMenuEntries: [
              for (var days = 0; days <= kMaxDailyReportLockOffsetDays; days++)
                DropdownMenuEntry<int>(
                  value: days,
                  label: _offsetLabel(l10n, days),
                ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            l10n.adminReportDeadlineTimeLabel,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: cs.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 8),
          OutlinedButton.icon(
            onPressed: () async {
              final picked = await showTimePicker(
                context: context,
                initialTime: timeOfDay,
              );
              if (picked == null) return;
              onChanged(
                DailyReportLockPolicy(
                  offsetDays: offsetDays,
                  time: formatDailyReportLockTime((
                    hour: picked.hour,
                    minute: picked.minute,
                  )),
                ),
              );
            },
            icon: Icon(AppIcons.history, size: 18),
            label: Text(timeOfDay.format(context)),
          ),
          const SizedBox(height: 16),
          Text(
            l10n.adminReportDeadlinePreview(
              timeOfDay.format(context),
              _offsetLabel(l10n, policy.offsetDays),
            ),
            style: TextStyle(color: cs.onSurfaceVariant, fontSize: 12),
          ),
        ],
      ),
    );
  }

  String _offsetLabel(AppLocalizations l10n, int days) {
    return switch (days) {
      0 => l10n.adminReportDeadlineOffsetReportDay,
      1 => l10n.adminReportDeadlineOffsetNextDay,
      _ => l10n.adminReportDeadlineOffsetDaysLater(days),
    };
  }
}
