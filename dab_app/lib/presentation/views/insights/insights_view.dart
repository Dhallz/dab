import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/auth/auth_notifier.dart';
import 'insights_notifier.dart';
import 'layouts/insights_view_desktop.dart';
import 'layouts/insights_view_mobile.dart';

class InsightsView extends ConsumerStatefulWidget {
  const InsightsView({super.key});

  @override
  ConsumerState<InsightsView> createState() => _InsightsViewState();
}

class _InsightsViewState extends ConsumerState<InsightsView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final connectedUserId = ref.read(authNotifierProvider).user?.id;
      ref.read(insightsNotifierProvider.notifier).started(connectedUserId);
    });
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(insightsNotifierProvider.select((s) => s.availableProviders));

    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > 900) {
          return const InsightsViewDesktop();
        }
        return const InsightsViewMobile();
      },
    );
  }
}
