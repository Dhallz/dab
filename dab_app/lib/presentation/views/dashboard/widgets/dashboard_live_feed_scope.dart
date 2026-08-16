import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../dashboard_notifier.dart';
import 'dashboard_live_feed.dart';

/// [ARCH: PRESENTATION_WIDGET]
/// ROLE: Subscribes to dashboard feed-relevant state only so provider-health
/// sidebar updates do not rebuild the main feed (and vice versa).
class DashboardLiveFeedScope extends ConsumerWidget {
  final EdgeInsetsGeometry padding;

  const DashboardLiveFeedScope({super.key, required this.padding});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(
      dashboardNotifierProvider.select(
        (s) => (
          status: s.status,
          activities: s.activities,
          showArchivedActivities: s.showArchivedActivities,
          feedMode: s.feedMode,
          providerHealth: s.providerHealth,
          reconnectNoticeAt: s.reconnectNoticeAt,
          errorMessage: s.errorMessage,
          followedObjectRefs: s.followedObjectRefs,
        ),
      ),
    );
    final state = ref.read(dashboardNotifierProvider);
    return DashboardLiveFeed(state: state, padding: padding);
  }
}
