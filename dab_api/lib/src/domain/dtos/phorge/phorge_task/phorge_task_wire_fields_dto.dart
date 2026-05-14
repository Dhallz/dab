import 'package:dart_mappable/dart_mappable.dart';

part 'phorge_task_wire_fields_dto.mapper.dart';

/// [ARCH: DOMAIN_DTO]
/// ROLE: Nested `fields` map from Conduit `maniphest.search` rows.
/// CONTRACT: [`title`] mirrors Conduit’s object field (`Object Fields`). Omit or null ⇒ null here. Display helpers on [OnPhorgeTaskDto].
@MappableClass()
class PhorgeTaskWireFieldsDto with PhorgeTaskWireFieldsDtoMappable {
  @MappableField(key: 'title')
  final String? title;

  final String? uri;

  final String? ownerPHID;

  /// Epoch seconds (`fields.dateModified`).
  final int? dateModified;

  const PhorgeTaskWireFieldsDto({
    this.title,
    this.uri,
    this.ownerPHID,
    this.dateModified,
  });
}
