import 'package:dart_mappable/dart_mappable.dart';

part 'phorge_revision_data.mapper.dart';

/// [ARCH: DOMAIN_MODEL]
/// ROLE: Raw technical representation of a Phorge Differential Revision (Code Review).
/// CONTRACT: Corresponds to a `differential.revision.search` entry in the Phorge API.
/// CONSTRAINTS: Must be serializable (Mappable). Used for mapping activities that represent code changes.
@MappableClass()
class PhorgeRevisionData with PhorgeRevisionDataMappable {
  /// The numeric revision ID (e.g. 123 for D123).
  final int id;
  
  /// The Phorge PHID (Global UID) for this revision.
  final String phid;
  
  /// The PHID of the user who authored this revision.
  final String authorPHID;
  
  /// The summary title of the code review.
  final String title;
  
  /// The direct URI to the revision in Phorge.
  final String uri;
  
  /// The human-readable status name (e.g. 'Needs Review', 'Accepted').
  final String statusName;
  
  /// When the revision was last modified in Phorge.
  final DateTime dateModified;

  const PhorgeRevisionData({
    required this.id,
    required this.phid,
    required this.authorPHID,
    required this.title,
    required this.uri,
    required this.statusName,
    required this.dateModified,
  });
}
