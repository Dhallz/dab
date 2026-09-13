import '../usecases/activity/archive_live_activity.dart';
import '../usecases/activity/fetch_remote_activities.dart';
import '../usecases/activity/get_live_activities.dart';
import '../usecases/activity/get_recent_activities.dart';
import '../usecases/activity/ingest_bitbucket_webhook.dart';
import '../usecases/activity/ingest_figma_webhook.dart';
import '../usecases/activity/ingest_github_webhook.dart';
import '../usecases/activity/ingest_gitlab_webhook.dart';
import '../usecases/activity/ingest_jira_webhook.dart';
import '../usecases/activity/ingest_linear_webhook.dart';
import '../usecases/activity/ingest_phorge_webhook.dart';
import '../usecases/activity/ingest_slack_event.dart';
import '../usecases/activity/log_activity.dart';
import '../usecases/activity/search_activities.dart';
import '../usecases/activity/seed_demo_day.dart';
import '../usecases/activity/unarchive_live_activity.dart';

class ActivityUseCases {
  final ArchiveLiveActivity archiveLiveActivity;
  final FetchRemoteActivities fetchRemoteActivities;
  final GetLiveActivities getLiveActivities;
  final GetRecentActivities getRecentActivities;
  final IngestBitbucketWebhook ingestBitbucketWebhook;
  final IngestGitHubWebhook ingestGitHubWebhook;
  final IngestGitLabWebhook ingestGitLabWebhook;
  final IngestJiraWebhook ingestJiraWebhook;
  final IngestLinearWebhook ingestLinearWebhook;
  final IngestFigmaWebhook ingestFigmaWebhook;
  final IngestPhorgeWebhook ingestPhorgeWebhook;
  final IngestSlackEvent ingestSlackEvent;
  final LogActivity logActivity;
  final SearchActivities searchActivities;
  final SeedDemoDay seedDemoDay;
  final UnarchiveLiveActivity unarchiveLiveActivity;

  ActivityUseCases({
    required this.archiveLiveActivity,
    required this.fetchRemoteActivities,
    required this.getLiveActivities,
    required this.getRecentActivities,
    required this.ingestBitbucketWebhook,
    required this.ingestGitHubWebhook,
    required this.ingestGitLabWebhook,
    required this.ingestJiraWebhook,
    required this.ingestLinearWebhook,
    required this.ingestFigmaWebhook,
    required this.ingestPhorgeWebhook,
    required this.ingestSlackEvent,
    required this.logActivity,
    required this.searchActivities,
    required this.seedDemoDay,
    required this.unarchiveLiveActivity,
  });
}
