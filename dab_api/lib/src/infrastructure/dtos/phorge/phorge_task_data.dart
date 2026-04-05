import 'package:dart_mappable/dart_mappable.dart';

part 'phorge_task_data.mapper.dart';

/// [ARCH: INFRASTRUCTURE_DTO]
/// ROLE: Raw technical representation of a Phorge Maniphest Task.
/// CONTRACT: Corresponds to a `maniphest.search` entry in the Phorge API.
/// CONSTRAINTS: Must be serializable (Mappable). Used for internal caching and mapping.
@MappableClass()
class PhorgeTaskData with PhorgeTaskDataMappable {
  /// The numeric task ID (e.g., 123 for T123).
  final int id;
  
  /// The Phorge PHID (Global UID) for this task.
  final String phid;
  
  /// The summary title of the task.
  final String name;
  
  /// The direct URI to the task in Phorge.
  final String uri;
  
  /// The PHID of the user who currently owns this task.
  final String ownerPHID;
  
  /// The list of project/tag PHIDs associated with this task.
  final List<String> projectPHIDs;
  
  /// When the task was last modified in Phorge.
  final DateTime? dateModified;

  const PhorgeTaskData({
    required this.id,
    required this.phid,
    required this.name,
    required this.uri,
    required this.ownerPHID,
    required this.projectPHIDs,
    this.dateModified,
  });
}
