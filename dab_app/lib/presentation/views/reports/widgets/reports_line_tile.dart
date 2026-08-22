import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../domain/core/org_calendar.dart';
import '../../../../domain/entities/user/daily_report_line.dart';
import '../../../core/localization/l10n_extension.dart';
import '../../../core/styles/app_spacing.dart';
import '../../../core/styles/app_text_styles.dart';
import '../../../core/widgets/dab_glass_surface.dart';
import '../../../features/app/app_notifier.dart';
import 'reports_role_chip.dart';

/// [ARCH: PRESENTATION_WIDGET]
/// ROLE: One report row — include checkbox, inbound/authored chip, headline, note.
class ReportsLineTile extends ConsumerStatefulWidget {
  final DailyReportLine line;
  final ValueChanged<bool> onIncludedChanged;
  final ValueChanged<String> onNoteChanged;

  const ReportsLineTile({
    super.key,
    required this.line,
    required this.onIncludedChanged,
    required this.onNoteChanged,
  });

  @override
  ConsumerState<ReportsLineTile> createState() => _ReportsLineTileState();
}

class _ReportsLineTileState extends ConsumerState<ReportsLineTile> {
  late final TextEditingController _noteController;
  late final FocusNode _noteFocus;

  @override
  void initState() {
    super.initState();
    _noteController = TextEditingController(text: widget.line.note ?? '');
    _noteFocus = FocusNode();
  }

  @override
  void didUpdateWidget(covariant ReportsLineTile oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.line.subjectKey != widget.line.subjectKey) {
      _noteController.text = widget.line.note ?? '';
      return;
    }
    final incoming = widget.line.note ?? '';
    if (!_noteFocus.hasFocus && _noteController.text != incoming) {
      _noteController.text = incoming;
    }
  }

  @override
  void dispose() {
    _noteController.dispose();
    _noteFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final orgTimezoneId = ref.watch(
      appNotifierProvider.select((s) => s.orgTimezoneId),
    );
    final line = widget.line;
    final time = _clock(orgTimezoneId, line.occurredAt);
    final provider = (line.providerId ?? '').trim();
    final headline = (line.title ?? line.subjectKey).trim();
    return DabGlassSurface(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.s,
        AppSpacing.s,
        AppSpacing.m,
        AppSpacing.s,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Checkbox(
                value: line.included,
                onChanged: (value) =>
                    widget.onIncludedChanged(value ?? false),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Wrap(
                      spacing: AppSpacing.xs,
                      runSpacing: AppSpacing.xxs,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        if (time.isNotEmpty)
                          Text(
                            time,
                            style: AppTextStyles.labelMedium.copyWith(
                              color: scheme.onSurfaceVariant,
                            ),
                          ),
                        if (provider.isNotEmpty)
                          Text(
                            provider,
                            style: AppTextStyles.labelMedium.copyWith(
                              color: scheme.onSurfaceVariant,
                            ),
                          ),
                        ReportsRoleChip(role: line.role),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.xxs),
                    Text(
                      headline,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: scheme.onSurface,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (line.included) ...[
            const SizedBox(height: AppSpacing.s),
            TextField(
              controller: _noteController,
              focusNode: _noteFocus,
              onChanged: widget.onNoteChanged,
              minLines: 1,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: context.l10n.reportsNoteHint,
                isDense: true,
              ),
            ),
          ],
        ],
      ),
    );
  }

  String _clock(String orgTimezoneId, DateTime? occurredAt) {
    if (occurredAt == null) return '';
    final local = orgLocalFromUtc(orgTimezoneId, occurredAt);
    final hour = local.hour.toString().padLeft(2, '0');
    final minute = local.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }
}
