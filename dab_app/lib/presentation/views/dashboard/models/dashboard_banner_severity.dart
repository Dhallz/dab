import 'package:dart_mappable/dart_mappable.dart';

part 'dashboard_banner_severity.mapper.dart';

/// [ARCH: PRESENTATION_MODEL]
/// ROLE: Visual severity hint for the Dashboard banner. Maps loosely to
/// `UpcomingEventPriority` but stays decoupled so the UI layer can tune its
/// palette independently.
@MappableEnum()
enum DashboardBannerSeverity { info, warning, critical }
