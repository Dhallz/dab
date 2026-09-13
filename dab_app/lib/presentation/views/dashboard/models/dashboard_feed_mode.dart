import 'package:dart_mappable/dart_mappable.dart';

part 'dashboard_feed_mode.mapper.dart';

/// [ARCH: PRESENTATION]
/// ROLE: How the Dashboard Live Now feed is laid out.
@MappableEnum()
enum DashboardFeedMode { timeline, category, provider }
