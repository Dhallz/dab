import 'package:flutter/material.dart';

import '../../../../domain/entities/activity/activity_category.dart';
import 'app_colors.dart';
import 'app_icons.dart';

class ActivityStyle {
  final Color color;
  final IconData icon;
  final String label;

  const ActivityStyle({
    required this.color,
    required this.icon,
    required this.label,
  });

  ActivityStyle lerp(ActivityStyle? other, double t) {
    if (other == null) return this;
    return ActivityStyle(
      color: Color.lerp(color, other.color, t) ?? color,
      icon: t < 0.5 ? icon : other.icon,
      label: t < 0.5 ? label : other.label,
    );
  }
}

class ActivityCategoryStyles extends ThemeExtension<ActivityCategoryStyles> {
  final Map<ActivityCategory, ActivityStyle> styles;

  const ActivityCategoryStyles({required this.styles});

  factory ActivityCategoryStyles.dark() {
    return ActivityCategoryStyles(
      styles: {
        ActivityCategory.commit: ActivityStyle(
          color: AppColors.engineering,
          icon: AppIcons.commit,
          label: 'COMMIT',
        ),
        ActivityCategory.revision: ActivityStyle(
          color: AppColors.revision,
          icon: AppIcons.revision,
          label: 'REVISION',
        ),
        ActivityCategory.task: ActivityStyle(
          color: AppColors.product,
          icon: AppIcons.task,
          label: 'TASK',
        ),
        ActivityCategory.message: ActivityStyle(
          color: AppColors.genericActivity,
          icon: AppIcons.message,
          label: 'MESSAGE',
        ),
        ActivityCategory.generic: ActivityStyle(
          color: AppColors.genericActivity,
          icon: AppIcons.genericActivity,
          label: 'ACTIVITY',
        ),
      },
    );
  }

  @override
  ThemeExtension<ActivityCategoryStyles> copyWith({
    Map<ActivityCategory, ActivityStyle>? styles,
  }) {
    return ActivityCategoryStyles(styles: styles ?? this.styles);
  }

  @override
  ThemeExtension<ActivityCategoryStyles> lerp(
    ThemeExtension<ActivityCategoryStyles>? other,
    double t,
  ) {
    if (other is! ActivityCategoryStyles) return this;
    final lerpedStyles = <ActivityCategory, ActivityStyle>{};
    styles.forEach((key, value) {
      lerpedStyles[key] = value.lerp(other.styles[key], t);
    });
    return ActivityCategoryStyles(styles: lerpedStyles);
  }

  ActivityStyle styleOf(ActivityCategory category) {
    return styles[category] ?? styles[ActivityCategory.generic]!;
  }
}
