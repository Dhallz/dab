import 'package:dab_app/domain/entities/provider/provider_config.dart';
import 'package:dab_app/presentation/core/app_bloc_consumer.dart';
import 'package:dab_app/presentation/core/models/view_status.dart';
import 'package:dab_app/presentation/core/styles/app_spacing.dart';
import 'package:dab_app/presentation/views/admin/admin_bloc.dart';
import 'package:dab_app/presentation/views/admin/admin_state.dart';
import 'package:flutter/material.dart';

import 'provider_card.dart';

/// Active providers first; among active, successful connection test first; then name.
List<ProviderConfig> _sortedProviderConfigs(
  List<ProviderConfig> configs,
  AdminState state,
) {
  int connectionTier(ProviderConfig c) {
    if (!c.isActive) return 0;
    final st = state.connectionStatuses[c.id]?.status;
    if (st == ViewStatus.success) return 2;
    return 1;
  }

  final list = List<ProviderConfig>.from(configs);
  list.sort((a, b) {
    if (a.isActive != b.isActive) {
      return a.isActive ? -1 : 1;
    }
    if (a.isActive && b.isActive) {
      final ta = connectionTier(a);
      final tb = connectionTier(b);
      if (ta != tb) return tb.compareTo(ta);
    }
    return a.name.toLowerCase().compareTo(b.name.toLowerCase());
  });
  return list;
}

class ProvidersTab extends StatelessWidget {
  const ProvidersTab({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBlocConsumer<AdminBloc, AdminState>(
      listenWhen: (previous, current) => false,
      listener: (context, state, bloc) {},
      buildWhen: (previous, current) =>
          previous.configs != current.configs ||
          previous.connectionStatuses != current.connectionStatuses,
      builder: (context, state, bloc) {
        final sorted = _sortedProviderConfigs(state.configs, state);
        return ListView.builder(
          itemCount: sorted.length,
          padding: const EdgeInsets.only(bottom: AppSpacing.xxxl),
          itemBuilder: (context, index) {
            final config = sorted[index];
            return Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.l),
              child: ProviderCard(
                key: ValueKey(config.id),
                config: config,
                bloc: bloc,
              ),
            );
          },
        );
      },
    );
  }
}
