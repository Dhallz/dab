import 'package:flutter/material.dart';

import 'activity_card/activity_intensity_bar.dart';
import '../explorer_state.dart';

/// [ARCH: PRESENTATION_WIDGET]
/// ROLE: Intensity bar for aggregate activity heat in the Explorer toolbar.
class ExplorerTopHeatBar extends StatelessWidget {
  final ExplorerState state;
  final bool compact;

  const ExplorerTopHeatBar({
    super.key,
    required this.state,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    final totalCount = state.flattenedExplorerActivities.length;
    if (totalCount == 0) {
      return const SizedBox.shrink();
    }
    final heatCount = state.heatMetricForActivityTotal(totalCount);
    final cs = Theme.of(context).colorScheme;
    final bar = ActivityIntensityBar(
      activityCount: heatCount,
      accentColor: state.heatAccentColorForIntensity(heatCount, cs.primary),
      direction: compact ? Axis.horizontal : Axis.vertical,
    );
    if (compact) {
      return bar;
    }
    return SizedBox(width: 70, child: Center(child: bar));
  }
}
