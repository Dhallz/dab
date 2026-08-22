import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/auth/auth_notifier.dart';
import 'layouts/reports_view_desktop.dart';
import 'layouts/reports_view_mobile.dart';
import 'reports_notifier.dart';

/// [ARCH: PRESENTATION_VIEW]
/// ROLE: Responsive entry point for personal daily-report authoring.
/// CONTRACT: Switches layout based on constraints; state is scoped by
/// [reportsNotifierProvider].
class ReportsView extends ConsumerStatefulWidget {
  const ReportsView({super.key});

  @override
  ConsumerState<ReportsView> createState() => _ReportsViewState();
}

class _ReportsViewState extends ConsumerState<ReportsView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final connectedUserId = ref.read(authNotifierProvider).user?.id;
      ref.read(reportsNotifierProvider.notifier).started(connectedUserId);
    });
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(reportsNotifierProvider.select((s) => s.date));

    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > 900) {
          return const ReportsViewDesktop();
        }
        return const ReportsViewMobile();
      },
    );
  }
}
