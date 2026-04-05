import 'package:dart_mappable/dart_mappable.dart';
import 'activity.dart';

part 'activity_provider.mapper.dart';

/// [ARCH: DOMAIN_ENTITY]
/// ROLE: Discriminated union for platform-specific activity metadata.
/// CONTRACT: Sealed hierarchy representing the specific "Type" of an Activity.
/// CONSTRAINTS: Must be exhaustive. Used for type-safe UI rendering.
@MappableClass()
class SprintContext with SprintContextMappable {
  final String tag;
  final String? columnFrom;
  final String? columnTo;

  const SprintContext({required this.tag, this.columnFrom, this.columnTo});
}

@MappableClass()
sealed class ActivityProvider with ActivityProviderMappable {
  const ActivityProvider();

  String get name;
  ActivityCategory get category;
}

@MappableClass()
class PhorgeTaskProvider extends ActivityProvider
    with PhorgeTaskProviderMappable {
  final String? taskPhid;
  final String? tags;
  final SprintContext? sprintContext;

  const PhorgeTaskProvider({this.taskPhid, this.tags, this.sprintContext});

  @override
  String get name => 'Phorge';

  @override
  ActivityCategory get category => ActivityCategory.task;
}

@MappableClass()
class PhorgeRevisionProvider extends ActivityProvider
    with PhorgeRevisionProviderMappable {
  final String? revisionId;

  const PhorgeRevisionProvider({this.revisionId});

  @override
  String get name => 'Phorge';

  @override
  ActivityCategory get category => ActivityCategory.revision;
}

@MappableClass()
class GitHubCommitProvider extends ActivityProvider
    with GitHubCommitProviderMappable {
  final String? repo;
  final String? branch;

  const GitHubCommitProvider({this.repo, this.branch});

  @override
  String get name => 'GitHub';

  @override
  ActivityCategory get category => ActivityCategory.commit;
}

@MappableClass()
class GenericProvider extends ActivityProvider with GenericProviderMappable {
  @override
  final String name;

  @override
  final ActivityCategory category;

  const GenericProvider({
    required this.name,
    this.category = ActivityCategory.generic,
  });
}
