import 'package:dart_mappable/dart_mappable.dart';

import '../../../domain/entities/user/daily_report_line.dart';
import '../../core/models/view_status.dart';

part 'reports_state.mapper.dart';

/// [ARCH: PRESENTATION_STATE]
/// ROLE: Snapshot of the Reports authoring surface.
/// CONTRACT: Immutable; exclusively emitted by [ReportsNotifier].
@MappableClass()
class ReportsState with ReportsStateMappable {
  final ViewStatus status;
  final String? errorMessage;
  final String date;
  final bool includeFollowing;
  final List<DailyReportLine> lines;
  final bool persistInFlight;

  const ReportsState({
    this.status = ViewStatus.initial,
    this.errorMessage,
    this.date = '',
    this.includeFollowing = false,
    this.lines = const [],
    this.persistInFlight = false,
  });

  factory ReportsState.initial() => const ReportsState();
}
