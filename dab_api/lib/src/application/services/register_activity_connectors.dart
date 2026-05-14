import 'package:dab_api/src/application/services/connector_registry.dart';
import 'package:dab_api/src/domain/dtos/discord/discord_message_dto.dart';
import 'package:dab_api/src/domain/dtos/github/github_commit_dto.dart';
import 'package:dab_api/src/domain/dtos/jira/jira_issue_dto.dart';
import 'package:dab_api/src/domain/dtos/linear/linear_issue_dto.dart';
import 'package:dab_api/src/domain/dtos/phorge/phorge_revision/on_phorge_revision_data.dart';
import 'package:dab_api/src/domain/dtos/phorge/phorge_revision/phorge_revision_data.dart';
import 'package:dab_api/src/domain/dtos/phorge/phorge_task/on_phorge_task_bundle.dart';
import 'package:dab_api/src/domain/dtos/phorge/phorge_task/phorge_task_bundle.dart';
import 'package:dab_api/src/domain/dtos/slack/slack_message_dto.dart';
import 'package:dab_api/src/domain/dtos/teams/teams_message_dto.dart';
import 'package:dab_api/src/infrastructure/sources/discord/discord_message_source.dart';
import 'package:dab_api/src/infrastructure/sources/github/github_commit_source.dart';
import 'package:dab_api/src/infrastructure/sources/jira/jira_issue_source.dart';
import 'package:dab_api/src/infrastructure/sources/linear/linear_issue_source.dart';
import 'package:dab_api/src/infrastructure/sources/phorge/phorge_revision_source.dart';
import 'package:dab_api/src/infrastructure/sources/phorge/phorge_task_source.dart';
import 'package:dab_api/src/infrastructure/sources/slack/slack_message_source.dart';
import 'package:dab_api/src/infrastructure/sources/teams/teams_message_source.dart';

/// [ARCH: APPLICATION_BOOTSTRAP]
/// ROLE: Single registration site for all activity [TypedConnectorPair]s.
/// CONTRACT: Call once during composition root setup after infrastructure sources exist.

void registerActivityConnectors({
  required ConnectorRegistry registry,
  required PhorgeTaskSource phorgeTaskSource,
  required PhorgeRevisionSource phorgeRevisionSource,
  required SlackMessageSource slackSource,
  required TeamsMessageSource teamsSource,
  required JiraIssueSource jiraSource,
  required LinearIssueSource linearSource,
  required DiscordMessageSource discordSource,
  required GitHubCommitSource githubSource,
}) {
  registry.register<PhorgeTaskBundle>(
    TypedConnectorPair<PhorgeTaskBundle>(
      source: phorgeTaskSource,
      providerId: 'phorge',
      mapItemToActivities: (bundle, users) => bundle.toActivities(users),
    ),
  );
  registry.register<PhorgeRevisionData>(
    TypedConnectorPair<PhorgeRevisionData>(
      source: phorgeRevisionSource,
      providerId: 'phorge',
      mapItemToActivities: (data, users) => data.toActivities(users),
    ),
  );
  registry.register<SlackMessageDto>(
    TypedConnectorPair<SlackMessageDto>(
      source: slackSource,
      providerId: 'slack',
      mapItemToActivities: (dto, users) => dto.toActivities(users),
    ),
  );
  registry.register<TeamsMessageDto>(
    TypedConnectorPair<TeamsMessageDto>(
      source: teamsSource,
      providerId: 'teams',
      mapItemToActivities: (dto, users) => dto.toActivities(users),
    ),
  );
  registry.register<JiraIssueDto>(
    TypedConnectorPair<JiraIssueDto>(
      source: jiraSource,
      providerId: 'jira',
      mapItemToActivities: (dto, users) => dto.toActivities(users),
    ),
  );
  registry.register<LinearIssueDto>(
    TypedConnectorPair<LinearIssueDto>(
      source: linearSource,
      providerId: 'linear',
      mapItemToActivities: (dto, users) => dto.toActivities(users),
    ),
  );
  registry.register<DiscordMessageDto>(
    TypedConnectorPair<DiscordMessageDto>(
      source: discordSource,
      providerId: 'discord',
      mapItemToActivities: (dto, users) => dto.toActivities(users),
    ),
  );
  registry.register<GitHubCommitDto>(
    TypedConnectorPair<GitHubCommitDto>(
      source: githubSource,
      providerId: 'github',
      mapItemToActivities: (dto, users) => dto.toActivities(users),
    ),
  );
}
