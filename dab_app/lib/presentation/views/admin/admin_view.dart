import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dab_app/services/service_locator.dart';
import 'package:dab_app/presentation/views/admin/admin_bloc.dart';
import 'package:dab_app/presentation/views/admin/admin_event.dart';
import 'package:dab_app/presentation/views/admin/layout/admin_view_desktop.dart';

/// [ARCH: PRESENTATION_VIEW]
/// ROLE: Entry point for the Admin Console.
/// CONTRACT: Provides [AdminBloc] and delegates layout.
class AdminView extends StatelessWidget {
  const AdminView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AdminBloc(
        providerRepo: sl.providerConfigRepository,
        userRepo: sl.userRepository,
      )..add(const AdminStarted()),
      child: LayoutBuilder(
        builder: (context, constraints) {
          // For now, we only have desktop layout for Admin.
          // In a real app we would have mobile-specific logic here.
          return const AdminViewDesktop();
        },
      ),
    );
  }
}
