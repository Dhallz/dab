import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../../../presentation/core/styles/app_colors.dart';
import 'initials_avatar.dart';

class ActivityAvatar extends StatelessWidget {
  final String authorName;
  final String? avatarUrl;

  const ActivityAvatar({super.key, required this.authorName, this.avatarUrl});

  @override
  Widget build(BuildContext context) {
    final bool hasAvatar = avatarUrl != null && avatarUrl!.isNotEmpty;

    return Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.accentIndigo.withValues(alpha: 0.2),
        border: Border.all(
          color: AppColors.accentIndigo.withValues(alpha: 0.4),
        ),
      ),
      child: ClipOval(
        child: hasAvatar
            ? CachedNetworkImage(
                imageUrl: avatarUrl!,
                placeholder: (context, url) =>
                    InitialsAvatar(authorName: authorName),
                errorWidget: (context, url, error) =>
                    InitialsAvatar(authorName: authorName),
                fit: BoxFit.cover,
              )
            : InitialsAvatar(authorName: authorName),
      ),
    );
  }
}
