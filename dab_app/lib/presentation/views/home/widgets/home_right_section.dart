import 'package:flutter/material.dart';

import '../../../core/styles/app_spacing.dart';
import 'home_profile.dart';

/// [ARCH: PRESENTATION_WIDGET]
/// ROLE: Right-side section of the top navigation bar, containing search and profile.
class HomeRightSection extends StatelessWidget {
  final String userName;
  final String userInitials;

  const HomeRightSection({
    super.key,
    required this.userName,
    required this.userInitials,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // const HomeSearchBar(),
        const SizedBox(width: AppSpacing.l),
        HomeProfile(
          showName: true,
          userName: userName,
          userInitials: userInitials,
        ),
      ],
    );
  }
}
