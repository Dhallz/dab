import 'package:flutter/material.dart';

import '../widgets/insights_body_content/insights_body_content.dart';
import '../widgets/insights_island_bar_content.dart';

class InsightsViewMobile extends StatelessWidget {
  const InsightsViewMobile({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        InsightsIslandBarContent(),
        Expanded(child: InsightsBodyContent()),
      ],
    );
  }
}
