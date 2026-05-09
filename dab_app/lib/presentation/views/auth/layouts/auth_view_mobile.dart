import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/models/view_status.dart';
import '../../../core/navigation/app_route.dart';
import '../../../core/widgets/dab_mesh_background.dart';
import '../auth_form_notifier.dart';
import '../auth_state.dart';
import '../widgets/auth_form.dart';
import '../widgets/auth_glass_card.dart';

/// Mobile auth screen — static chrome is a [StatelessWidget]; only the form
/// subtree watches [authFormNotifierProvider].
class AuthViewMobile extends StatelessWidget {
  const AuthViewMobile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: DabMeshBackground(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'DAB',
                  style: TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFF8FAFC),
                    letterSpacing: 4,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Dev Activity Board',
                  style: TextStyle(
                    fontSize: 16,
                    color: const Color(0xFF94A3B8).withValues(alpha: 0.8),
                  ),
                ),
                const SizedBox(height: 48),
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 440),
                  child: AuthGlassCard(
                    padding: const EdgeInsets.all(32),
                    child: _AuthFormPanel(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _AuthFormPanel extends ConsumerStatefulWidget {
  @override
  ConsumerState<_AuthFormPanel> createState() => _AuthFormPanelState();
}

class _AuthFormPanelState extends ConsumerState<_AuthFormPanel> {
  @override
  Widget build(BuildContext context) {
    final state = ref.watch(authFormNotifierProvider);

    ref.listen<AuthState>(authFormNotifierProvider, (previous, next) {
      if (next.status == ViewStatus.success) {
        context.go(AppRoute.homeDashboard.path);
      } else if (next.status == ViewStatus.failure) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(next.errorMessage ?? 'Auth Failed')),
        );
      }
    });

    return AuthForm(
      state: state,
      onEmailChanged: (v) =>
          ref.read(authFormNotifierProvider.notifier).setEmail(v),
      onPasswordChanged: (v) =>
          ref.read(authFormNotifierProvider.notifier).setPassword(v),
      onNameChanged: (v) =>
          ref.read(authFormNotifierProvider.notifier).setName(v),
      onSubmitted: () =>
          ref.read(authFormNotifierProvider.notifier).submit(ref),
      onModeToggled: () =>
          ref.read(authFormNotifierProvider.notifier).toggleMode(),
    );
  }
}
