import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/styles/app_icons.dart';
import '../reports_notifier.dart';

/// [ARCH: PRESENTATION_WIDGET]
/// ROLE: Compact Directory picker for manager/admin on narrow Reports layouts.
class ReportsUserPicker extends ConsumerWidget {
  const ReportsUserPicker({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final users = ref.watch(
      reportsNotifierProvider.select((s) => s.directoryUsers),
    );
    final viewedUserId = ref.watch(
      reportsNotifierProvider.select((s) => s.viewedUserId),
    );
    if (users.isEmpty) return const SizedBox.shrink();
    final selectedId = users.any((user) => user.id == viewedUserId)
        ? viewedUserId
        : null;
    return DropdownButtonHideUnderline(
      child: DropdownButton<String>(
        value: selectedId,
        isDense: true,
        icon: Icon(AppIcons.user, size: 16),
        items: [
          for (final user in users)
            DropdownMenuItem(value: user.id, child: Text(user.name)),
        ],
        onChanged: (id) {
          if (id != null) {
            ref.read(reportsNotifierProvider.notifier).selectUser(id);
          }
        },
      ),
    );
  }
}
