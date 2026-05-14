import 'package:dab_api/src/domain/dtos/phorge/phorge_task/phorge_task_wire_default_string_hook.dart';
import 'package:dart_mappable/dart_mappable.dart';

part 'phorge_task_wire_fields.mapper.dart';

/// [ARCH: DOMAIN_DTO]
/// ROLE: Nested `fields` map from Conduit `maniphest.search` rows.
/// CONTRACT: [dateModified] is epoch seconds when present (`fields.dateModified` on wire).
@MappableClass()
class PhorgeTaskWireFields with PhorgeTaskWireFieldsMappable {
  @MappableField(hook: PhorgeTaskWireDefaultStringHook('Unknown'))
  final String name;

  @MappableField(hook: PhorgeTaskWireDefaultStringHook(''))
  final String uri;

  @MappableField(hook: PhorgeTaskWireDefaultStringHook('system'))
  final String ownerPHID;

  /// Epoch seconds; absent keys decode as null (no synthetic DateTime until [PhorgeTaskData.dateModified] getter).
  final int? dateModified;

  const PhorgeTaskWireFields({
    required this.name,
    required this.uri,
    required this.ownerPHID,
    this.dateModified,
  });
}
