import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/auth/auth_notifier.dart';
import 'explorer_notifier.dart';
import 'layouts/explorer_view_desktop.dart';
import 'layouts/explorer_view_mobile.dart';

class ExplorerView extends ConsumerStatefulWidget {
  const ExplorerView({super.key});

  @override
  ConsumerState<ExplorerView> createState() => _ExplorerViewState();
}

class _ExplorerViewState extends ConsumerState<ExplorerView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final connectedUserId = ref.read(authNotifierProvider).user?.id;
      ref.read(explorerNotifierProvider.notifier).started(connectedUserId);
    });
  }

  @override
  Widget build(BuildContext context) {
    // Keep the autoDispose notifier alive across [started]'s first await.
    ref.watch(explorerNotifierProvider.select((s) => s.availableProviders));

    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > 900) {
          return const ExplorerViewDesktop();
        }
        return const ExplorerViewMobile();
      },
    );
  }
}
