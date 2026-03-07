import 'package:flutter/material.dart';

import '../../../../domain/entities/activity.dart';
import '../styles/activity_category_styles.dart';

extension ActivityUIExtensions on Activity {
  ActivityStyle style(BuildContext context) {
    final theme = Theme.of(context);
    final extension = theme.extension<ActivityCategoryStyles>();
    return extension?.styleOf(provider.category) ??
        ActivityCategoryStyles.dark().styleOf(provider.category);
  }

  Color color(BuildContext context) => style(context).color;
  IconData icon(BuildContext context) => style(context).icon;
}

extension ActivityProviderUIExtensions on ActivityProvider {
  ActivityStyle style(BuildContext context) {
    final theme = Theme.of(context);
    final extension = theme.extension<ActivityCategoryStyles>();
    return extension?.styleOf(category) ??
        ActivityCategoryStyles.dark().styleOf(category);
  }

  Color color(BuildContext context) => style(context).color;
  IconData icon(BuildContext context) => style(context).icon;
}
