import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:url_launcher/url_launcher.dart';

import '../../../../../domain/entities/activity.dart';
import '../../../../../domain/entities/provider_config.dart';
import '../../../../../presentation/core/extensions/activity_ui_extensions.dart';
import '../../../../../presentation/core/styles/app_colors.dart';
import '../../../../../presentation/features/app/app_cubit.dart';
import '../../../../../presentation/features/app/app_state.dart';
import 'activity_content.dart';
import 'activity_footer.dart';
import 'activity_link_button.dart';
import 'activity_provider_icon.dart';

class ActivityCard extends StatefulWidget {
  final Activity activity;
  final List<Activity>? activities;

  const ActivityCard({super.key, required this.activity, this.activities});

  @override
  State<ActivityCard> createState() => _ActivityCardState();
}

class _ActivityCardState extends State<ActivityCard> {
  bool _isHovering = false;

  Future<void> _launchUrl(List<ProviderConfig> configs) async {
    final String? originalUrl = widget.activity.url;
    if (originalUrl == null || originalUrl.trim().isEmpty) return;

    String finalUrl = originalUrl;

    if (!originalUrl.startsWith('http')) {
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
    if (!await launchUrl(url)) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Could not launch URL')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppCubit, AppState>(
      builder: (context, state) {
        final style = widget.activity.style(context);

        return MouseRegion(
          onEnter: (_) => setState(() => _isHovering = true),
          onExit: (_) => setState(() => _isHovering = false),
          cursor: SystemMouseCursors.click,
          child: AnimatedScale(
            scale: _isHovering ? 1.02 : 1.0,
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOutCubic,
            child: GestureDetector(
              onTap: () => _launchUrl(state.configs),
              child: Container(
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainerLow.withValues(
                    alpha: _isHovering ? 0.6 : 0.4,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: _isHovering
                        ? style.color.withValues(alpha: 0.3)
                        : Colors.white.withValues(alpha: 0.1),
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
                              // Provider Icon / Category
                              Container(
                                width: 48,
                                height: 48,
                                decoration: BoxDecoration(
                                  color: style.color.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: style.color.withValues(alpha: 0.2),
                                  ),
                                ),
                                child: Icon(
                                  style.icon,
                                  color: style.color,
                                  size: 24,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Flexible(
                                          child: Text(
                                            style.label.toUpperCase(),
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
                                          decoration: const BoxDecoration(
                                            color: AppColors
                                                .surfaceContainerHighest,
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          _formatDate(
                                            widget.activity.createdAt,
                                          ),
                                          style: const TextStyle(
                                            fontSize: 10,
                                            color:
                                                AppColors.onSurfaceVariantLow,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      widget.activity.title,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.onSurface,
                                        letterSpacing: -0.2,
                                      ),
                                    ),
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
                                    configs: state.configs,
                                  ),
                                  if (widget.activity.url != null &&
                                      widget.activity.url!
                                          .trim()
                                          .isNotEmpty) ...[
                                    const SizedBox(height: 12),
                                    ActivityLinkButton(
                                      accentColor: style.color,
                                      onTap: () => _launchUrl(state.configs),
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
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);
    if (difference.inDays > 7) {
      return DateFormat('MMM d, y').format(date);
    }
    return timeago.format(date);
  }
}
