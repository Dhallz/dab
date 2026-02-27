import 'package:flutter/material.dart';

import '../layout/settings_view_mobile.dart';

class SettingsViewDesktop extends StatelessWidget {
  const SettingsViewDesktop({super.key});

  @override
  Widget build(BuildContext context) {
    // For now, desktop just uses a cushioned version of mobile
    // In the future, this could be a side-by-side master-detail layout
    return Row(
      children: [
        const Expanded(flex: 1, child: SizedBox()),
        const Expanded(flex: 2, child: SettingsViewMobile()),
        const Expanded(flex: 1, child: SizedBox()),
      ],
    );
  }
}
