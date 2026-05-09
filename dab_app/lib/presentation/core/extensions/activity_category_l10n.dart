import '../../../../domain/entities/activity/activity_category.dart';
import '../localization/app_localizations.dart';

/// [ARCH: PRESENTATION_CORE]
/// ROLE: Localized short labels (e.g. heat map / category chrome) for
/// [ActivityCategory] in the client UI.
extension ActivityCategoryL10n on ActivityCategory {
  /// Uppercase-style abbreviation for category chrome (matches prior English tokens).
  String abbreviatedLabel(AppLocalizations l10n) {
    return switch (this) {
      ActivityCategory.commit => l10n.activityCategoryAbbrevCommit,
      ActivityCategory.revision => l10n.activityCategoryAbbrevRevision,
      ActivityCategory.task => l10n.activityCategoryAbbrevTask,
      ActivityCategory.message => l10n.activityCategoryAbbrevMessage,
      ActivityCategory.generic => l10n.activityCategoryAbbrevGeneric,
    };
  }
}
