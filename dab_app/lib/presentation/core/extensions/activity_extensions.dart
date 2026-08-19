import 'package:flutter/material.dart';

import '../../../../domain/entities/activity/activity.dart';
import '../localization/l10n_extension.dart';
import '../styles/activity_category_styles.dart';
import '../styles/app_icons.dart';
import '../styles/provider_styles.dart';

/// True when [value] is a UUID or a long numeric Figma user id, not a name.
bool looksLikeOpaqueUserId(String value) {
  final text = value.trim();
  if (text.isEmpty) return false;
  if (RegExp(r'^[0-9]{8,}$').hasMatch(text)) return true;
  return RegExp(
    r'^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$',
    caseSensitive: false,
  ).hasMatch(text);
}

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
    // Git hosting integrations are commit-only in DAB.
    if (provider is GitHubCommitProvider ||
        provider is GitLabCommitProvider ||
        provider is BitbucketCommitProvider) {
      return 'commit';
    }

    // Chat integrations are message-oriented in DAB.
    if (provider is SlackMessageProvider ||
        provider is DiscordMessageProvider) {
      return 'message';
    }
    final figma = provider;
    if (figma is FigmaFileProvider) {
      final cid = figma.commentId?.trim() ?? '';
      return cid.isEmpty ? 'activity' : 'comment';
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
      'commit' => AppIcons.commit,
      'message' => AppIcons.message,
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

  /// Sender label: linked sender name, else [authorName], never a raw user id.
  String senderDisplayName(Map<String, String> userNameById) {
    final senderId = senderUserId?.trim() ?? '';
    if (senderId.isNotEmpty) {
      final linked = userNameById[senderId]?.trim() ?? '';
      if (linked.isNotEmpty) return linked;
    }
    final author = authorName.trim();
    if (author.isNotEmpty && !looksLikeOpaqueUserId(author)) return author;
    return '';
  }
}
