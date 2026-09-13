import 'package:dab_app/presentation/views/admin/layouts/admin_view_desktop.dart';
import 'package:dab_app/presentation/views/admin/layouts/admin_view_mobile.dart';
import 'package:dab_app/presentation/views/admin/layouts/admin_view_tablet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'admin_notifier.dart';

/// [ARCH: PRESENTATION_VIEW]
/// ROLE: Entry point for the Admin Console.
/// CONTRACT: Delegates layout; state lives in [adminNotifierProvider].
class AdminView extends ConsumerStatefulWidget {
  const AdminView({super.key});

  @override
  ConsumerState<AdminView> createState() => _AdminViewState();
}

class _AdminViewState extends ConsumerState<AdminView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      ref.read(adminNotifierProvider.notifier).start();
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= 1024) {
          return const AdminViewDesktop();
        }
        if (constraints.maxWidth >= 600) {
          return const AdminViewTablet();
        }
        return const AdminViewMobile();
      },
    );
  }
}
