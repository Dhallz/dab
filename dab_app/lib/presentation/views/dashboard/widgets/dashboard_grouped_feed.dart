import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import '../../../../domain/entities/activity/activity.dart';
import '../../../core/styles/app_spacing.dart';
import '../models/dashboard_feed_group.dart';
import 'dashboard_feed_group_container.dart';

/// Number of masonry columns that fit in [width].
///
/// Starts at 1 and grows only while tiles would stay at least [_minTileWidth]
/// wide, then stops at [_maxColumns] so leftover space **widens** tiles
/// instead of adding kanban-like skinny columns. Never exceeds [itemCount].
int dashboardMasonryColumnCount(double width, {int itemCount = 1}) {
  if (!width.isFinite || width <= 0 || itemCount <= 1) return 1;
  final byWidth = math.max(1, width ~/ _minTileWidth);
  return math.min(itemCount, math.min(_maxColumns, byWidth));
}

const double _minTileWidth = 320;
const int _maxColumns = 3;

/// [ARCH: PRESENTATION_WIDGET]
/// ROLE: Lays out Dashboard category/provider containers in a responsive
/// masonry grid that reflows when the viewport width changes.
class DashboardGroupedFeed extends StatelessWidget {
  final List<DashboardFeedGroup> groups;
  final void Function(Activity activity) onArchive;
  final void Function(Activity activity) onUnarchive;

  const DashboardGroupedFeed({
    super.key,
    required this.groups,
    required this.onArchive,
    required this.onUnarchive,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = dashboardMasonryColumnCount(
          constraints.maxWidth,
          itemCount: groups.length,
        );
        return MasonryGridView.count(
          crossAxisCount: columns,
          mainAxisSpacing: AppSpacing.m,
          crossAxisSpacing: AppSpacing.m,
          itemCount: groups.length,
          itemBuilder: (context, index) {
            return DashboardFeedGroupContainer(
              group: groups[index],
              onArchive: onArchive,
              onUnarchive: onUnarchive,
            );
          },
        );
      },
    );
  }
}
