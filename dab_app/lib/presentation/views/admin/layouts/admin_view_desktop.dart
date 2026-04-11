import 'package:dab_app/presentation/core/app_bloc_consumer.dart';
import 'package:dab_app/presentation/core/widgets/dab_app_bar.dart';
import 'package:dab_app/presentation/views/admin/admin_bloc.dart';
import 'package:dab_app/presentation/views/admin/admin_state.dart';
import 'package:dab_app/presentation/views/admin/layouts/admin_sidebar.dart';
import 'package:dab_app/presentation/views/admin/models/admin_section.dart';
import 'package:dab_app/presentation/views/admin/widgets/admin_section_header.dart';
import 'package:dab_app/presentation/views/admin/widgets/identities_tab.dart';
import 'package:dab_app/presentation/views/admin/widgets/providers_tab.dart';
import 'package:dab_app/presentation/views/admin/widgets/security_tab.dart';
import 'package:flutter/material.dart';

/// [ARCH: PRESENTATION_LAYOUT]
/// ROLE: Desktop layout for the Admin Console.
class AdminViewDesktop extends StatelessWidget {
  const AdminViewDesktop({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBlocConsumer<AdminBloc, AdminState>(
      listener: (context, state, bloc) {
        if (state.errorMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage!),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      builder: (context, state, bloc) {
        final section = state.selectedSection;

        return Scaffold(
          backgroundColor: Colors.transparent,
          body: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AdminSidebar(selectedSection: section),
              Expanded(
                child: Column(
                  children: [
                    const Padding(
                      padding: EdgeInsets.fromLTRB(32, 24, 32, 16),
                      child: DabAppBar(),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 32.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AdminSectionHeader(
                              title: section.title,
                              subtitle: section.subtitle,
                            ),
                            const SizedBox(height: 32),
                            Expanded(
                              child: switch (section) {
                                AdminSection.providers => ProvidersTab(
                                    configs: state.configs,
                                    bloc: bloc,
                                  ),
                                AdminSection.identities => IdentitiesTab(
                                    identities: state.identities,
                                    bloc: bloc,
                                  ),
                                AdminSection.security => SecurityTab(
                                    users: state.users,
                                    bloc: bloc,
                                  ),
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
