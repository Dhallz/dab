import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../domain/core/activity_follow_key.dart';
import '../../../../domain/entities/activity/activity.dart';
import '../../../../presentation/core/extensions/activity_category_l10n.dart';
import '../../../../presentation/core/extensions/activity_extensions.dart';
import '../../../../presentation/core/localization/app_localizations.dart';
import '../../../../presentation/core/localization/l10n_extension.dart';
import '../../../../presentation/core/styles/app_icons.dart';
import '../../../../presentation/core/widgets/activity_provider_icon.dart';
import '../../../../presentation/core/widgets/dab_glass_surface.dart';

/// [ARCH: PRESENTATION_WIDGET]
/// ROLE: Visual card displaying a single activity with provider info and
/// content. Exposes archive/unarchive triage via an optional trailing action.
class DashboardActivityCard extends StatefulWidget {
  final Activity activity;

  /// Callback fired when the user requests to archive this activity. When
  /// `null`, no archive action is rendered (used outside the dashboard).
  final VoidCallback? onArchive;

  /// Callback fired when the user requests to un-archive this activity.
  final VoidCallback? onUnarchive;

  /// Callback fired when the user Follows this object. Hidden when the
  /// activity is not followable (git commits).
  final VoidCallback? onFollow;

  /// Callback fired when the user Unfollows this object.
  final VoidCallback? onUnfollow;

  /// Whether this object is already Follow-pinned.
  final bool isFollowing;

  const DashboardActivityCard({
    super.key,
    required this.activity,
    this.onArchive,
    this.onUnarchive,
    this.onFollow,
    this.onUnfollow,
    this.isFollowing = false,
  });

  @override
  State<DashboardActivityCard> createState() => _DashboardActivityCardState();
}

class _DashboardActivityCardState extends State<DashboardActivityCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final style = widget.activity.style(context);
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final showsTriage =
        widget.onArchive != null ||
        widget.onUnarchive != null ||
        _canFollow;
    final trimmedContent = widget.activity.content.trim();
    final showSenderLine =
        widget.activity.authorName.trim().isNotEmpty &&
        (widget.activity.provider is SlackMessageProvider ||
            widget.activity.provider is GitHubCommitProvider);

    final l10n = context.l10n;
    return Semantics(
      label: widget.activity.archived
          ? l10n.activitySemanticsArchived(widget.activity.title)
          : l10n.activitySemanticsActive(widget.activity.title),
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
            child: DabGlassSurface(
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
                          padded: true,
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    widget.activity.provider.category
                                        .abbreviatedLabel(l10n),
                                    style: theme.textTheme.labelSmall?.copyWith(
                                      color: style.color,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 1.2,
                                    ),
                                  ),
                                  if (widget.activity.archived) ...[
                                    const SizedBox(width: 8),
                                    _ArchivedBadge(
                                      color: style.color,
                                      label: l10n.dashboardCardArchivedBadge,
                                    ),
                                  ],
                                  const Spacer(),
                                  Text(
                                    _formatDate(l10n),
                                    style: theme.textTheme.labelSmall?.copyWith(
                                      color: scheme.onSurfaceVariant,
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
                                  color: scheme.onSurface,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              if (showSenderLine) ...[
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    Icon(
                                      AppIcons.user,
                                      size: 14,
                                      color: scheme.onSurfaceVariant,
                                    ),
                                    const SizedBox(width: 6),
                                    Expanded(
                                      child: Text(
                                        'From ${widget.activity.authorName}',
                                        style: theme.textTheme.labelSmall
                                            ?.copyWith(
                                              color: scheme.onSurfaceVariant,
                                              fontWeight: FontWeight.w600,
                                            ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                              if (trimmedContent.isNotEmpty) ...[
                                const SizedBox(height: 4),
                                Text(
                                  widget.activity.content,
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: scheme.onSurfaceVariant,
                                  ),
                                  maxLines: 4,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
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

  bool get _canFollow =>
      followObjectKeyFor(widget.activity.provider) != null &&
      (widget.onFollow != null || widget.onUnfollow != null);

  Widget _buildTriageAction(BuildContext context) {
    final l10n = context.l10n;
    final iconColor = Theme.of(context).colorScheme.onSurfaceVariant;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (_canFollow)
          IconButton(
            tooltip: widget.isFollowing
                ? l10n.activityTooltipFollowing
                : l10n.activityTooltipFollow,
            icon: Icon(
              widget.isFollowing ? AppIcons.following : AppIcons.follow,
            ),
            color: widget.isFollowing
                ? Theme.of(context).colorScheme.primary
                : iconColor,
            onPressed: widget.isFollowing ? widget.onUnfollow : widget.onFollow,
          ),
        if (widget.activity.archived && widget.onUnarchive != null)
          IconButton(
            tooltip: l10n.activityTooltipUnarchive,
            icon: Icon(AppIcons.refresh),
            color: iconColor,
            onPressed: widget.onUnarchive,
          )
        else if (!widget.activity.archived && widget.onArchive != null)
          IconButton(
            tooltip: l10n.activityTooltipArchive,
            icon: Icon(AppIcons.delete),
            color: iconColor,
            onPressed: widget.onArchive,
          ),
      ],
    );
  }

  String _formatDate(AppLocalizations l10n) {
    final now = DateTime.now();
    final difference = now.difference(widget.activity.createdAt);

    if (difference.inDays > 0) {
      return l10n.dashboardRelativeDaysAgo(difference.inDays);
    } else if (difference.inHours > 0) {
      return l10n.dashboardRelativeHoursAgo(difference.inHours);
    } else if (difference.inMinutes > 0) {
      return l10n.dashboardRelativeMinutesAgo(difference.inMinutes);
    } else {
      return l10n.dashboardRelativeJustNow;
    }
  }

  Future<void> _launchUrl() async {
    final provider = widget.activity.provider;
    if (provider is SlackMessageProvider) {
      await _launchSlack(provider);
      return;
    }

    final url = widget.activity.url;
    final uri = url == null ? null : Uri.tryParse(url);
    if (uri != null && await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  Future<void> _launchSlack(SlackMessageProvider provider) async {
    final teamId = provider.workspaceId?.trim();
    final channelId = provider.channelId?.trim();
    final messageTs = provider.messageTs?.trim();

    if (teamId != null && teamId.isNotEmpty) {
      final openWorkspaceUri = Uri(
        scheme: 'slack',
        host: 'open',
        queryParameters: {'team': teamId.toUpperCase()},
      );
      await launchUrl(openWorkspaceUri, mode: LaunchMode.externalApplication);
      await Future<void>.delayed(const Duration(milliseconds: 250));
    }

    if (channelId != null && channelId.isNotEmpty) {
      final channelUri = Uri(
        scheme: 'slack',
        host: 'channel',
        queryParameters: {
          if (teamId != null && teamId.isNotEmpty) 'team': teamId.toUpperCase(),
          'id': channelId,
          if (messageTs != null && messageTs.isNotEmpty) 'message': messageTs,
        },
      );

      if (await canLaunchUrl(channelUri)) {
        await launchUrl(channelUri, mode: LaunchMode.externalApplication);
        return;
      }
    }

    // Last fallback keeps us out of an in-app webview while preserving
    // navigation when Slack deep-link metadata is incomplete.
    final url = widget.activity.url;
    final webUri = url == null ? null : Uri.tryParse(url);
    if (webUri != null && await canLaunchUrl(webUri)) {
      await launchUrl(webUri, mode: LaunchMode.externalApplication);
    }
  }
}

class _ArchivedBadge extends StatelessWidget {
  final Color color;
  final String label;

  const _ArchivedBadge({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
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
