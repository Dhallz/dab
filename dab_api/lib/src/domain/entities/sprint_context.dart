import 'package:dart_mappable/dart_mappable.dart';

part 'sprint_context.mapper.dart';

@MappableClass()
class SprintContext with SprintContextMappable {
  final String tag;
  final String? columnFrom;
  final String? columnTo;

  const SprintContext({required this.tag, this.columnFrom, this.columnTo});
}
