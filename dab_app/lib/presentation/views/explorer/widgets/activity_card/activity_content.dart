import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../../domain/entities/activity/activity.dart';
import 'activity_history_list.dart';

class ActivityContent extends StatelessWidget {
  final Activity activity;
  final List<Activity>? activities;
  final bool isExpanded;
  final Color accentColor;

  const ActivityContent({
    super.key,
    required this.activity,
    this.activities,
    required this.isExpanded,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final hasHistory = activities != null && activities!.length > 1;
    final displayContent = _resolveDisplayContent(activity);
    final plainPreview = _getPlainText(displayContent);
    final hasDisplayContent = plainPreview.isNotEmpty;

    return AnimatedSize(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOutCubic,
      alignment: Alignment.topCenter,
      child: isExpanded && hasHistory
          ? ActivityHistoryList(
              activities: activities!,
              accentColor: accentColor,
            )
          : (isExpanded
                ? (hasDisplayContent
                      ? Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: MarkdownBody(
                            data: _processMarkdown(displayContent),
                            styleSheet: _getMarkdownStyleSheet(
                              context,
                              isExpanded,
                              accentColor,
                            ),
                            onTapLink: (text, href, title) {
                              if (href != null) {
                                launchUrl(Uri.parse(href));
                              }
                            },
                          ),
                        )
                      : const SizedBox.shrink())
                : (hasDisplayContent
                      ? Text(
                          plainPreview,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 14,
                            color: cs.onSurfaceVariant,
                            height: 1.5,
                          ),
                        )
                      : const SizedBox.shrink())),
    );
  }

  String _resolveDisplayContent(Activity activity) {
    if (activity.provider is! GitHubCommitProvider) {
      return activity.content;
    }

    final content = activity.content.trim();
    if (content.isEmpty) {
      return '';
    }

    final lines = content.split('\n');
    if (lines.length <= 1) {
      return '';
    }

    return lines.skip(1).join('\n').trim();
  }

  String _getPlainText(String markdown) {
    if (markdown.isEmpty) return '';

    // Truncate first to avoid expensive regex on large strings
    final effectiveContent = markdown.length > 300
        ? markdown.substring(0, 300)
        : markdown;

    return effectiveContent
        .replaceAll(RegExp(r'\*\*|__'), '') // Bold
        .replaceAll(RegExp(r'\*|_'), '') // Italic
        .replaceAll(RegExp(r'\[([^\]]+)\]\([^\)]+\)'), r'$1') // Links
        .replaceAll(RegExp(r'#+\s'), '') // Headers
        .replaceAll(RegExp(r'`'), '') // Code
        .replaceAll(RegExp(r'\n'), ' ') // Newlines to spaces for preview
        .trim();
  }

  String _processMarkdown(String content) {
    var processed = content;
    if (activity.provider.name.toLowerCase().contains('phorge')) {
      final lines = processed.split('\n');
      final newLines = lines.map((line) {
        if (line.trimLeft().startsWith('#')) {
          return line.replaceFirst('#', '1.');
        }
        return line;
      }).toList();
      processed = newLines.join('\n');
    }
    return processed;
  }

  MarkdownStyleSheet _getMarkdownStyleSheet(
    BuildContext context,
    bool expanded,
    Color accentColor,
  ) {
    final cs = Theme.of(context).colorScheme;
    return MarkdownStyleSheet(
      p: TextStyle(
        fontSize: 14,
        color: cs.onSurfaceVariant,
        height: 1.5,
        fontWeight: expanded ? FontWeight.w500 : FontWeight.normal,
      ),
      h1: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: cs.onSurface,
      ),
      h2: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: cs.onSurface,
      ),
      h3: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: cs.onSurface,
      ),
      strong: TextStyle(
        fontWeight: FontWeight.bold,
        color: cs.onSurface,
      ),
      em: const TextStyle(fontStyle: FontStyle.italic),
      code: TextStyle(
        backgroundColor: cs.onSurface.withValues(alpha: 0.06),
        color: accentColor,
        fontSize: 12,
        fontFamily: 'Roboto Mono',
      ),
      codeblockDecoration: BoxDecoration(
        color: cs.surfaceContainerHighest.withValues(alpha: 0.85),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: cs.outline.withValues(alpha: 0.35)),
      ),
      blockquote: TextStyle(
        color: cs.onSurfaceVariant,
        fontStyle: FontStyle.italic,
      ),
      blockquoteDecoration: BoxDecoration(
        border: Border(left: BorderSide(color: accentColor, width: 4)),
      ),
      a: TextStyle(
        color: accentColor,
        decoration: TextDecoration.underline,
        decorationColor: accentColor.withValues(alpha: 0.5),
      ),
      listBullet: TextStyle(color: cs.onSurfaceVariant),
    );
  }
}
