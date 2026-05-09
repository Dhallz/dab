import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/localization/l10n_extension.dart';
import '../../core/models/view_status.dart';
import '../../core/navigation/app_route.dart';
import '../../core/widgets/dab_mesh_background.dart';
import '../../features/auth/auth_notifier.dart';
import '../../features/auth/auth_state.dart';

class SplashView extends ConsumerStatefulWidget {
  const SplashView({super.key});

  @override
  ConsumerState<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends ConsumerState<SplashView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _route(ref.read(authNotifierProvider));
    });
  }

  void _route(AuthState state) {
    if (!mounted) return;
    if (state.isAuthenticated) {
      context.go(AppRoute.homeDashboard.path);
    } else if (state.status == ViewStatus.success && !state.isAuthenticated) {
      context.go(AppRoute.auth.path);
    } else if (state.status == ViewStatus.failure) {
      context.go(AppRoute.auth.path);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    ref.listen<AuthState>(authNotifierProvider, (previous, next) {
      _route(next);
    });

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: DabMeshBackground(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                l10n.appBrandShortName,
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
    );
  }
}
