import 'package:flutter/material.dart';

import '../../../../domain/entities/activity/activity.dart';
import '../styles/activity_category_styles.dart';
import '../styles/provider_styles.dart';

/// [ARCH: PRESENTATION_CORE]
/// ROLE: UI-specific extensions for the [ActivityProvider] entity.
/// CONSTRAINTS: Only methods requiring [BuildContext] or UI tokens go here.
extension OnActivityProvider on ActivityProvider {
  ActivityStyle style(BuildContext context) {
    final theme = Theme.of(context);
    final extension = theme.extension<ActivityCategoryStyles>();
    return extension?.styleOf(category) ??
        ActivityCategoryStyles.dark().styleOf(category);
  }

  Color color(BuildContext context) => style(context).color;
  IconData icon(BuildContext context) => style(context).icon;

  ProviderStyle providerStyle(BuildContext context) {
    final theme = Theme.of(context);
    final extension = theme.extension<ProviderStyles>();
    return extension?.styleOf(name) ?? ProviderStyles.dark().styleOf(name);
  }

  Color brandColor(BuildContext context) => providerStyle(context).brandColor;
}
