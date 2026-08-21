import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/localization/l10n_extension.dart';
import '../../../core/models/view_status.dart';
import '../../../core/navigation/app_route.dart';
import '../../../features/app/app_notifier.dart';
import '../auth_form_notifier.dart';
import '../auth_state.dart';
import 'auth_form.dart';

/// [ARCH: PRESENTATION_WIDGET]
/// ROLE: Auth form subtree that watches [authFormNotifierProvider].
class AuthFormPanel extends ConsumerStatefulWidget {
  const AuthFormPanel({super.key});

  @override
  ConsumerState<AuthFormPanel> createState() => _AuthFormPanelState();
}

class _AuthFormPanelState extends ConsumerState<AuthFormPanel> {
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
