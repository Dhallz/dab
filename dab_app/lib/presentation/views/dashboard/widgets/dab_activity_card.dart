import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../domain/entities/activity.dart';
import '../../../../presentation/core/extensions/activity_extensions.dart';
import '../../../../presentation/core/extensions/activity_provider_extensions.dart';
import '../../../../presentation/core/styles/app_colors.dart';
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
    final style = widget.activity.style(context);
    final theme = Theme.of(context);

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            if (_isHovered)
              BoxShadow(
                color: style.color.withValues(alpha: 0.15),
                blurRadius: 15,
                spreadRadius: 2,
              ),
          ],
        ),
        child: AuthGlassCard(
          child: InkWell(
            onTap: _launchUrl,
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _buildProviderIcon(style.color),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                style.label,
                                style: theme.textTheme.labelSmall?.copyWith(
                                  color: style.color,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1.2,
                                ),
                              ),
                              const Spacer(),
                              Text(
                                _formatDate(),
                                style: theme.textTheme.labelSmall?.copyWith(
                                  color: AppColors.onSurfaceVariantLow,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            widget.activity.title,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              height: 1.2,
                              color: AppColors.onSurface,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            widget.activity.content,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: AppColors.onSurfaceVariant,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Icon(
                      Icons.chevron_right_rounded,
                      color: style.color.withValues(alpha: 0.5),
                      size: 20,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProviderIcon(Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        shape: BoxShape.circle,
        border: Border.all(color: color.withValues(alpha: 0.2), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.1),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Icon(
        _getIconForType() ?? widget.activity.provider.icon(context),
        color: color,
        size: 22,
      ),
    );
  }

  IconData? _getIconForType() {
    switch (widget.activity.provider.category) {
      case ActivityCategory.commit:
        return Icons.terminal_rounded;
      case ActivityCategory.revision:
        return Icons.code_rounded;
      case ActivityCategory.task:
        return Icons.task_alt_rounded;
      case ActivityCategory.generic:
        return null; // Will fallback to the default provider icon
    }
  }

  String _formatDate() {
    final now = DateTime.now();
    final difference = now.difference(widget.activity.createdAt);

    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'just now';
    }
  }

  Future<void> _launchUrl() async {
    final url = widget.activity.url;
    if (url != null && await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    }
  }
}
