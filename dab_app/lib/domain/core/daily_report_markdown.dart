import '../entities/user/daily_report.dart';
import '../entities/user/daily_report_line.dart';
import 'org_calendar.dart';

/// [ARCH: DOMAIN]
/// ROLE: Renders a curated daily report as Markdown (no LLM).
/// CONTRACT: Excluded lines are omitted. Notes stay on the line as a quote.
String dailyReportMarkdown({
  required String date,
  required List<DailyReportLine> lines,
  required String orgTimezoneId,
}) {
  final buffer = StringBuffer()..writeln('# Daily report — $date')..writeln();
  final included = lines.where((line) => line.included).toList();
  if (included.isEmpty) {
    buffer.writeln('_No included activity._');
    return buffer.toString();
  }
  for (final line in included) {
    final time = _clock(orgTimezoneId, line.occurredAt);
    final provider = (line.providerId ?? '').trim();
    final headline = (line.title ?? line.subjectKey).trim();
    final parts = <String>[
      if (time.isNotEmpty) '**$time**',
      if (provider.isNotEmpty) provider,
      headline,
    ];
    buffer.writeln('- ${parts.join(' · ')}');
    final note = (line.note ?? '').trim();
    if (note.isNotEmpty) {
      buffer.writeln('  $note');
    }
  }
  return buffer.toString();
}

/// [ARCH: DOMAIN]
/// ROLE: Markdown export for a persisted [DailyReport].
extension OnDailyReportMarkdown on DailyReport {
  String toMarkdown({required String orgTimezoneId}) => dailyReportMarkdown(
    date: date,
    lines: lines,
    orgTimezoneId: orgTimezoneId,
  );
}

String _clock(String orgTimezoneId, DateTime? occurredAt) {
  if (occurredAt == null) return '';
  final local = orgLocalFromUtc(orgTimezoneId, occurredAt);
  final hour = local.hour.toString().padLeft(2, '0');
  final minute = local.minute.toString().padLeft(2, '0');
  return '$hour:$minute';
}
