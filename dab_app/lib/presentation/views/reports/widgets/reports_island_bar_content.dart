import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/localization/l10n_extension.dart';
import '../../../core/widgets/view_toolbar.dart';
import '../reports_notifier.dart';
import 'reports_lock_status.dart';
import 'reports_user_picker.dart';

/// [ARCH: PRESENTATION_WIDGET]
/// ROLE: Reports toolbar — lock status, Save, copy/download.
class ReportsIslandBarContent extends ConsumerWidget {
  final bool showUserPicker;

  const ReportsIslandBarContent({super.key, this.showUserPicker = false});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isReadOnly = ref.watch(
      reportsNotifierProvider.select((s) => s.isReadOnly),
    );
    final isOwnReport = ref.watch(
      reportsNotifierProvider.select((s) => s.isOwnReport),
    );
    final date = ref.watch(reportsNotifierProvider.select((s) => s.date));
    final canBrowseTeam = ref.watch(
      reportsNotifierProvider.select((s) => s.canBrowseTeam),
    );
    final canSave = ref.watch(
      reportsNotifierProvider.select((s) => s.canSave),
    );
    final persistInFlight = ref.watch(
      reportsNotifierProvider.select((s) => s.persistInFlight),
    );
    final notifier = ref.read(reportsNotifierProvider.notifier);
    return ViewToolbar(
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (!isReadOnly)
            FilledButton(
              onPressed: canSave
                  ? () async {
                      await notifier.save();
                      if (!context.mounted) return;
                      final saved = !ref.read(reportsNotifierProvider).isDirty;
                      if (!saved) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(context.l10n.reportsSaved)),
                      );
                    }
                  : null,
              child: persistInFlight
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Text(context.l10n.reportsSave),
            ),
          if (!isReadOnly) const SizedBox(width: 8),
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
        if (showUserPicker && canBrowseTeam) const ReportsUserPicker(),
        if (isOwnReport && date.isNotEmpty) const ReportsLockStatus(),
      ],
    );
  }
}
