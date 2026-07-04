import 'package:dab_app/domain/entities/provider/provider_config.dart';
import 'package:dab_app/presentation/core/models/view_status.dart';
import 'package:dab_app/presentation/core/styles/app_spacing.dart';
import 'package:dab_app/presentation/views/admin/admin_notifier.dart';
import 'package:dab_app/presentation/views/admin/admin_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
    if (st == ViewStatus.warning) return 1;
    return 0;
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

class ProvidersTab extends ConsumerWidget {
  const ProvidersTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(
      adminNotifierProvider.select(
        (s) => (configs: s.configs, connectionStatuses: s.connectionStatuses),
      ),
    );
    final state = ref.read(adminNotifierProvider);
    final sorted = _sortedProviderConfigs(state.configs, state);
    return ListView.builder(
      itemCount: sorted.length,
      padding: const EdgeInsets.only(bottom: AppSpacing.xxxl),
      itemBuilder: (context, index) {
        final config = sorted[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: AppSpacing.l),
          child: ProviderCard(key: ValueKey(config.id), config: config),
        );
      },
    );
  }
}
