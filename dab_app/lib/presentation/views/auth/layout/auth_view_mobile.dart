import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/app_bloc_consumer.dart';
import '../../../core/navigation/app_route.dart';
import '../../../core/widgets/dab_mesh_background.dart';
import '../auth_bloc.dart';
import '../auth_event.dart';
import '../auth_state.dart';
import '../widgets/auth_form.dart';
import '../widgets/auth_glass_card.dart';

class AuthViewMobile extends StatelessWidget {
  const AuthViewMobile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: DabMeshBackground(
        child: AppBlocConsumer<AuthBloc, AuthState>(
          onInit: (context, bloc) {
            // Optional: init logic
          },
          listener: (context, state, bloc) {
            if (state.status == AuthViewStatus.success) {
              context.go(AppRoute.homeDashboard.path);
            } else if (state.status == AuthViewStatus.failure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.errorMessage ?? 'Auth Failed')),
              );
            }
          },
          builder: (context, state, bloc) {
            return Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Brand Logo/Name
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
                        color: const Color(0xFF94A3B8).withOpacity(0.8),
                      ),
                    ),
                    const SizedBox(height: 48),

                    // The Glassmorphic Auth Card
                    ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 440),
                      child: AuthGlassCard(
                        padding: const EdgeInsets.all(32),
                        child: AuthForm(
                          state: state,
                          onEmailChanged: (v) => bloc.add(AuthEmailChanged(v)),
                          onPasswordChanged: (v) =>
                              bloc.add(AuthPasswordChanged(v)),
                          onNameChanged: (v) => bloc.add(AuthNameChanged(v)),
                          onSubmitted: () => bloc.add(const AuthSubmitted()),
                          onModeToggled: () =>
                              bloc.add(const AuthModeToggled()),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
