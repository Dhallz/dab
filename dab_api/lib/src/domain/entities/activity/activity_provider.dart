import 'package:dart_mappable/dart_mappable.dart';

import '../sprint_context.dart';

part 'activity_provider.mapper.dart';

/// [ARCH: DOMAIN_MODEL]
/// ROLE: Polymorphic base for Platform-specific metadata.
/// CONTRACT: Defines the Identity (Provider) and Nature (Category) of an activity.
/// CONSTRAINTS: Must be a sealed class for type-safe exhaustive matching.
///
/// This hierarchy is the Domain representation of the **Table-Per-Type (TBT)**
/// database pattern. Each subclass corresponds to a specific relational table
/// (e.g. `activity_phorge_task`) that holds metadata unique to that platform.
@MappableClass()
sealed class ActivityProvider with ActivityProviderMappable {
  const ActivityProvider();

  /// The name of the entire platform element (e.g., "Phorge", "GitHub").
  String get name;

  /// The nature of the activity (e.g., "task", "revision", "commit").
  String get category;
}

/// [ARCH: DOMAIN_MODEL]
/// ROLE: Metadata for Phorge Tasks (Maniphest).
/// CONTRACT: Corresponds to the `activity_phorge_task` SQL table.
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

/// [ARCH: DOMAIN_MODEL]
/// ROLE: Metadata for Phorge Revisions (Differential).
/// CONTRACT: Corresponds to the `activity_phorge_revision` SQL table.
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

/// [ARCH: DOMAIN_MODEL]
/// ROLE: Metadata for GitHub Commits.
/// CONTRACT: Corresponds to the `activity_github_commit` SQL table.
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

/// [ARCH: DOMAIN_MODEL]
/// ROLE: Metadata for GitLab Commits.
/// CONTRACT: Corresponds to the `activity_gitlab_commit` SQL table.
@MappableClass()
class GitLabCommitProvider extends ActivityProvider
    with GitLabCommitProviderMappable {
  /// Full project path (`group/project`).
  final String? project;

  final String? branch;

  const GitLabCommitProvider({this.project, this.branch});

  @override
  String get name => 'GitLab';

  @override
  String get category => 'commit';
}

/// [ARCH: DOMAIN_MODEL]
/// ROLE: Metadata for Bitbucket Commits.
/// CONTRACT: Corresponds to the `activity_bitbucket_commit` SQL table.
@MappableClass()
class BitbucketCommitProvider extends ActivityProvider
    with BitbucketCommitProviderMappable {
  /// Full repository path (`workspace/repo`).
  final String? repo;

  final String? branch;

  const BitbucketCommitProvider({this.repo, this.branch});

  @override
  String get name => 'Bitbucket';

  @override
  String get category => 'commit';
}

/// [ARCH: DOMAIN_MODEL]
/// ROLE: Metadata for Jira Issues (Maniphest-style issue tracking).
/// CONTRACT: Corresponds to the `activity_jira_issue` SQL table.
@MappableClass()
class JiraIssueProvider extends ActivityProvider with JiraIssueProviderMappable {
  final String? issueKey;
  final String? projectKey;
  final String? statusName;

  const JiraIssueProvider({this.issueKey, this.projectKey, this.statusName});

  @override
  String get name => 'Jira';

  @override
  String get category => 'task';
}

/// [ARCH: DOMAIN_MODEL]
/// ROLE: Metadata for Linear Issues.
/// CONTRACT: Corresponds to the `activity_linear_issue` SQL table.
@MappableClass()
class LinearIssueProvider extends ActivityProvider
    with LinearIssueProviderMappable {
  /// Human-readable issue key (`ENG-123`).
  final String? identifier;

  /// Team key prefix (`ENG`).
  final String? teamKey;

  final String? statusName;

  const LinearIssueProvider({this.identifier, this.teamKey, this.statusName});

  @override
  String get name => 'Linear';

  @override
  String get category => 'task';
}

/// [ARCH: DOMAIN_MODEL]
/// ROLE: Metadata for Slack Messages.
/// CONTRACT: Corresponds to the `activity_slack_message` SQL table.
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
  String get category => 'message';
}

/// [ARCH: DOMAIN_MODEL]
/// ROLE: Metadata for Discord Messages.
/// CONTRACT: Corresponds to the `activity_discord_message` SQL table.
@MappableClass()
class DiscordMessageProvider extends ActivityProvider
    with DiscordMessageProviderMappable {
  final String? guildId;
  final String? channelId;
  final String? messageId;

  /// Referenced message id when this message is a reply.
  final String? replyToId;

  const DiscordMessageProvider({
    this.guildId,
    this.channelId,
    this.messageId,
    this.replyToId,
  });

  @override
  String get name => 'Discord';

  @override
  String get category => 'message';
}

@MappableClass()
class GenericProvider extends ActivityProvider with GenericProviderMappable {
  @override
  final String name;

  @override
  final String category;

  const GenericProvider({required this.name, this.category = 'generic'});
}
