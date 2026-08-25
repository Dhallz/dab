import 'package:dart_mappable/dart_mappable.dart';

part 'directory_type.mapper.dart';

/// [ARCH: PRESENTATION_CORE]
/// ROLE: Which Directory pane is visible (people vs groups).
@MappableEnum()
enum DirectoryType { users, groups }
