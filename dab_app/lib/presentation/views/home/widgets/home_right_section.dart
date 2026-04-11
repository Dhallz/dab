import 'package:flutter/material.dart';
import 'home_profile.dart';
import 'home_search_bar.dart';

/// [ARCH: PRESENTATION_WIDGET]
/// ROLE: Right-side section of the top navigation bar, containing search and profile.
class HomeRightSection extends StatelessWidget {
  const HomeRightSection({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        HomeSearchBar(),
        SizedBox(width: 24),
        HomeProfile(),
      ],
    );
  }
}
