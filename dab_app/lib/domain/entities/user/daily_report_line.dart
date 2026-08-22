import 'package:dart_mappable/dart_mappable.dart';

import 'daily_report_line_role.dart';

part 'daily_report_line.mapper.dart';

/// [ARCH: DOMAIN]
/// ROLE: One curated row on a personal daily report.
/// CONTRACT: [subjectKey] is unique per report. [note] is DAB-only.
@MappableClass()
class DailyReportLine with DailyReportLineMappable {
  final String subjectKey;
  final bool included;
  final String? note;
  final DailyReportLineRole role;
  final String? title;
  final String? url;
  final DateTime? occurredAt;
  final String? providerId;

  const DailyReportLine({
    required this.subjectKey,
    this.included = true,
    this.note,
    this.role = DailyReportLineRole.directed,
    this.title,
    this.url,
    this.occurredAt,
    this.providerId,
  });

  Map<String, dynamic> toApiMap() => {
    'subjectKey': subjectKey,
    'included': included,
    if (note != null && note!.isNotEmpty) 'note': note,
    'role': role.name,
    if (title != null && title!.isNotEmpty) 'title': title,
    if (url != null && url!.isNotEmpty) 'url': url,
    if (occurredAt != null) 'occurredAt': occurredAt!.toUtc().toIso8601String(),
    if (providerId != null && providerId!.isNotEmpty) 'providerId': providerId,
  };

  static DailyReportLine fromApiMap(Map<String, dynamic> map) {
    final occurredRaw = map['occurredAt']?.toString();
    return DailyReportLine(
      subjectKey: (map['subjectKey'] ?? '').toString().trim(),
      included: map['included'] != false,
      note: _optionalText(map['note']),
      role: dailyReportLineRoleFromWire(map['role']?.toString()),
      title: _optionalText(map['title']),
      url: _optionalText(map['url']),
      occurredAt: occurredRaw == null || occurredRaw.isEmpty
          ? null
          : DateTime.tryParse(occurredRaw)?.toUtc(),
      providerId: _optionalText(map['providerId']),
    );
  }
}

String? _optionalText(Object? raw) {
  final value = (raw ?? '').toString().trim();
  return value.isEmpty ? null : value;
}
