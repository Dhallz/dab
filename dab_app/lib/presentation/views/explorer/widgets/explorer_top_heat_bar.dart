import 'package:flutter/material.dart';

import 'activity_card/activity_intensity_bar.dart';
import '../explorer_state.dart';

/// [ARCH: PRESENTATION_WIDGET]
/// ROLE: Vertical intensity bar for aggregate activity heat in Explorer island bar.
class ExplorerTopHeatBar extends StatelessWidget {
  final ExplorerState state;

  const ExplorerTopHeatBar({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    final totalCount = state.flattenedExplorerActivities.length;
    if (totalCount == 0) {
      return const SizedBox.shrink();
    }
    final heatCount = state.heatMetricForActivityTotal(totalCount);
    final cs = Theme.of(context).colorScheme;
    return SizedBox(
      width: 70,
      child: Center(
        child: ActivityIntensityBar(
          activityCount: heatCount,
          accentColor:
              state.heatAccentColorForIntensity(heatCount, cs.primary),
          direction: Axis.vertical,
        ),
      ),
    );
  }
}
