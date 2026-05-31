import 'package:dart_mappable/dart_mappable.dart';

import '../sprint_context.dart';
import 'activity_category.dart';

part 'activity_provider.mapper.dart';

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
class JiraIssueProvider extends ActivityProvider with JiraIssueProviderMappable {
  final String? issueKey;
  final String? projectKey;
  final String? statusName;

  const JiraIssueProvider({this.issueKey, this.projectKey, this.statusName});

  @override
  String get name => 'Jira';

  @override
  ActivityCategory get category => ActivityCategory.task;
}

@MappableClass()
class SlackMessageProvider extends ActivityProvider
    with SlackMessageProviderMappable {
  final String? workspaceId;
  final String? channelId;
  final String? threadTs;
  final String? messageTs;

  const SlackMessageProvider({
    this.workspaceId,
    this.channelId,
    this.threadTs,
    this.messageTs,
  });

  @override
  String get name => 'Slack';

  @override
  ActivityCategory get category => ActivityCategory.message;
}

@MappableClass()
class TeamsMessageProvider extends ActivityProvider
    with TeamsMessageProviderMappable {
  final String? tenantId;
  final String? teamId;
  final String? channelId;
  final String? messageId;
  final String? replyToId;

  const TeamsMessageProvider({
    this.tenantId,
    this.teamId,
    this.channelId,
    this.messageId,
    this.replyToId,
  });

  @override
  String get name => 'Teams';

  @override
  ActivityCategory get category => ActivityCategory.message;
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
