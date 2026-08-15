import 'package:dab_app/domain/entities/provider/provider_config.dart';
import 'package:dab_app/presentation/core/localization/l10n_extension.dart';
import 'package:dab_app/presentation/core/models/view_status.dart';
import 'package:dab_app/presentation/core/styles/app_spacing.dart';
import 'package:dab_app/presentation/core/styles/app_text_styles.dart';
import 'package:dab_app/presentation/features/app/app_notifier.dart';
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
    final isPersonal = ref.watch(
      appNotifierProvider.select((s) => s.isPersonalDeployment),
    );
    final state = ref.read(adminNotifierProvider);
    final sorted = _sortedProviderConfigs(state.configs, state);
    final visible = isPersonal
        ? sorted
              .where((c) {
                final id = c.id.toLowerCase();
                return id != 'phorge' && id != 'phabricator';
              })
              .toList()
        : sorted;
    final cs = Theme.of(context).colorScheme;
    return ListView.builder(
      itemCount: visible.length + (isPersonal ? 1 : 0),
      padding: const EdgeInsets.only(bottom: AppSpacing.xxxl),
      itemBuilder: (context, index) {
        if (isPersonal && index == 0) {
          return Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.l),
            child: Text(
              context.l10n.adminPersonalProvidersHint,
              style: AppTextStyles.bodySmall.copyWith(
                color: cs.onSurfaceVariant,
              ),
            ),
          );
        }
        final config = visible[isPersonal ? index - 1 : index];
        return Padding(
          padding: const EdgeInsets.only(bottom: AppSpacing.l),
          child: ProviderCard(key: ValueKey(config.id), config: config),
        );
      },
    );
  }
}
