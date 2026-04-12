import 'package:dab_app/presentation/views/admin/admin_bloc.dart';
import 'package:dab_app/presentation/views/admin/admin_state.dart';
import 'package:dab_app/presentation/views/admin/models/admin_section.dart';
import 'package:dab_app/presentation/views/admin/widgets/identities_tab.dart';
import 'package:dab_app/presentation/views/admin/widgets/providers_tab.dart';
import 'package:dab_app/presentation/views/admin/widgets/security_tab.dart';
import 'package:flutter/material.dart';

class AdminSectionBody extends StatelessWidget {
  final AdminState state;
  final AdminBloc bloc;
  final AdminSection section;

  const AdminSectionBody({
    super.key,
    required this.state,
    required this.bloc,
    required this.section,
  });

  @override
  Widget build(BuildContext context) {
    return switch (section) {
      AdminSection.providers => const ProvidersTab(),
      AdminSection.identities => IdentitiesTab(
        identities: state.filteredSortedIdentities,
        users: state.users,
        providerIds: state.configs.map((c) => c.id).toList(),
        searchQuery: state.identitySearchQuery,
        sortField: state.identitySortField,
        sortAscending: state.identitySortAscending,
        bloc: bloc,
      ),
      AdminSection.security => SecurityTab(users: state.users, bloc: bloc),
    };
  }
}
