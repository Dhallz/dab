import 'package:flutter/material.dart';

import '../widgets/insights_body_content/insights_body_content.dart';
import '../widgets/insights_island_bar_content.dart';
import '../widgets/insights_sidebar/insights_sidebar.dart';

class InsightsViewDesktop extends StatelessWidget {
  const InsightsViewDesktop({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: const [
        InsightsSidebar(),
        Expanded(
          child: Column(
            children: [
              InsightsIslandBarContent(),
              Expanded(child: InsightsBodyContent()),
            ],
          ),
        ),
      ],
    );
  }
}
