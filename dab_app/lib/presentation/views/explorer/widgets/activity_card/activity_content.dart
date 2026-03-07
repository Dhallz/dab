import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../../domain/entities/activity.dart';
import '../../../../../presentation/core/styles/app_colors.dart';

class ActivityContent extends StatelessWidget {
  final Activity activity;
  final bool isExpanded;
  final Color accentColor;

  const ActivityContent({
    super.key,
    required this.activity,
    required this.isExpanded,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedSize(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOutCubic,
      alignment: Alignment.topCenter,
      child: isExpanded
          ? MarkdownBody(
              data: _processMarkdown(activity.content),
              styleSheet: _getMarkdownStyleSheet(isExpanded, accentColor),
              onTapLink: (text, href, title) {
                if (href != null) {
                  launchUrl(Uri.parse(href));
                }
              },
            )
          : Text(
              _getPlainText(activity.content),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.onSurfaceVariantLow,
                height: 1.5,
              ),
            ),
    );
  }

  String _getPlainText(String markdown) {
    return markdown
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

  MarkdownStyleSheet _getMarkdownStyleSheet(bool expanded, Color accentColor) {
    return MarkdownStyleSheet(
      p: TextStyle(
        fontSize: 14,
        color: AppColors.onSurfaceVariantLow,
        height: 1.5,
        fontWeight: expanded ? FontWeight.w500 : FontWeight.normal,
      ),
      h1: const TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: AppColors.onSurface,
      ),
      h2: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: AppColors.onSurface,
      ),
      h3: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: AppColors.onSurface,
      ),
      strong: const TextStyle(
        fontWeight: FontWeight.bold,
        color: AppColors.onSurface,
      ),
      em: const TextStyle(fontStyle: FontStyle.italic),
      code: TextStyle(
        backgroundColor: Colors.white.withValues(alpha: 0.05),
        color: accentColor,
        fontSize: 12,
        fontFamily: 'Roboto Mono',
      ),
      codeblockDecoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
      ),
      blockquote: const TextStyle(
        color: AppColors.onSurfaceVariantLow,
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
      listBullet: const TextStyle(color: AppColors.onSurfaceVariantLow),
    );
  }
}
