import 'package:dab_api/src/application/services/connector_registry.dart';
import 'package:dab_api/src/domain/mappers/discord/discord_message_mapper.dart';
import 'package:dab_api/src/domain/mappers/github/github_commit_mapper.dart';
import 'package:dab_api/src/domain/mappers/jira/jira_issue_mapper.dart';
import 'package:dab_api/src/domain/mappers/linear/linear_issue_mapper.dart';
import 'package:dab_api/src/domain/mappers/phorge/phorge_revision_mapper.dart';
import 'package:dab_api/src/domain/mappers/phorge/phorge_task_mapper.dart';
import 'package:dab_api/src/domain/mappers/slack/slack_message_mapper.dart';
import 'package:dab_api/src/domain/mappers/teams/teams_message_mapper.dart';
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
/// CONTRACT: Call once during composition root setup after sources and mappers exist.

void registerActivityConnectors({
  required ConnectorRegistry registry,
  required PhorgeTaskSource phorgeTaskSource,
  required PhorgeTaskMapper phorgeTaskMapper,
  required PhorgeRevisionSource phorgeRevisionSource,
  required PhorgeRevisionMapper phorgeRevisionMapper,
  required SlackMessageSource slackSource,
  required SlackMessageMapper slackMapper,
  required TeamsMessageSource teamsSource,
  required TeamsMessageMapper teamsMapper,
  required JiraIssueSource jiraSource,
  required JiraIssueMapper jiraMapper,
  required LinearIssueSource linearSource,
  required LinearIssueMapper linearMapper,
  required DiscordMessageSource discordSource,
  required DiscordMessageMapper discordMapper,
  required GitHubCommitSource githubSource,
  required GitHubCommitMapper githubMapper,
}) {
  registry.register(phorgeTaskSource, phorgeTaskMapper);
  registry.register(phorgeRevisionSource, phorgeRevisionMapper);
  registry.register(slackSource, slackMapper);
  registry.register(teamsSource, teamsMapper);
  registry.register(jiraSource, jiraMapper);
  registry.register(linearSource, linearMapper);
  registry.register(discordSource, discordMapper);
  registry.register(githubSource, githubMapper);
}
