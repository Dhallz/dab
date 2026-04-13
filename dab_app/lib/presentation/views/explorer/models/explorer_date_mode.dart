import 'package:dart_mappable/dart_mappable.dart';

part 'explorer_date_mode.mapper.dart';

/// [ARCH: PRESENTATION_MODEL]
/// ROLE: Defines the date filtering mode used by Explorer.
@MappableEnum()
enum ExplorerDateMode { singleDay, range }
