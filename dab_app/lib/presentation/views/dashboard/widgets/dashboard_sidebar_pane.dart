import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../dashboard_notifier.dart';
import 'dashboard_sidebar_content.dart';

/// [ARCH: PRESENTATION_WIDGET]
/// ROLE: Sidebar metrics — avoids rebuilding when only the main feed slice
/// changes.
class DashboardSidebarPane extends ConsumerWidget {
  const DashboardSidebarPane({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(
      dashboardNotifierProvider.select(
        (s) => (
          providerHealth: s.providerHealth,
          activities: s.activities,
          showArchived: s.showArchivedActivities,
          follows: s.follows,
        ),
      ),
    );
    final state = ref.read(dashboardNotifierProvider);
    return DashboardSidebarContent(state: state);
  }
}
