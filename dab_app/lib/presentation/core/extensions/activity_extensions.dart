import 'package:flutter/material.dart';

import '../../../../domain/entities/activity.dart';
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

  IconData granularIcon(BuildContext context) {
    final contentLower = content.toLowerCase();
    final titleLower = title.toLowerCase();

    // Comment detection
    if (contentLower.contains('comment') || titleLower.contains('comment') || commentCount > 0) {
      return Icons.chat_bubble_outline_rounded;
    }

    // Tag / Label detection
    if (contentLower.contains('tag') || titleLower.contains('tag') || 
        contentLower.contains('label') || titleLower.contains('label')) {
      return Icons.local_offer_outlined;
    }

    // Status / State detection
    if (contentLower.contains('status') || titleLower.contains('status') || 
        contentLower.contains('state') || titleLower.contains('state') ||
        contentLower.contains('moved to') || contentLower.contains('changed to') ||
        contentLower.contains('to done') || contentLower.contains('to in progress')) {
      return Icons.swap_horiz_rounded;
    }

    // Code Review detection
    if (contentLower.contains('review') || titleLower.contains('review') || 
        contentLower.contains('approved') || contentLower.contains('requested changes')) {
      return Icons.fact_check_outlined;
    }
    
    // Assignment detection
    if (contentLower.contains('assigned') || titleLower.contains('assigned')) {
      return Icons.person_add_alt_1_outlined;
    }

    // Default fallback to category-level icon
    return icon(context);
  }

  String granularLabel(BuildContext context) {
    final contentLower = content.toLowerCase();
    final titleLower = title.toLowerCase();

    if (contentLower.contains('comment') || titleLower.contains('comment') || commentCount > 0) {
      return 'comment';
    }
    if (contentLower.contains('tag') || titleLower.contains('tag') || 
        contentLower.contains('label') || titleLower.contains('label')) {
      return 'tag';
    }
    if (contentLower.contains('status') || titleLower.contains('status') || 
        contentLower.contains('state') || titleLower.contains('state') ||
        contentLower.contains('moved to') || contentLower.contains('changed to')) {
      return 'status';
    }
    if (contentLower.contains('review') || titleLower.contains('review') || 
        contentLower.contains('approved') || contentLower.contains('requested changes')) {
      return 'review';
    }
    if (contentLower.contains('assigned') || titleLower.contains('assigned')) {
      return 'assignment';
    }

    return style(context).label.toLowerCase();
  }
}
