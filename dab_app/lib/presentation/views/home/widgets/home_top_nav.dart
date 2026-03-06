import 'dart:ui';

import 'package:flutter/material.dart';

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
                  _buildLogo(),
                  const SizedBox(width: 48),
                  _buildNavLinks(),
                ],
              ),
              _buildRightSection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return const Row(
      children: [
        Icon(
          Icons.history_edu_rounded,
          color: Color(0xFF6366F1), // Primary accent color
          size: 28,
        ),
        SizedBox(width: 12),
        Text(
          'DAB Explorer',
          style: TextStyle(
            color: Color(0xFFF1F5F9), // slate-100
            fontSize: 20,
            fontWeight: FontWeight.bold,
            letterSpacing: -0.5,
          ),
        ),
      ],
    );
  }

  Widget _buildNavLinks() {
    final tabs = ['Dashboard', 'Explorer', 'Insights', 'Admin'];
    return Row(
      children: List.generate(tabs.length, (index) {
        final isSelected = currentIndex == index;
        return Padding(
          padding: const EdgeInsets.only(right: 32),
          child: MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTap: () => onTap(index),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.only(bottom: 4),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: isSelected
                          ? const Color(0xFF6366F1)
                          : Colors.transparent,
                      width: 2,
                    ),
                  ),
                ),
                child: Text(
                  tabs[index],
                  style: TextStyle(
                    color: isSelected
                        ? const Color(0xFFF1F5F9) // slate-100
                        : const Color(0xFF94A3B8), // slate-400
                    fontSize: 14,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  ),
                ),
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildRightSection() {
    return Row(
      children: [
        _buildSearchBarMock(),
        const SizedBox(width: 24),
        _buildProfileMock(),
      ],
    );
  }

  Widget _buildSearchBarMock() {
    return Container(
      width: 256, // w-64
      height: 36,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: const Row(
        children: [
          Icon(Icons.search_rounded, color: Color(0xFF94A3B8), size: 18),
          SizedBox(width: 8),
          Text(
            'Search archives...',
            style: TextStyle(
              color: Color(0xFF64748B), // slate-500
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileMock() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
      child: Row(
        children: [
          const Text(
            'Alex Rivera',
            style: TextStyle(
              color: Color(0xFFCBD5E1), // slate-300
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(width: 12),
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFF6366F1).withOpacity(0.2),
              border: Border.all(
                color: const Color(0xFF6366F1).withOpacity(0.4),
              ),
            ),
            child: const Center(
              child: Text(
                'AR',
                style: TextStyle(
                  color: Color(0xFF6366F1),
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
