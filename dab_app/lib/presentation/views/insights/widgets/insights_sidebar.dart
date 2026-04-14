import 'package:flutter/material.dart';

import '../../../core/app_bloc_consumer.dart';
import '../../../core/localization/l10n_extension.dart';
import '../../../core/styles/app_colors.dart';
import '../../../core/styles/app_spacing.dart';
import '../../../core/styles/app_text_styles.dart';
import '../../../core/widgets/app_sidebar.dart';
import '../insights_bloc.dart';
import '../insights_event.dart';
import '../insights_state.dart';
import '../../../../domain/entities/activity/activity_category.dart';

class InsightsSidebar extends StatelessWidget {
  const InsightsSidebar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBlocConsumer<InsightsBloc, InsightsState>(
      listener: (context, state, bloc) {},
      builder: (context, state, bloc) {
        return AppSidebar(
          children: [
            Text(
              context.l10n.insightsFiltersTitle,
              style: AppTextStyles.titleMedium.copyWith(
                color: AppColors.onSurfaceHighlight,
              ),
            ),
            const SizedBox(height: AppSpacing.m),
            _SectionTitle(title: context.l10n.insightsUsersSectionTitle),
            ...state.users.map(
              (user) => CheckboxListTile(
                value: state.selectedUserIds.contains(user.id),
                onChanged: (_) => bloc.add(InsightsUserToggled(user.id)),
                dense: true,
                controlAffinity: ListTileControlAffinity.leading,
                contentPadding: EdgeInsets.zero,
                title: Text(
                  user.name,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.onSurface,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.s),
            _SectionTitle(title: context.l10n.insightsProvidersSectionTitle),
            ...state.availableProviders.map(
              (provider) => CheckboxListTile(
                value: state.selectedProviders.contains(provider),
                onChanged: (_) => bloc.add(InsightsProviderToggled(provider)),
                dense: true,
                controlAffinity: ListTileControlAffinity.leading,
                contentPadding: EdgeInsets.zero,
                title: Text(
                  provider,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.onSurface,
                  ),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.s),
            _SectionTitle(
              title: context.l10n.insightsActivityTypesSectionTitle,
            ),
            ...state.availableActivityCategories.map(
              (category) => CheckboxListTile(
                value: state.selectedActivityCategories.contains(category),
                onChanged: (_) =>
                    bloc.add(InsightsActivityCategoryToggled(category)),
                dense: true,
                controlAffinity: ListTileControlAffinity.leading,
                contentPadding: EdgeInsets.zero,
                title: Text(
                  _categoryLabel(context, category),
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.onSurface,
                  ),
                ),
              ),
            ),
          ],
        );
      },
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
}

class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.xxs),
      child: Text(
        title,
        style: AppTextStyles.labelMedium.copyWith(
          color: AppColors.onSurfaceVariant,
        ),
      ),
    );
  }
}
