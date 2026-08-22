import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/localization/l10n_extension.dart';
import '../../../core/styles/app_text_styles.dart';
import '../../../core/widgets/dab_toggle_chip.dart';
import '../../../core/widgets/view_toolbar.dart';
import '../reports_notifier.dart';

/// [ARCH: PRESENTATION_WIDGET]
/// ROLE: Reports toolbar — today label, Following toggle, copy and download.
class ReportsIslandBarContent extends ConsumerWidget {
  const ReportsIslandBarContent({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scheme = Theme.of(context).colorScheme;
    final date = ref.watch(reportsNotifierProvider.select((s) => s.date));
    final includeFollowing = ref.watch(
      reportsNotifierProvider.select((s) => s.includeFollowing),
    );
    final notifier = ref.read(reportsNotifierProvider.notifier);
    return ViewToolbar(
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextButton(
            onPressed: () async {
              await notifier.copyMarkdown();
              if (!context.mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(context.l10n.reportsCopied)),
              );
            },
            child: Text(context.l10n.reportsCopy),
          ),
          TextButton(
            onPressed: () async {
              final path = await notifier.downloadMarkdown();
              if (!context.mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(context.l10n.reportsDownloaded(path))),
              );
            },
            child: Text(context.l10n.reportsDownload),
          ),
        ],
      ),
      children: [
        Text(
          date.isEmpty ? context.l10n.reportsDateToday : date,
          style: AppTextStyles.titleSmall.copyWith(color: scheme.onSurface),
        ),
        DabToggleChip(
          label: context.l10n.reportsFollowingToggle,
          isSelected: includeFollowing,
          onTap: () => notifier.setIncludeFollowing(!includeFollowing),
        ),
      ],
    );
  }
}
