/// [ARCH: APPLICATION_DTO]
/// ROLE: Outcome envelope for live ingest (webhooks, Slack Events, Discord
/// Gateway). Shared by every ingest use case.
/// CONTRACT: [ingested] is true only when at least one new activity row was
/// persisted. [reason] is `ingested` on success, otherwise a stable ignore
/// token for logs/analytics.
/// CONSTRAINTS: No I/O. Provider-named typedefs keep existing test imports.
class IngestionResult {
  /// Whether at least one activity was newly persisted.
  final bool ingested;

  /// Stable reason token (`ingested`, `duplicate_activity`, …).
  final String reason;

  const IngestionResult._({required this.ingested, required this.reason});

  /// Successful persist of one or more activities.
  const IngestionResult.ingested() : this._(ingested: true, reason: 'ingested');

  /// No new row was written; [reason] explains why.
  const IngestionResult.ignored(String reason)
    : this._(ingested: false, reason: reason);

  /// JSON shape used by webhook ACK analytics.
  Map<String, dynamic> toMap() {
    return {'ingested': ingested, 'reason': reason};
  }
}

/// GitHub push webhook ingest outcome.
typedef GitHubWebhookIngestionResult = IngestionResult;

/// Slack Events API ingest outcome.
typedef SlackEventIngestionResult = IngestionResult;

/// Phorge Herald webhook ingest outcome.
typedef PhorgeWebhookIngestionResult = IngestionResult;

/// Jira Cloud webhook ingest outcome.
typedef JiraWebhookIngestionResult = IngestionResult;

/// Linear webhook ingest outcome.
typedef LinearWebhookIngestionResult = IngestionResult;

/// GitLab Push Hook ingest outcome.
typedef GitLabWebhookIngestionResult = IngestionResult;

/// Bitbucket `repo:push` ingest outcome.
typedef BitbucketWebhookIngestionResult = IngestionResult;

/// Discord Gateway `MESSAGE_CREATE` ingest outcome.
typedef DiscordMessageIngestionResult = IngestionResult;
