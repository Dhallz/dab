import 'dart:ui';
import 'package:flutter/material.dart';

import 'home_logo.dart';
import 'home_nav_links.dart';
import 'home_right_section.dart';

/// [ARCH: PRESENTATION_WIDGET]
/// ROLE: Top navigation bar for the home view.
class HomeTopNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const HomeTopNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          decoration: BoxDecoration(
            color: const Color(0xFF1E293B).withOpacity(0.6),
            border: Border(
              bottom: BorderSide(color: Colors.white.withOpacity(0.1)),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const HomeLogo(),
                  const SizedBox(width: 48),
                  HomeNavLinks(
                    currentIndex: currentIndex,
                    onTap: onTap,
                  ),
                ],
              ),
              const HomeRightSection(),
            ],
          ),
        ),
      ),
    );
  }
}
