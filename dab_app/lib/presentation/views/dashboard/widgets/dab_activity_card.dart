import 'package:flutter/material.dart';

import '../../../../domain/entities/activity.dart';
import '../../auth/widgets/auth_glass_card.dart';

class DabActivityCard extends StatefulWidget {
  final Activity activity;

  const DabActivityCard({super.key, required this.activity});

  @override
  State<DabActivityCard> createState() => _DabActivityCardState();
}

class _DabActivityCardState extends State<DabActivityCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final providerColor = _getProviderColor();

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedScale(
        scale: _isHovered ? 1.02 : 1.0,
        duration: const Duration(milliseconds: 200),
        child: Padding(
          padding: const EdgeInsets.only(bottom: 20),
          child: Stack(
            children: [
              // Subtle Glow under the card
              if (_isHovered)
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: providerColor.withOpacity(0.15),
                          blurRadius: 30,
                          spreadRadius: -5,
                        ),
                      ],
                    ),
                  ),
                ),

              AuthGlassCard(
                padding: const EdgeInsets.all(20),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildProviderIcon(providerColor),
                    const SizedBox(width: 20),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: providerColor.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(6),
                                  border: Border.all(
                                    color: providerColor.withOpacity(0.2),
                                  ),
                                ),
                                child: Text(
                                  widget.activity.provider.name.toUpperCase(),
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w800,
                                    color: providerColor.withOpacity(0.9),
                                    letterSpacing: 1.2,
                                  ),
                                ),
                              ),
                              Text(
                                _formatTime(widget.activity.createdAt),
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w500,
                                  color: const Color(
                                    0xFF94A3B8,
                                  ).withOpacity(0.6),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Text(
                            widget.activity.title,
                            style: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFFF8FAFC),
                              letterSpacing: -0.2,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            widget.activity.content,
                            style: TextStyle(
                              fontSize: 14,
                              color: const Color(0xFFF8FAFC).withOpacity(0.6),
                              height: 1.5,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          if (widget.activity.url != null) ...[
                            const SizedBox(height: 16),
                            InkWell(
                              onTap: () {
                                // Action for URL
                              },
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    'Open in Browser',
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                      color: providerColor.withOpacity(0.9),
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  Icon(
                                    Icons.arrow_forward_rounded,
                                    size: 14,
                                    color: providerColor.withOpacity(0.9),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Animated Border highlight for "Stitch" feel
              Positioned(
                top: 0,
                left: 40,
                right: 40,
                child: Container(
                  height: 1,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.transparent,
                        providerColor.withOpacity(0.5),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProviderIcon(Color color) {
    IconData icon;
    switch (widget.activity.provider.name.toLowerCase()) {
      case 'github':
        icon = Icons.terminal_rounded;
        break;
      case 'slack':
        icon = Icons.message_rounded;
        break;
      case 'jira':
        icon = Icons.analytics_rounded;
        break;
      case 'linear':
        icon = Icons.auto_graph_rounded;
        break;
      case 'phorge':
        icon = Icons
            .settings_suggest_rounded; // Or another fitting icon if elephant isn't available
        break;
      default:
        icon = Icons.notifications_active_rounded;
    }

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        shape: BoxShape.circle,
        border: Border.all(color: color.withOpacity(0.2), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Icon(_getIconForType() ?? icon, color: color, size: 22),
    );
  }

  IconData? _getIconForType() {
    switch (widget.activity.type.toLowerCase()) {
      case 'pr_opened':
        return Icons.call_merge_rounded;
      case 'message':
        return Icons.alternate_email_rounded;
      case 'issue_created':
        return Icons.bug_report_rounded;
      case 'task':
        return Icons.task_alt_rounded;
      case 'revision':
        return Icons.code_rounded;
      default:
        return null;
    }
  }

  Color _getProviderColor() {
    switch (widget.activity.provider.name.toLowerCase()) {
      case 'github':
        return const Color(0xFF24292F);
      case 'slack':
        return const Color(0xFF4A154B);
      case 'jira':
        return const Color(0xFF0052CC);
      case 'linear':
        return const Color(0xFF5E6AD2);
      case 'phorge':
        return const Color(0xFF6B7280); // Phorge Gray/Steel
      default:
        return const Color(0xFF6366F1);
    }
  }

  String _formatTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 1) return 'JUST NOW';
    if (difference.inMinutes < 60) return '${difference.inMinutes}M AGO';
    if (difference.inHours < 24) return '${difference.inHours}H AGO';
    return '${difference.inDays}D AGO';
  }
}
