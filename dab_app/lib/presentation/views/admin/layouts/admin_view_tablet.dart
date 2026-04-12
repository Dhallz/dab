import 'package:dab_app/domain/entities/user/user_identity.dart';
import 'package:dab_app/presentation/core/app_bloc_consumer.dart';
import 'package:dab_app/presentation/core/models/view_status.dart';
import 'package:dab_app/presentation/core/widgets/island_bar.dart';
import 'package:dab_app/presentation/features/app/app_cubit.dart';
import 'package:dab_app/presentation/features/auth/auth_cubit.dart';
import 'package:dab_app/presentation/views/admin/admin_bloc.dart';
import 'package:dab_app/presentation/views/admin/admin_state.dart';
import 'package:dab_app/presentation/views/admin/models/admin_section.dart';
import 'package:dab_app/presentation/views/admin/widgets/admin_island_bar_content.dart';
import 'package:dab_app/presentation/views/admin/widgets/admin_section_body.dart';
import 'package:dab_app/presentation/views/admin/widgets/admin_section_header.dart';
import 'package:dab_app/presentation/views/admin/widgets/admin_section_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

String _identityListSignature(List<UserIdentity> list) =>
    list.map((e) => e.id).join('|');

class AdminViewTablet extends StatelessWidget {
  const AdminViewTablet({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBlocConsumer<AdminBloc, AdminState>(
      listenWhen: (previous, current) {
        if (current.errorMessage != previous.errorMessage &&
            current.errorMessage != null) {
          return true;
        }
        if (current.status == ViewStatus.success &&
            previous.status == ViewStatus.loading &&
            current.errorMessage == null) {
          return true;
        }
        if (current.status == ViewStatus.success &&
            current.errorMessage == null &&
            _identityListSignature(previous.identities) !=
                _identityListSignature(current.identities)) {
          return true;
        }
        return false;
      },
      listener: (context, state, bloc) {
        if (state.errorMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage!),
              backgroundColor: Colors.red,
            ),
          );
          return;
        }
        if (state.status == ViewStatus.success && state.errorMessage == null) {
          context.read<AppCubit>().refreshIdentityResolutionBadge(
            context.read<AuthCubit>().state,
          );
        }
      },
      builder: (context, state, bloc) {
        final section = state.selectedSection;
        return Scaffold(
          backgroundColor: Colors.transparent,
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const IslandBar(content: AdminIslandBarContent()),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),
                      AdminSectionSelector(selectedSection: section),
                      const SizedBox(height: 20),
                      AdminSectionHeader(
                        title: section.title,
                        subtitle: section.subtitle,
                      ),
                      const SizedBox(height: 20),
                      Expanded(
                        child: AdminSectionBody(
                          state: state,
                          bloc: bloc,
                          section: section,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
