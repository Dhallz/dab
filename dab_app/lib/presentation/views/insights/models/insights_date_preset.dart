import 'package:dart_mappable/dart_mappable.dart';

part 'insights_date_preset.mapper.dart';

@MappableEnum()
enum InsightsDatePreset { today, last7Days, last30Days, custom }
