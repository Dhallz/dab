import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../domain/entities/activity.dart';

class ActivityCard extends StatelessWidget {
  final Activity activity;

  const ActivityCard({super.key, required this.activity});

  @override
  Widget build(BuildContext context) {
    final theme = _getTheme();

    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xFF1E293B).withValues(alpha: 0.4),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
          ),
          child: Stack(
            children: [
              // Left Accent Bar
              Positioned(
                left: 0,
                top: 0,
                bottom: 0,
                child: Container(width: 4, color: theme.color),
              ),
              Padding(
                padding: const EdgeInsets.all(24),
                child: Stack(
                  children: [
                    // Archived Tag
                    Positioned(
                      top: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF334155).withValues(alpha: 0.5),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Text(
                          '[ARCHIVED]',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Icon Container
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: theme.color.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: theme.color.withValues(alpha: 0.2),
                            ),
                          ),
                          child: Icon(theme.icon, color: theme.color, size: 24),
                        ),
                        const SizedBox(width: 16),
                        // Content
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Meta info
                              Row(
                                children: [
                                  Text(
                                    theme.label.toUpperCase(),
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                      color: theme.color,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Container(
                                    width: 4,
                                    height: 4,
                                    decoration: const BoxDecoration(
                                      color: Color(0xFF475569),
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    DateFormat(
                                      'hh:mm a',
                                    ).format(activity.createdAt),
                                    style: const TextStyle(
                                      fontSize: 10,
                                      color: Color(0xFF94A3B8),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              // Title
                              Text(
                                activity.title,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFFF1F5F9),
                                  letterSpacing: -0.2,
                                ),
                              ),
                              const SizedBox(height: 8),
                              // Content
                              Text(
                                activity.content,
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Color(0xFF94A3B8),
                                  height: 1.5,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 16),
                              // Footer
                              _buildFooter(),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFooter() {
    return Row(
      children: [
        // Avatar mock
        Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: const Color(0xFF6366F1).withValues(alpha: 0.2),
            border: Border.all(
              color: const Color(0xFF6366F1).withValues(alpha: 0.4),
            ),
          ),
          child: const Center(
            child: Text(
              'AR', // Mock initials
              style: TextStyle(
                color: Color(0xFF6366F1),
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        const Text(
          'Alex Rivera', // Mock name
          style: TextStyle(
            fontSize: 12,
            color: Color(0xFFCBD5E1),
            fontWeight: FontWeight.w500,
          ),
        ),
        const Spacer(),
        const Icon(
          Icons.chat_bubble_outline_rounded,
          size: 14,
          color: Color(0xFF64748B),
        ),
        const SizedBox(width: 4),
        const Text(
          '4 comments', // Mock data
          style: TextStyle(fontSize: 12, color: Color(0xFF64748B)),
        ),
      ],
    );
  }

  _ActivityTheme _getTheme() {
    switch (activity.provider.category) {
      case 'commit':
        return const _ActivityTheme(
          color: Color(0xFF3B82F6), // Blue-500
          icon: Icons.commit_rounded,
          label: 'Engineering',
        );
      case 'revision':
        return const _ActivityTheme(
          color: Color(0xFFA855F7), // Purple-500
          icon: Icons.code_rounded,
          label: 'Engineering',
        );
      case 'task':
        return const _ActivityTheme(
          color: Color(0xFF10B981), // Emerald-500
          icon: Icons.task_alt_rounded,
          label: 'Product',
        );
      default:
        return const _ActivityTheme(
          color: Color(0xFFF59E0B), // Amber-500
          icon: Icons.bolt_rounded,
          label: 'Activity',
        );
    }
  }
}

class _ActivityTheme {
  final Color color;
  final IconData icon;
  final String label;

  const _ActivityTheme({
    required this.color,
    required this.icon,
    required this.label,
  });
}
