import 'package:flutter/material.dart';

import '../localization/l10n_extension.dart';

/// [ARCH: PRESENTATION_CORE]
/// ROLE: UI helpers for [String] values used in Explorer chrome and author
/// labels.
extension OnString on String {
  /// True when this is a UUID or a long numeric Figma user id, not a name.
  bool get looksLikeOpaqueUserId {
    final text = trim();
    if (text.isEmpty) return false;
    if (RegExp(r'^[0-9]{8,}$').hasMatch(text)) return true;
    return RegExp(
      r'^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$',
      caseSensitive: false,
    ).hasMatch(text);
  }

  /// User-facing label for this granular key in activity-kind summaries.
  String islandSummaryLabel(BuildContext context) {
    return switch (this) {
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

  /// Icon for this granular key in island summaries.
  IconData get islandSummaryIcon {
    return switch (this) {
      'comment' => Icons.chat_bubble_outline_rounded,
      'tag' => Icons.local_offer_outlined,
      'status' => Icons.swap_horiz_rounded,
      'review' => Icons.fact_check_outlined,
      'assignment' => Icons.person_add_alt_1_outlined,
      'commit' => Icons.commit_rounded,
      'message' => Icons.chat_outlined,
      _ => Icons.bubble_chart_outlined,
    };
  }
}
