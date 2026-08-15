import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../domain/entities/activity/activity_category.dart';
import '../../../core/localization/l10n_extension.dart';
import '../../../core/styles/app_icons.dart';
import '../../../core/styles/app_spacing.dart';
import '../../../core/styles/app_text_styles.dart';
import '../../../core/styles/provider_icon_resolver.dart';
import '../../../core/widgets/app_sidebar.dart';
import '../../../core/widgets/selection_tile.dart';
import '../insights_notifier.dart';

class InsightsSidebar extends ConsumerWidget {
  const InsightsSidebar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(
      insightsNotifierProvider.select(
        (s) => (
          users: s.users,
          selectedUserIds: s.selectedUserIds,
          availableProviders: s.availableProviders,
          selectedProviders: s.selectedProviders,
          availableActivityCategories: s.availableActivityCategories,
          selectedActivityCategories: s.selectedActivityCategories,
        ),
      ),
    );
    final state = ref.read(insightsNotifierProvider);
    final notifier = ref.read(insightsNotifierProvider.notifier);
    final cs = Theme.of(context).colorScheme;
    return AppSidebar(
      children: [
        Text(
          context.l10n.insightsFiltersTitle,
          style: AppTextStyles.titleMedium.copyWith(
            color: cs.onSurface,
          ),
        ),
        const SizedBox(height: AppSpacing.m),
        _SectionTitle(title: context.l10n.insightsUsersSectionTitle),
        ...state.users.map(
          (user) => Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.xs),
            child: SelectionTile(
              label: user.name,
              isSelected: state.selectedUserIds.contains(user.id),
              avatarUrl: user.avatarUrl,
              iconData: user.avatarUrl == null ? AppIcons.user : null,
              onTap: () => notifier.toggleUser(user.id),
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.s),
        _SectionTitle(title: context.l10n.insightsProvidersSectionTitle),
        ...state.availableProviders.map(
          (provider) => Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.xs),
            child: SelectionTile(
              label: provider,
              isSelected: state.selectedProviders.contains(provider),
              iconData: ProviderIconResolver.resolveFallbackIcon(
                context,
                provider,
              ),
              onTap: () => notifier.toggleProvider(provider),
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.s),
        _SectionTitle(title: context.l10n.insightsActivityTypesSectionTitle),
        ...state.availableActivityCategories.map(
          (category) => Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.xs),
            child: SelectionTile(
              label: _categoryLabel(context, category),
              isSelected: state.selectedActivityCategories.contains(category),
              iconData: _iconFor(category),
              onTap: () => notifier.toggleActivityCategory(category),
            ),
          ),
        ),
      ],
    );
  }

  String _categoryLabel(BuildContext context, ActivityCategory category) {
    return switch (category) {
      ActivityCategory.commit => context.l10n.explorerActivityFilterCommit,
      ActivityCategory.revision => context.l10n.explorerActivityFilterRevision,
      ActivityCategory.task => context.l10n.explorerActivityFilterTask,
      ActivityCategory.message => context.l10n.explorerActivityFilterMessage,
      ActivityCategory.generic => context.l10n.explorerActivityFilterGeneric,
    };
  }

  IconData _iconFor(ActivityCategory category) {
    return switch (category) {
      ActivityCategory.commit => AppIcons.commit,
      ActivityCategory.revision => AppIcons.revision,
      ActivityCategory.task => AppIcons.task,
      ActivityCategory.message => AppIcons.chatMessage,
      ActivityCategory.generic => AppIcons.genericActivity,
    };
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.xxs),
      child: Text(
        title,
        style: AppTextStyles.labelMedium.copyWith(
          color: cs.onSurfaceVariant,
        ),
      ),
    );
  }
}
