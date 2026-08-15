import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../../domain/entities/activity/activity.dart';
import '../../../../../domain/entities/provider/provider_config.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../presentation/core/extensions/activity_category_l10n.dart';
import '../../../../../presentation/core/extensions/activity_extensions.dart';
import '../../../../../presentation/core/localization/app_localizations.dart';
import '../../../../../presentation/core/localization/l10n_extension.dart';
import '../../../../../presentation/core/widgets/activity_provider_icon.dart';
import '../../../../../presentation/features/app/app_notifier.dart';
import 'activity_content.dart';
import 'activity_footer.dart';
import 'activity_link_button.dart';

class ActivityCard extends ConsumerStatefulWidget {
  final Activity activity;
  final List<Activity>? activities;
  final String? resolvedAuthorName;

  const ActivityCard({
    super.key,
    required this.activity,
    this.activities,
    this.resolvedAuthorName,
  });

  @override
  ConsumerState<ActivityCard> createState() => _ActivityCardState();
}

class _ActivityCardState extends ConsumerState<ActivityCard> {
  bool _isHovering = false;

  Future<void> _launchUrl(List<ProviderConfig> configs) async {
    final String? originalUrl = widget.activity.url;
    if (originalUrl == null || originalUrl.trim().isEmpty) return;

    String finalUrl = originalUrl;
    final hasAbsoluteScheme = RegExp(
      r'^[a-zA-Z][a-zA-Z0-9+.-]*://',
    ).hasMatch(originalUrl);

    if (!hasAbsoluteScheme) {
      final String providerName = widget.activity.provider.name.toLowerCase();
      final config =
          configs
              .where((c) => c.id.toLowerCase() == providerName)
              .firstOrNull ??
          configs
              .where((c) => providerName.contains(c.id.toLowerCase()))
              .firstOrNull;

      if (config != null) {
        finalUrl =
            '${config.baseUrl}${originalUrl.startsWith('/') ? '' : '/'}$originalUrl';
      }
    }

    final Uri url = Uri.parse(finalUrl);
    final didLaunch = url.scheme == 'slack'
        ? await _launchSlackUrl(url)
        : await launchUrl(url, mode: LaunchMode.platformDefault);
    if (!didLaunch) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(
          SnackBar(content: Text(context.l10n.explorerCouldNotLaunchUrl)),
        );
      }
    }
  }

  Future<bool> _launchSlackUrl(Uri url) async {
    final teamId = url.queryParameters['team']?.trim();
    if (teamId != null && teamId.isNotEmpty) {
      final openWorkspaceUri = Uri(
        scheme: 'slack',
        host: 'open',
        queryParameters: {'team': teamId.toUpperCase()},
      );
      await launchUrl(openWorkspaceUri, mode: LaunchMode.externalApplication);
      // Give Slack a short moment to switch workspace before opening channel.
      await Future.delayed(const Duration(milliseconds: 250));
    }

    return launchUrl(url, mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final cs = Theme.of(context).colorScheme;
    final configs = ref.watch(appNotifierProvider.select((s) => s.configs));
    final style = widget.activity.style(context);
    final brandColor = widget.activity.brandColor(context);
    final isGitHubCommit = widget.activity.provider is GitHubCommitProvider;
    final displayTitle = _displayTitle(
      widget.activity,
      isGitHubCommit: isGitHubCommit,
    );
    final commitSha = isGitHubCommit
        ? _extractSha(widget.activity.title)
        : null;
    final displayAuthorName =
        widget.resolvedAuthorName?.trim().isNotEmpty == true
        ? widget.resolvedAuthorName!.trim()
        : widget.activity.authorName;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovering = true),
      onExit: (_) => setState(() => _isHovering = false),
      child: AnimatedScale(
        scale: _isHovering ? 1.02 : 1.0,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOutCubic,
        child: Stack(
          fit: StackFit.passthrough,
          children: [
            Positioned(
              left: 0,
              top: 0,
              bottom: 0,
              width: 24,
              child: Container(
                decoration: BoxDecoration(
                  color: brandColor.withValues(alpha: 0.8),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    bottomLeft: Radius.circular(16),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: brandColor.withValues(alpha: 0.4),
                      blurRadius: 8,
                      spreadRadius: -2,
                    ),
                  ],
                ),
              ),
            ),
            Row(
              children: [
                SizedBox(width: 4),
                Expanded(
                  child: Container(
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                      color: cs.surfaceContainerLow.withValues(
                        alpha: _isHovering ? 0.75 : 0.55,
                      ),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: _isHovering
                            ? style.color.withValues(alpha: 0.3)
                            : cs.outline.withValues(alpha: 0.35),
                      ),
                      boxShadow: _isHovering
                          ? [
                              BoxShadow(
                                color: style.color.withValues(alpha: 0.1),
                                blurRadius: 20,
                                spreadRadius: -5,
                              ),
                            ]
                          : [],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                        child: Padding(
                          padding: const EdgeInsets.all(24),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Category Icon (Functional Accent)
                                  Tooltip(
                                    message: l10n.explorerTooltipCategory(
                                      widget.activity.provider.category
                                          .abbreviatedLabel(l10n),
                                    ),
                                    child: Container(
                                      width: 48,
                                      height: 48,
                                      decoration: BoxDecoration(
                                        color: style.color.withValues(
                                          alpha: 0.1,
                                        ),
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(
                                          color: style.color.withValues(
                                            alpha: 0.2,
                                          ),
                                        ),
                                      ),
                                      child: Icon(
                                        style.icon,
                                        color: style.color,
                                        size: 24,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Flexible(
                                              child: Text(
                                                widget.activity.provider.category
                                                    .abbreviatedLabel(l10n),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.bold,
                                                  color: style.color,
                                                  letterSpacing: 0.5,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(width: 8),
                                            Container(
                                              width: 4,
                                              height: 4,
                                              decoration: BoxDecoration(
                                                color:
                                                    cs.surfaceContainerHighest,
                                                shape: BoxShape.circle,
                                              ),
                                            ),
                                            const SizedBox(width: 8),
                                            Text(
                                              _formatDate(
                                                context,
                                                l10n,
                                                widget.activity.createdAt,
                                              ),
                                              style: TextStyle(
                                                fontSize: 10,
                                                color: cs.onSurfaceVariant,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          displayTitle,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: cs.onSurface,
                                            letterSpacing: -0.2,
                                          ),
                                        ),
                                        if (commitSha != null) ...[
                                          const SizedBox(height: 4),
                                          Text(
                                            commitSha,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: cs.onSurfaceVariant,
                                              fontFamily: 'Roboto Mono',
                                            ),
                                          ),
                                        ],
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  // Top Right Icons
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      ActivityProviderIcon(
                                        activity: widget.activity,
                                        configs: configs,
                                      ),
                                      if (widget.activity.url != null &&
                                          widget.activity.url!
                                              .trim()
                                              .isNotEmpty) ...[
                                        const SizedBox(height: 12),
                                        ActivityLinkButton(
                                          accentColor: style.color,
                                          onTap: () => _launchUrl(configs),
                                          isVisible: _isHovering,
                                        ),
                                      ],
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              // Content Section
                              ActivityContent(
                                activity: widget.activity,
                                activities: widget.activities,
                                isExpanded: _isHovering,
                                accentColor: style.color,
                              ),
                              const SizedBox(height: 16),
                              // Footer Section
                              ActivityFooter(
                                activity: widget.activity,
                                activities: widget.activities,
                                displayAuthorName: displayAuthorName,
                                providerAuthorName: widget.activity.authorName,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(
    BuildContext context,
    AppLocalizations l10n,
    DateTime date,
  ) {
    final now = DateTime.now();
    final difference = now.difference(date);
    if (difference.inDays > 7) {
      return DateFormat.yMMMd(
        Localizations.localeOf(context).toString(),
      ).format(date);
    }
    if (difference.inDays > 0) {
      return l10n.dashboardRelativeDaysAgo(difference.inDays);
    }
    if (difference.inHours > 0) {
      return l10n.dashboardRelativeHoursAgo(difference.inHours);
    }
    if (difference.inMinutes > 0) {
      return l10n.dashboardRelativeMinutesAgo(difference.inMinutes);
    }
    return l10n.dashboardRelativeJustNow;
  }

  String _displayTitle(Activity activity, {required bool isGitHubCommit}) {
    if (!isGitHubCommit) {
      return activity.title;
    }

    final commitMessage = activity.content.trim();
    if (commitMessage.isEmpty) {
      return activity.title;
    }

    return commitMessage.split('\n').first.trim();
  }

  String? _extractSha(String input) {
    final match = RegExp(r'\b[0-9a-fA-F]{7,40}\b').firstMatch(input);
    return match?.group(0);
  }
}
