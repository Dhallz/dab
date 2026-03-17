import 'package:flutter/material.dart';

import '../../../../../domain/entities/activity.dart';
import '../../../../../presentation/core/extensions/activity_ui_extensions.dart';
import '../../../../../presentation/core/styles/app_colors.dart';
import 'activity_avatar.dart';
import 'activity_intensity_bar.dart';

class ActivityFooter extends StatelessWidget {
  final Activity activity;
  final List<Activity>? activities;

  const ActivityFooter({
    super.key,
    required this.activity,
    this.activities,
  });

  @override
  Widget build(BuildContext context) {
    final style = activity.style(context);
    final hasMultiple = activities != null && activities!.length > 1;

    return Row(
      children: [
        // Author Avatar
        ActivityAvatar(
          authorName: activity.authorName,
          avatarUrl: activity.authorAvatarUrl,
        ),
        const SizedBox(width: 8),
        Text(
          activity.authorName,
          style: const TextStyle(
            fontSize: 12,
            color: AppColors.onSurfaceVariant,
            fontWeight: FontWeight.w500,
          ),
        ),
        const Spacer(),

        // Intensity Indicator ("Heat Bar") - Only for > 1 activity
        if (hasMultiple) ...[
          ActivityIntensityBar(
            activityCount: activities!.length,
            accentColor: style.color,
          ),
          const SizedBox(width: 16),
        ],

        // Unified Status Chips
        if (hasMultiple)
          _buildActivitySummaryChips(context)
        else
          _buildSingleActivityChips(context),
      ],
    );
  }

  Widget _buildSingleActivityChips(BuildContext context) {
    final style = activity.style(context);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Primary Activity Chip
        _SummaryChip(
          count: 1,
          label: style.label.toLowerCase(),
          icon: activity.granularIcon(context),
          color: style.color,
        ),
      ],
    );
  }

  Widget _buildActivitySummaryChips(BuildContext context) {
    // Group by granular icon and label, and collect their primary colors
    final groupedCount = <String, int>{};
    final groupedIcon = <String, IconData>{};
    final groupedColor = <String, Color>{};
    
    for (final act in activities!) {
      final label = act.granularLabel(context);
      groupedCount[label] = (groupedCount[label] ?? 0) + 1;
      groupedIcon[label] = act.granularIcon(context);
      groupedColor[label] = act.style(context).color;
    }

    final totalCount = activities!.length;
    final heatColor = _getHeatColor(totalCount);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Total Activities Chip (Synced with Heat Bar)
        Padding(
          padding: const EdgeInsets.only(right: 8),
          child: _SummaryChip(
            count: totalCount,
            label: totalCount == 1 ? 'activity' : 'activities',
            icon: Icons.bolt_rounded,
            color: heatColor,
          ),
        ),
        
        // Granular Chips (Original Category Colors)
        ...groupedCount.entries.map((entry) {
          final label = entry.key;
          final count = entry.value;
          final icon = groupedIcon[label]!;
          final color = groupedColor[label]!;
          
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: _SummaryChip(
              count: count,
              label: count == 1 ? label : '${label}s',
              icon: icon,
              color: color,
            ),
          );
        }),
        
      ],
    );
  }

  Color _getHeatColor(int count) {
    if (count >= 8) return const Color(0xFFFF1744); // Red
    if (count >= 6) return const Color(0xFFFF3D00); // Orange
    if (count >= 4) return const Color(0xFFAEEA00); // Lime
    if (count >= 2) return const Color(0xFF00E5FF); // Cyan
    return AppColors.primary; // Fallback
  }
}

class _SummaryChip extends StatelessWidget {
  final int count;
  final String label;
  final IconData icon;
  final Color color;

  const _SummaryChip({
    required this.count,
    required this.label,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: color.withValues(alpha: 0.2),
          width: 0.5,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 4),
          Text(
            '$count',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

extension ColorSchemeExtension on BuildContext {
  ColorScheme get colorScheme => Theme.of(this).colorScheme;
}
