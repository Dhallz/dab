import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../domain/entities/activity/activity.dart';
import '../../../../presentation/core/extensions/activity_extensions.dart';
import '../../../../presentation/core/styles/app_colors.dart';
import '../../../../presentation/core/styles/app_icons.dart';
import '../../auth/widgets/auth_glass_card.dart';
import 'activity_provider_icon.dart';

/// [ARCH: PRESENTATION_WIDGET]
/// ROLE: Visual card displaying a single activity with provider info and
/// content. Exposes archive/unarchive triage via an optional trailing action.
class DabActivityCard extends StatefulWidget {
  final Activity activity;

  /// Callback fired when the user requests to archive this activity. When
  /// `null`, no archive action is rendered (used outside the dashboard).
  final VoidCallback? onArchive;

  /// Callback fired when the user requests to un-archive this activity.
  final VoidCallback? onUnarchive;

  const DabActivityCard({
    super.key,
    required this.activity,
    this.onArchive,
    this.onUnarchive,
  });

  @override
  State<DabActivityCard> createState() => _DabActivityCardState();
}

class _DabActivityCardState extends State<DabActivityCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final style = widget.activity.style(context);
    final theme = Theme.of(context);
    final showsTriage =
        widget.onArchive != null || widget.onUnarchive != null;

    return Semantics(
      label: widget.activity.archived
          ? 'Archived activity: ${widget.activity.title}'
          : 'Activity: ${widget.activity.title}',
      child: MouseRegion(
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
          child: Opacity(
            opacity: widget.activity.archived ? 0.55 : 1,
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
                        ActivityProviderIcon(
                          activity: widget.activity,
                          color: style.color,
                        ),
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
                                  if (widget.activity.archived) ...[
                                    const SizedBox(width: 8),
                                    _ArchivedBadge(color: style.color),
                                  ],
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
                        if (showsTriage) _buildTriageAction(context),
                        Icon(
                          AppIcons.chevronRight,
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
        ),
      ),
    );
  }

  Widget _buildTriageAction(BuildContext context) {
    if (widget.activity.archived && widget.onUnarchive != null) {
      return IconButton(
        tooltip: 'Unarchive',
        icon: Icon(AppIcons.refresh),
        color: AppColors.onSurfaceVariant,
        onPressed: widget.onUnarchive,
      );
    }
    if (!widget.activity.archived && widget.onArchive != null) {
      return IconButton(
        tooltip: 'Archive',
        icon: Icon(AppIcons.delete),
        color: AppColors.onSurfaceVariant,
        onPressed: widget.onArchive,
      );
    }
    return const SizedBox(width: 0);
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

class _ArchivedBadge extends StatelessWidget {
  final Color color;
  const _ArchivedBadge({required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        'ARCHIVED',
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: color,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.0,
              fontSize: 10,
            ),
      ),
    );
  }
}
