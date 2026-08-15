import 'package:flutter/material.dart';

import '../../../../domain/entities/activity/activity.dart';
import '../../../core/styles/app_spacing.dart';
import '../../../core/styles/app_text_styles.dart';
import 'dashboard_activity_card.dart';

/// [ARCH: PRESENTATION_WIDGET]
/// ROLE: One Timeline row — clock time, connecting rail, and activity card.
class DashboardTimelineRow extends StatelessWidget {
  final Activity activity;
  final String timeLabel;
  final bool isLast;
  final VoidCallback? onArchive;
  final VoidCallback? onUnarchive;

  const DashboardTimelineRow({
    super.key,
    required this.activity,
    required this.timeLabel,
    required this.isLast,
    this.onArchive,
    this.onUnarchive,
  });

  static const double timeColumnWidth = 72;
  static const double _railWidth = 12;
  static const double _dotSize = 8;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Semantics(
      label: timeLabel,
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: timeColumnWidth,
              child: Padding(
                padding: const EdgeInsets.only(top: AppSpacing.xxs),
                child: Text(
                  timeLabel,
                  textAlign: TextAlign.end,
                  style: AppTextStyles.monospaced.copyWith(
                    fontSize: AppTextStyles.labelMedium.fontSize,
                    fontWeight: FontWeight.w700,
                    color: scheme.onSurface,
                  ),
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.xs),
            SizedBox(
              width: _railWidth,
              child: Column(
                children: [
                  Container(
                    width: _dotSize,
                    height: _dotSize,
                    margin: const EdgeInsets.only(top: 6),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: scheme.primary,
                    ),
                  ),
                  if (!isLast)
                    Expanded(
                      child: Container(
                        width: 2,
                        margin: const EdgeInsets.symmetric(vertical: 4),
                        color: scheme.outline.withValues(alpha: 0.45),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.s),
            Expanded(
              child: DashboardActivityCard(
                activity: activity,
                onArchive: onArchive,
                onUnarchive: onUnarchive,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
