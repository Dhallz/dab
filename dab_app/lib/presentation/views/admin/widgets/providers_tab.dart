import 'package:dab_app/domain/entities/provider/provider_config.dart';
import 'package:dab_app/presentation/views/admin/admin_bloc.dart';
import 'package:flutter/material.dart';

import 'provider_card.dart';

class ProvidersTab extends StatelessWidget {
  final List<ProviderConfig> configs;
  final AdminBloc bloc;

  const ProvidersTab({super.key, required this.configs, required this.bloc});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: configs.length,
      padding: const EdgeInsets.only(bottom: 100),
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 24),
          child: ProviderCard(config: configs[index], bloc: bloc),
        );
      },
    );
  }
}
