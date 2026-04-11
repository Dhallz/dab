import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../services/service_locator.dart';
import '../../features/auth/auth_cubit.dart';
import 'auth_bloc.dart';
import 'layouts/auth_view_mobile.dart';

class AuthView extends StatelessWidget {
  const AuthView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          AuthBloc(sl.authUseCases, authCubit: context.read<AuthCubit>()),
      child: LayoutBuilder(
        builder: (context, constraints) {
          // Add desktop/tablet checks here if needed
          return const AuthViewMobile();
        },
      ),
    );
  }
}
