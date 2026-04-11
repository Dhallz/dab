import 'package:dab_app/presentation/features/app/app_cubit.dart';
import 'package:dab_app/presentation/features/auth/auth_cubit.dart';
import 'package:dab_app/presentation/features/auth/auth_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'layouts/home_view_desktop.dart';
import 'layouts/home_view_mobile.dart';

class HomeView extends StatefulWidget {
  final StatefulNavigationShell navigationShell;

  const HomeView({super.key, required this.navigationShell});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final auth = context.read<AuthCubit>().state;
      context.read<AppCubit>().refreshIdentityResolutionBadge(auth);
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listenWhen: (prev, curr) =>
          prev.user?.id != curr.user?.id ||
          prev.user?.role != curr.user?.role,
      listener: (context, state) {
        context.read<AppCubit>().refreshIdentityResolutionBadge(state);
      },
      child: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth > 800) {
            return HomeViewDesktop(navigationShell: widget.navigationShell);
          }
          return HomeViewMobile(navigationShell: widget.navigationShell);
        },
      ),
    );
  }
}
