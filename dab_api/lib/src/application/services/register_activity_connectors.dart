import 'package:dab_api/src/application/services/connector_registry.dart';
import 'package:dab_api/src/domain/dtos/bitbucket/bitbucket_commit_dto.dart';
import 'package:dab_api/src/domain/dtos/discord/discord_message_dto.dart';
import 'package:dab_api/src/domain/dtos/figma/figma_file_dto.dart';
import 'package:dab_api/src/domain/dtos/github/github_commit_dto.dart';
import 'package:dab_api/src/domain/dtos/gitlab/gitlab_commit_dto.dart';
import 'package:dab_api/src/domain/dtos/jira/jira_issue_dto.dart';
import 'package:dab_api/src/domain/dtos/linear/linear_issue_dto.dart';
import 'package:dab_api/src/domain/dtos/phorge/phorge_revision/phorge_revision_dto.dart';
import 'package:dab_api/src/domain/dtos/phorge/phorge_task/phorge_task_bundle_dto.dart';
import 'package:dab_api/src/domain/dtos/slack/slack_message_dto.dart';
import 'package:dab_api/src/infrastructure/sources/bitbucket/bitbucket_commit_source.dart';
import 'package:dab_api/src/infrastructure/sources/discord/discord_message_source.dart';
import 'package:dab_api/src/infrastructure/sources/figma/figma_file_source.dart';
import 'package:dab_api/src/infrastructure/sources/github/github_commit_source.dart';
import 'package:dab_api/src/infrastructure/sources/gitlab/gitlab_commit_source.dart';
import 'package:dab_api/src/infrastructure/sources/jira/jira_issue_source.dart';
import 'package:dab_api/src/infrastructure/sources/linear/linear_issue_source.dart';
import 'package:dab_api/src/infrastructure/sources/phorge/phorge_revision_source.dart';
import 'package:dab_api/src/infrastructure/sources/phorge/phorge_task_source.dart';
import 'package:dab_api/src/infrastructure/sources/slack/slack_message_source.dart';

/// [ARCH: APPLICATION_BOOTSTRAP]
/// ROLE: Single registration site for all activity [TypedConnectorPair]s.
/// CONTRACT: Call once during composition root setup after infrastructure sources exist.

void registerActivityConnectors({
  required ConnectorRegistry registry,
  required PhorgeTaskSource phorgeTaskSource,
  required PhorgeRevisionSource phorgeRevisionSource,
  required SlackMessageSource slackSource,
  required JiraIssueSource jiraSource,
  required LinearIssueSource linearSource,
  required DiscordMessageSource discordSource,
  required GitHubCommitSource githubSource,
  required GitLabCommitSource gitlabSource,
  required BitbucketCommitSource bitbucketSource,
  required FigmaFileSource figmaSource,
}) {
  registry.register<PhorgeTaskBundleDto>(
    TypedConnectorPair<PhorgeTaskBundleDto>(
      port: phorgeTaskSource,
      providerId: 'phorge',
      mapItemToActivities: (bundle, users) => bundle.toActivities(users),
    ),
  );
  registry.register<PhorgeRevisionDto>(
    TypedConnectorPair<PhorgeRevisionDto>(
      port: phorgeRevisionSource,
      providerId: 'phorge',
      mapItemToActivities: (data, users) => data.toActivities(users),
    ),
  );
  registry.register<SlackMessageDto>(
    TypedConnectorPair<SlackMessageDto>(
      port: slackSource,
      providerId: 'slack',
      mapItemToActivities: (dto, users) => dto.toActivities(users),
    ),
  );
  registry.register<JiraIssueDto>(
    TypedConnectorPair<JiraIssueDto>(
      port: jiraSource,
      providerId: 'jira',
      mapItemToActivities: (dto, users) => dto.toActivities(users),
    ),
  );
  registry.register<LinearIssueDto>(
    TypedConnectorPair<LinearIssueDto>(
      port: linearSource,
      providerId: 'linear',
      mapItemToActivities: (dto, users) => dto.toActivities(users),
    ),
  );
  registry.register<DiscordMessageDto>(
    TypedConnectorPair<DiscordMessageDto>(
      port: discordSource,
      providerId: 'discord',
      mapItemToActivities: (dto, users) => dto.toActivities(users),
    ),
  );
  registry.register<GitHubCommitDto>(
    TypedConnectorPair<GitHubCommitDto>(
      port: githubSource,
      providerId: 'github',
      mapItemToActivities: (dto, users) => dto.toActivities(users),
    ),
  );
  registry.register<GitLabCommitDto>(
    TypedConnectorPair<GitLabCommitDto>(
      port: gitlabSource,
      providerId: 'gitlab',
      mapItemToActivities: (dto, users) => dto.toActivities(users),
    ),
  );
  registry.register<BitbucketCommitDto>(
    TypedConnectorPair<BitbucketCommitDto>(
      port: bitbucketSource,
      providerId: 'bitbucket',
      mapItemToActivities: (dto, users) => dto.toActivities(users),
    ),
  );
  registry.register<FigmaFileDto>(
    TypedConnectorPair<FigmaFileDto>(
      port: figmaSource,
      providerId: 'figma',
      mapItemToActivities: (dto, users) => dto.toActivities(users),
    ),
  );
}
