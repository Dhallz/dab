import 'package:dab_api/src/domain/dtos/phorge/phorge_revision/phorge_revision_status_fields.dart';
import 'package:dart_mappable/dart_mappable.dart';

part 'phorge_revision_fields.mapper.dart';

/// [ARCH: DOMAIN_DTO]
/// ROLE: Nested `fields` object from `differential.revision.search` rows.
/// CONTRACT: Shapes match Conduit (`authorPHID`, `title`, `uri`, `dateModified` in seconds, `status`).
@MappableClass()
class PhorgeRevisionFields with PhorgeRevisionFieldsMappable {
  final String authorPHID;
  final String title;
  final String uri;

  /// Epoch seconds (Conduit `fields.dateModified`; wire int).
  final int dateModified;

  final PhorgeRevisionStatusFields status;

  const PhorgeRevisionFields({
    required this.authorPHID,
    required this.title,
    required this.uri,
    required this.dateModified,
    required this.status,
  });
}
