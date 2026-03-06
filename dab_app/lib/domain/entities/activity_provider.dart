import 'package:dart_mappable/dart_mappable.dart';

part 'activity_provider.mapper.dart';

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
  String get category;
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
  String get category => 'task';
}

@MappableClass()
class PhorgeRevisionProvider extends ActivityProvider
    with PhorgeRevisionProviderMappable {
  final String? revisionId;

  const PhorgeRevisionProvider({this.revisionId});

  @override
  String get name => 'Phorge';

  @override
  String get category => 'revision';
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
  String get category => 'commit';
}

@MappableClass()
class GenericProvider extends ActivityProvider with GenericProviderMappable {
  @override
  final String name;

  @override
  final String category;

  const GenericProvider({required this.name, this.category = 'generic'});
}
