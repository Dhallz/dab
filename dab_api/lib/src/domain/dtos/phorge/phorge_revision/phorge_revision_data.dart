import 'package:dab_api/src/domain/dtos/phorge/phorge_revision/phorge_revision_fields.dart';
import 'package:dart_mappable/dart_mappable.dart';

part 'phorge_revision_data.mapper.dart';

/// [ARCH: DOMAIN_DTO]
/// ROLE: One `differential.revision.search` datum — top-level matches Conduit (`id`, `phid`, `fields`).
/// CONTRACT: Decode with [PhorgeRevisionDataMapper.fromMap] after JSON decode; shape matches Conduit rows.
/// CONSTRAINTS: Mappable-generated decode only — no Infrastructure-side field lifting.
@MappableClass()
class PhorgeRevisionData with PhorgeRevisionDataMappable {
  final int id;

  /// The revision PHID (`PHID-DREV-…`).
  final String phid;

  final PhorgeRevisionFields fields;

  const PhorgeRevisionData({
    required this.id,
    required this.phid,
    required this.fields,
  });
}
