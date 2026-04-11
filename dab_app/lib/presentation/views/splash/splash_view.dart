import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../core/models/view_status.dart';
import '../../core/navigation/app_route.dart';
import '../../core/widgets/dab_mesh_background.dart';
import '../../features/auth/auth_cubit.dart';
import '../../features/auth/auth_state.dart';

class SplashView extends StatelessWidget {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state.isAuthenticated) {
          context.go(AppRoute.homeDashboard.path);
        } else if (state.status == ViewStatus.success && !state.isAuthenticated) {
          context.go(AppRoute.auth.path);
        } else if (state.status == ViewStatus.failure) {
          // Handle error, maybe retry or go to auth
          context.go(AppRoute.auth.path);
        }
      },
      child: const Scaffold(
        backgroundColor: Colors.transparent,
        body: DabMeshBackground(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'DAB',
                  style: TextStyle(
                    fontSize: 64,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFF8FAFC),
                    letterSpacing: 8,
                  ),
                ),
                SizedBox(height: 16),
                CircularProgressIndicator(color: Color(0xFF6366F1)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
