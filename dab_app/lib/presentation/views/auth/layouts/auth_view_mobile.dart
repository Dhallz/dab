import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/localization/l10n_extension.dart';
import '../../../core/models/view_status.dart';
import '../../../core/navigation/app_route.dart';
import '../../../core/widgets/dab_mesh_background.dart';
import '../../../core/widgets/dab_glass_surface.dart';
import '../../../features/app/app_notifier.dart';
import '../auth_form_notifier.dart';
import '../auth_state.dart';
import '../widgets/auth_form.dart';

/// Mobile auth screen — static chrome is a [StatelessWidget]; only the form
/// subtree watches [authFormNotifierProvider].
class AuthViewMobile extends StatelessWidget {
  const AuthViewMobile({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: DabMeshBackground(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  l10n.appBrandShortName,
                  style: TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onSurface,
                    letterSpacing: 4,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  l10n.brandTagline,
                  style: TextStyle(
                    fontSize: 16,
                    color: Theme.of(context).colorScheme.onSurfaceVariant
                        .withValues(alpha: 0.8),
                  ),
                ),
                const SizedBox(height: 48),
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 440),
                  child: DabGlassSurface(
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
    final l10n = context.l10n;
    final state = ref.watch(authFormNotifierProvider);

    ref.listen<AuthState>(authFormNotifierProvider, (previous, next) {
      if (next.status == ViewStatus.success) {
        context.go(AppRoute.homeDashboard.path);
      } else if (next.status == ViewStatus.failure) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.errorMessage ?? l10n.authErrorFailed),
          ),
        );
      }
    });

    final appState = ref.watch(appNotifierProvider);

    return AuthForm(
      state: state,
      isSystemConfigured: appState.isSystemConfigured,
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
