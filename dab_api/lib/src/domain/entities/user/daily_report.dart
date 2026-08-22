import 'package:dart_mappable/dart_mappable.dart';

import 'daily_report_line.dart';

part 'daily_report.mapper.dart';

/// [ARCH: DOMAIN]
/// ROLE: One user's curated org-calendar daily report.
/// CONTRACT: Unique on ([userId], [date]) where [date] is `YYYY-MM-DD`.
/// [includeFollowing] adds Follow-lane live rows to the authoring pool.
/// Notes stay in DAB; nothing is written back to providers.
@MappableClass()
class DailyReport with DailyReportMappable {
  final String id;
  final String userId;
  final String date;
  final bool includeFollowing;
  final List<DailyReportLine> lines;
  final DateTime? updatedAt;

  const DailyReport({
    required this.id,
    required this.userId,
    required this.date,
    this.includeFollowing = false,
    this.lines = const [],
    this.updatedAt,
  });

  Map<String, dynamic> toApiMap() => {
    'userId': userId,
    'date': date,
    'includeFollowing': includeFollowing,
    'lines': lines.map((line) => line.toApiMap()).toList(),
  };
}
