import 'package:dart_mappable/dart_mappable.dart';

part 'phorge_task_wire_fields_dto.mapper.dart';

/// [ARCH: DOMAIN_DTO]
/// ROLE: Nested `fields` map from Conduit `maniphest.search` rows.
/// CONTRACT: Prefer Conduit **`fields.name`** (ApplicationSearch headline), fall back to **`fields.title`**.
@MappableClass()
class PhorgeTaskWireFieldsDto with PhorgeTaskWireFieldsDtoMappable {
  /// Older / alternate Conduit payloads (some installs surface the headline here).
  @MappableField(key: 'title')
  final String? title;

  /// Canonical maniphest headline on modern Phorge/Phorge ApplicationSearch.
  @MappableField(key: 'name')
  final String? name;

  final String? uri;

  final String? ownerPHID;

  /// Epoch seconds (`fields.dateModified`).
  final int? dateModified;

  const PhorgeTaskWireFieldsDto({
    this.title,
    this.name,
    this.uri,
    this.ownerPHID,
    this.dateModified,
  });
}
