import 'package:flutter/material.dart';

import '../../../../domain/entities/activity/activity.dart';
import '../localization/l10n_extension.dart';
import '../styles/activity_category_styles.dart';
import '../styles/provider_styles.dart';

/// [ARCH: PRESENTATION_CORE]
/// ROLE: UI-specific extensions for the [Activity] entity.
/// CONSTRAINTS: Only methods requiring [BuildContext] or UI tokens go here.
extension OnActivity on Activity {
  ActivityStyle style(BuildContext context) {
    final theme = Theme.of(context);
    final extension = theme.extension<ActivityCategoryStyles>();
    return extension?.styleOf(provider.category) ??
        ActivityCategoryStyles.dark().styleOf(provider.category);
  }

  Color color(BuildContext context) => style(context).color;
  IconData icon(BuildContext context) => style(context).icon;

  ProviderStyle providerStyle(BuildContext context) {
    final theme = Theme.of(context);
    final extension = theme.extension<ProviderStyles>();
    return extension?.styleOf(provider.name) ??
        ProviderStyles.dark().styleOf(provider.name);
  }

  Color brandColor(BuildContext context) => providerStyle(context).brandColor;

  String granularKey() {
    // GitHub integration is commit-only in DAB.
    if (provider is GitHubCommitProvider) {
      return 'commit';
    }

    // Slack integration is message-oriented in DAB.
    if (provider is SlackMessageProvider) {
      return 'message';
    }

    final contentLower = content.toLowerCase();
    final titleLower = title.toLowerCase();

    if (contentLower.contains('comment') ||
        titleLower.contains('comment') ||
        commentCount > 0) {
      return 'comment';
    }
    if (contentLower.contains('tag') ||
        titleLower.contains('tag') ||
        contentLower.contains('label') ||
        titleLower.contains('label')) {
      return 'tag';
    }
    if (contentLower.contains('status') ||
        titleLower.contains('status') ||
        contentLower.contains('state') ||
        titleLower.contains('state') ||
        contentLower.contains('moved to') ||
        contentLower.contains('changed to') ||
        contentLower.contains('to done') ||
        contentLower.contains('to in progress')) {
      return 'status';
    }
    if (contentLower.contains('review') ||
        titleLower.contains('review') ||
        contentLower.contains('approved') ||
        contentLower.contains('requested changes')) {
      return 'review';
    }
    if (contentLower.contains('assigned') || titleLower.contains('assigned')) {
      return 'assignment';
    }

    return 'activity';
  }

  IconData granularIcon(BuildContext context) {
    return switch (granularKey()) {
      'comment' => Icons.chat_bubble_outline_rounded,
      'tag' => Icons.local_offer_outlined,
      'status' => Icons.swap_horiz_rounded,
      'review' => Icons.fact_check_outlined,
      'assignment' => Icons.person_add_alt_1_outlined,
      _ => icon(context),
    };
  }

  String granularLabel(BuildContext context) {
    return switch (granularKey()) {
      'comment' => context.l10n.activityKindComment,
      'tag' => context.l10n.activityKindTag,
      'status' => context.l10n.activityKindStatus,
      'review' => context.l10n.activityKindReview,
      'assignment' => context.l10n.activityKindAssignment,
      'commit' => context.l10n.activityKindCommit,
      'message' => context.l10n.activityKindMessage,
      _ => context.l10n.activityKindActivity,
    };
  }
}
