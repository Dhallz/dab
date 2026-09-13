import 'package:flutter/material.dart';
import 'home_profile.dart';

/// [ARCH: PRESENTATION_WIDGET]
/// ROLE: Right-side section of the top navigation bar, containing the profile control.
class HomeRightSection extends StatelessWidget {
  final String userName;
  final String userInitials;
  final VoidCallback onOpenSettings;

  const HomeRightSection({
    super.key,
    required this.userName,
    required this.userInitials,
    required this.onOpenSettings,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        HomeProfile(
          showName: true,
          userName: userName,
          userInitials: userInitials,
          onOpenSettings: onOpenSettings,
        ),
      ],
    );
  }
}
