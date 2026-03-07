import 'package:flutter/material.dart';

import '../../../../../presentation/core/styles/app_colors.dart';
import 'activity_avatar.dart';

class ActivityFooter extends StatelessWidget {
  final String authorName;
  final String? authorAvatarUrl;
  final int commentCount;

  const ActivityFooter({
    super.key,
    required this.authorName,
    this.authorAvatarUrl,
    required this.commentCount,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Author Avatar
        ActivityAvatar(authorName: authorName, avatarUrl: authorAvatarUrl),
        const SizedBox(width: 8),
        Text(
          authorName,
          style: const TextStyle(
            fontSize: 12,
            color: AppColors.onSurfaceVariant,
            fontWeight: FontWeight.w500,
          ),
        ),
        const Spacer(),
        // Comments
        if (commentCount > 0) ...[
          const Icon(
            Icons.chat_bubble_outline_rounded,
            size: 14,
            color: AppColors.outlineVariant,
          ),
          const SizedBox(width: 4),
          Text(
            '$commentCount ${commentCount == 1 ? 'comment' : 'comments'}',
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.outlineVariant,
            ),
          ),
        ],
      ],
    );
  }
}
