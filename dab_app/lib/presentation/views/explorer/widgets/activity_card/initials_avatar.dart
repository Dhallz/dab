import 'package:flutter/material.dart';

class InitialsAvatar extends StatelessWidget {
  final String authorName;

  const InitialsAvatar({super.key, required this.authorName});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final String initials = authorName.isNotEmpty
        ? authorName
              .trim()
              .split(' ')
              .map((e) => e.isNotEmpty ? e[0].toUpperCase() : '')
              .take(2)
              .join()
        : '?';

    return Center(
      child: Text(
        initials,
        style: TextStyle(
          color: cs.primary,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
