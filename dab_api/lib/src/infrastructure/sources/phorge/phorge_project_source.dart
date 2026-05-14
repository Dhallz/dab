import 'package:dab_api/src/domain/core/extensions/datetime_extensions.dart';
import 'package:dab_api/src/domain/dtos/phorge/phorge_project_dto.dart';
import 'package:dab_api/src/domain/dtos/phorge/phorge_task_data.dart';
import 'package:dab_api/src/infrastructure/protocols/conduit/conduit_protocol.dart';

/// [ARCH: INFRASTRUCTURE_SOURCE]
/// ROLE: Infrastructure Source for Phorge Projects and Tags.
/// CONTRACT: Fetches raw metadata for organizational boundaries and sprint containers.
/// CONSTRAINTS: Must be READ-ONLY. Logic is restricted to API coordination and DTO mapping.
class PhorgeProjectSource {
  final ConduitProtocol _client;

  PhorgeProjectSource(this._client);

  /// Fetches all active projects/tags for UI filtering within the current Sprint.
  Future<List<PhorgeProjectDto>> fetchActiveSprintProjects(String userPhid) async {
    final sprintTag = DateTime.now().phorgeSprintTag;
    final sprintPhid = await fetchProjectPhidByTag(sprintTag);

    // 1. Fetch all open tasks in the current sprint assigned to the user
    final tasksData = await _client.call('maniphest.search', {
      'constraints': {
        'assigned': [userPhid],
        if (sprintPhid != null) 'projects': [sprintPhid],
        'statuses': ['open'],
      },
    });

    final rawData = tasksData['data'] as List<dynamic>?;
    if (rawData == null || rawData.isEmpty) return [];

    final tasks = rawData
        .map((e) => PhorgeTaskDataMapper.fromMap(e as Map<String, dynamic>))
        .toList();

    // 2. Extract unique Project PHIDs attached to these sprint tasks
    final tagPhids = <String>{};
    for (final task in tasks) {
      tagPhids.addAll(task.projectPHIDs);
    }
    tagPhids.remove(sprintPhid); // Exclude the Sprint tag itself from UI filters

    if (tagPhids.isEmpty) return [];

    // 3. Fetch the metadata for these specific tag PHIDs
    final result = await _client.call('project.search', {
      'constraints': {'phids': tagPhids.toList()},
      'limit': 100,
    });

    final tagsData = result['data'] as List<dynamic>?;
    if (tagsData == null) return [];

    return tagsData
        .map((e) => PhorgeProjectDtoMapper.fromMap(e as Map<String, dynamic>))
        .toList();
  }

  /// Finds a Project PHID by its tag name (e.g. "DS2026-10").
  Future<String?> fetchProjectPhidByTag(String tag) async {
    final result = await _client.call('project.search', {
      'constraints': {'query': tag},
    });
    final data = result['data'] as List<dynamic>?;
    if (data != null && data.isNotEmpty) {
      return (data.first as Map<String, dynamic>)['phid']?.toString();
    }
    return null;
  }
}
