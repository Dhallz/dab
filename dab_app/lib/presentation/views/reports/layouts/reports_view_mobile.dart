import 'package:flutter/material.dart';

import '../widgets/reports_body_content.dart';
import '../widgets/reports_island_bar_content.dart';

/// [ARCH: PRESENTATION_LAYOUT]
/// ROLE: Mobile rendering of the Reports authoring surface.
class ReportsViewMobile extends StatelessWidget {
  const ReportsViewMobile({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ReportsIslandBarContent(),
        Expanded(child: ReportsBodyContent()),
      ],
    );
  }
}
