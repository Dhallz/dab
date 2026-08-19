import 'package:drift/drift.dart';
import 'package:fpdart/fpdart.dart';

import '../../../domain/core/failures/failure.dart';
import '../../../domain/entities/activity/activity.dart';
import '../../../domain/entities/activity/activity_provider.dart';
import '../../../domain/contracts/repositories/abs_i_activity_repository.dart';
import '../postgres/app_database.dart';
import '../postgres/drift_row_mappers.dart';

/// [ARCH: INFRASTRUCTURE_REPOSITORY]
/// ROLE: Persistence implementation for the Unified Activity Feed.
/// CONTRACT: Implements [AbsIActivityRepository] using [AppDatabase] (Drift/Postgres).
/// CONSTRAINTS: Employs the **Table-Per-Type (TBT)** pattern to store polymorphic metadata.
///
/// This repository manages the atomic storage of base activity data and its
/// specialized provider-specific metadata across relational tables.
class ActivityRepository implements AbsIActivityRepository {
  final AppDatabase _db;
  ActivityRepository(this._db);

  @override
  /// [ARCH: INFRASTRUCTURE_ENTRY]
  /// ROLE: Persists a new activity and its specialized metadata.
  /// CONTRACT: Atomic transaction across the base `activities` table and type-specific tables.
  Future<Either<DatabaseFailure, void>> createActivity(
    Activity activity,
  ) async {
    return _db.transaction(() async {
      try {
        // 1. Insert into base activities table
        await _db
            .into(_db.activitiesTable)
            .insert(
              ActivitiesTableCompanion.insert(
                id: activity.id,
                userId: activity.userId,
                senderUserId: Value(activity.senderUserId),
                providerName: activity.provider.name,
                title: activity.title,
                content: activity.content,
                url: Value(activity.url),
                authorName: activity.authorName,
                authorAvatarUrl: Value(activity.authorAvatarUrl),
                commentCount: Value(activity.commentCount),
                createdAt: toPgDateTime(activity.createdAt),
              ),
            );

        // 2. Insert into specific provider table if applicable
        final provider = activity.provider;
        if (provider is PhorgeTaskProvider) {
          await _db
              .into(_db.activityPhorgeTable)
              .insert(
                ActivityPhorgeTableCompanion.insert(
                  activityId: activity.id,
                  taskPhid: Value(provider.taskPhid),
                  tags: Value(provider.tags),
                ),
              );
        } else if (provider is PhorgeRevisionProvider) {
          await _db
              .into(_db.activityPhorgeTable)
              .insert(
                ActivityPhorgeTableCompanion.insert(
                  activityId: activity.id,
                  revisionId: Value(provider.revisionId),
                ),
              );
        } else if (provider is GitHubCommitProvider) {
          await _db
              .into(_db.activityGithubCommitTable)
              .insert(
                ActivityGithubCommitTableCompanion.insert(
                  activityId: activity.id,
                  repo: Value(provider.repo),
                  branch: Value(provider.branch),
                ),
              );
        } else if (provider is SlackMessageProvider) {
          await _db
              .into(_db.activitySlackMessageTable)
              .insert(
                ActivitySlackMessageTableCompanion.insert(
                  activityId: activity.id,
                  workspaceId: Value(provider.workspaceId),
                  channelId: Value(provider.channelId),
                  threadTs: Value(provider.threadTs),
                  messageTs: Value(provider.messageTs),
                ),
              );
        } else if (provider is JiraIssueProvider) {
          await _db
              .into(_db.activityJiraIssueTable)
              .insert(
                ActivityJiraIssueTableCompanion.insert(
                  activityId: activity.id,
                  issueKey: () {
                    final v = provider.issueKey?.trim();
                    return (v == null || v.isEmpty) ? 'unknown' : v;
                  }(),
                  projectKey: () {
                    final v = provider.projectKey?.trim();
                    return (v == null || v.isEmpty) ? 'unknown' : v;
                  }(),
                  statusName: Value(provider.statusName),
                ),
              );
        } else if (provider is LinearIssueProvider) {
          await _db
              .into(_db.activityLinearIssueTable)
              .insert(
                ActivityLinearIssueTableCompanion.insert(
                  activityId: activity.id,
                  identifier: () {
                    final v = provider.identifier?.trim();
                    return (v == null || v.isEmpty) ? 'unknown' : v;
                  }(),
                  teamKey: () {
                    final v = provider.teamKey?.trim();
                    return (v == null || v.isEmpty) ? 'unknown' : v;
                  }(),
                  statusName: Value(provider.statusName),
                ),
              );
        } else if (provider is GitLabCommitProvider) {
          await _db
              .into(_db.activityGitlabCommitTable)
              .insert(
                ActivityGitlabCommitTableCompanion.insert(
                  activityId: activity.id,
                  project: Value(provider.project),
                  branch: Value(provider.branch),
                ),
              );
        } else if (provider is BitbucketCommitProvider) {
          await _db
              .into(_db.activityBitbucketCommitTable)
              .insert(
                ActivityBitbucketCommitTableCompanion.insert(
                  activityId: activity.id,
                  repo: Value(provider.repo),
                  branch: Value(provider.branch),
                ),
              );
        } else if (provider is DiscordMessageProvider) {
          await _db
              .into(_db.activityDiscordMessageTable)
              .insert(
                ActivityDiscordMessageTableCompanion.insert(
                  activityId: activity.id,
                  guildId: Value(provider.guildId),
                  channelId: Value(provider.channelId),
                  messageId: Value(provider.messageId),
                  replyToId: Value(provider.replyToId),
                ),
              );
        } else if (provider is FigmaFileProvider) {
          await _db
              .into(_db.activityFigmaFileTable)
              .insert(_figmaCompanion(activity.id, provider));
        }
        return const Right(null);
      } catch (e) {
        return Left(DatabaseFailure('Error creating activity: $e'));
      }
    });
  }

  @override
  Future<Either<DatabaseFailure, void>> upsertActivity(
    Activity activity,
  ) async {
    return _db.transaction(() async {
      try {
        await _db
            .into(_db.activitiesTable)
            .insertOnConflictUpdate(
              ActivitiesTableCompanion.insert(
                id: activity.id,
                userId: activity.userId,
                senderUserId: Value(activity.senderUserId),
                providerName: activity.provider.name,
                title: activity.title,
                content: activity.content,
                url: Value(activity.url),
                authorName: activity.authorName,
                authorAvatarUrl: Value(activity.authorAvatarUrl),
                commentCount: Value(activity.commentCount),
                createdAt: toPgDateTime(activity.createdAt),
              ),
            );
        final provider = activity.provider;
        if (provider is FigmaFileProvider) {
          await _db
              .into(_db.activityFigmaFileTable)
              .insertOnConflictUpdate(_figmaCompanion(activity.id, provider));
        }
        return const Right(null);
      } catch (e) {
        return Left(DatabaseFailure('Error upserting activity: $e'));
      }
    });
  }

  ActivityFigmaFileTableCompanion _figmaCompanion(
    String activityId,
    FigmaFileProvider provider,
  ) {
    final key = provider.fileKey?.trim();
    return ActivityFigmaFileTableCompanion.insert(
      activityId: activityId,
      fileKey: (key == null || key.isEmpty) ? 'unknown' : key,
      commentId: Value(provider.commentId),
      lastTouchedBy: Value(provider.lastTouchedBy),
    );
  }

  @override
  Future<Either<DatabaseFailure, List<Activity>>> getRecentActivities({
    int limit = 50,
  }) async {
    try {
      final query = _db.select(_db.activitiesTable).join([
        // Join with specific metadata
        leftOuterJoin(
          _db.activityPhorgeTable,
          _db.activityPhorgeTable.activityId.equalsExp(_db.activitiesTable.id),
        ),
        leftOuterJoin(
          _db.activityGithubCommitTable,
          _db.activityGithubCommitTable.activityId.equalsExp(
            _db.activitiesTable.id,
          ),
        ),
        leftOuterJoin(
          _db.activitySlackMessageTable,
          _db.activitySlackMessageTable.activityId.equalsExp(
            _db.activitiesTable.id,
          ),
        ),
        leftOuterJoin(
          _db.activityJiraIssueTable,
          _db.activityJiraIssueTable.activityId.equalsExp(
            _db.activitiesTable.id,
          ),
        ),
        leftOuterJoin(
          _db.activityLinearIssueTable,
          _db.activityLinearIssueTable.activityId.equalsExp(
            _db.activitiesTable.id,
          ),
        ),
        leftOuterJoin(
          _db.activityDiscordMessageTable,
          _db.activityDiscordMessageTable.activityId.equalsExp(
            _db.activitiesTable.id,
          ),
        ),
        leftOuterJoin(
          _db.activityGitlabCommitTable,
          _db.activityGitlabCommitTable.activityId.equalsExp(
            _db.activitiesTable.id,
          ),
        ),
        leftOuterJoin(
          _db.activityBitbucketCommitTable,
          _db.activityBitbucketCommitTable.activityId.equalsExp(
            _db.activitiesTable.id,
          ),
        ),
        leftOuterJoin(
          _db.activityFigmaFileTable,
          _db.activityFigmaFileTable.activityId.equalsExp(
            _db.activitiesTable.id,
          ),
        ),
        // INNER JOIN with provider_configs to enforce "Deep Deactivation"
        // We filter out any activity whose provider is currently disabled.
        innerJoin(
          _db.providerConfigsTable,
          _db.providerConfigsTable.id.equalsExp(
            _db.activitiesTable.providerName.lower(),
          ),
        ),
      ]);

      // Apply the deactivation filter
      query.where(_db.providerConfigsTable.isActive.equals(1));

      query.orderBy([
        OrderingTerm(
          expression: _db.activitiesTable.createdAt,
          mode: OrderingMode.desc,
        ),
      ]);
      query.limit(limit);

      final rows = await query.get();
      return Right(rows.map(_mapRowToActivity).toList());
    } catch (e) {
      return Left(DatabaseFailure('Error fetching recent activities: $e'));
    }
  }

  @override
  Future<Either<DatabaseFailure, List<Activity>>> getActivitiesByUser(
    String userId,
  ) async {
    try {
      final query = _db.select(_db.activitiesTable).join([
        leftOuterJoin(
          _db.activityPhorgeTable,
          _db.activityPhorgeTable.activityId.equalsExp(_db.activitiesTable.id),
        ),
        leftOuterJoin(
          _db.activityGithubCommitTable,
          _db.activityGithubCommitTable.activityId.equalsExp(
            _db.activitiesTable.id,
          ),
        ),
        leftOuterJoin(
          _db.activitySlackMessageTable,
          _db.activitySlackMessageTable.activityId.equalsExp(
            _db.activitiesTable.id,
          ),
        ),
        leftOuterJoin(
          _db.activityJiraIssueTable,
          _db.activityJiraIssueTable.activityId.equalsExp(
            _db.activitiesTable.id,
          ),
        ),
        leftOuterJoin(
          _db.activityLinearIssueTable,
          _db.activityLinearIssueTable.activityId.equalsExp(
            _db.activitiesTable.id,
          ),
        ),
        leftOuterJoin(
          _db.activityDiscordMessageTable,
          _db.activityDiscordMessageTable.activityId.equalsExp(
            _db.activitiesTable.id,
          ),
        ),
        leftOuterJoin(
          _db.activityGitlabCommitTable,
          _db.activityGitlabCommitTable.activityId.equalsExp(
            _db.activitiesTable.id,
          ),
        ),
        leftOuterJoin(
          _db.activityBitbucketCommitTable,
          _db.activityBitbucketCommitTable.activityId.equalsExp(
            _db.activitiesTable.id,
          ),
        ),
        leftOuterJoin(
          _db.activityFigmaFileTable,
          _db.activityFigmaFileTable.activityId.equalsExp(
            _db.activitiesTable.id,
          ),
        ),
        // ENFORCE Deep Deactivation filtering for user-specific feeds too
        innerJoin(
          _db.providerConfigsTable,
          _db.providerConfigsTable.id.equalsExp(
            _db.activitiesTable.providerName.lower(),
          ),
        ),
      ]);

      query.where(
        _db.activitiesTable.userId.equals(userId) &
            _db.providerConfigsTable.isActive.equals(1),
      );

      query.orderBy([
        OrderingTerm(
          expression: _db.activitiesTable.createdAt,
          mode: OrderingMode.desc,
        ),
      ]);

      final rows = await query.get();
      return Right(rows.map(_mapRowToActivity).toList());
    } catch (e) {
      return Left(DatabaseFailure('Error fetching user activities: $e'));
    }
  }

  /// [ARCH: INFRASTRUCTURE_INTERNAL]
  /// ROLE: Hydrates high-level Activity entities from the database.
  /// CONTRACT: Uses `leftOuterJoin` to merge base activities with specialized metadata tables.
  Activity _mapRowToActivity(TypedResult row) {
    final activityData = row.readTable(_db.activitiesTable);
    final phorgeData = row.readTableOrNull(_db.activityPhorgeTable);
    final githubData = row.readTableOrNull(_db.activityGithubCommitTable);
    final slackData = row.readTableOrNull(_db.activitySlackMessageTable);
    final jiraData = row.readTableOrNull(_db.activityJiraIssueTable);
    final linearData = row.readTableOrNull(_db.activityLinearIssueTable);
    final discordData = row.readTableOrNull(_db.activityDiscordMessageTable);
    final gitlabData = row.readTableOrNull(_db.activityGitlabCommitTable);
    final bitbucketData = row.readTableOrNull(_db.activityBitbucketCommitTable);
    final figmaData = row.readTableOrNull(_db.activityFigmaFileTable);

    ActivityProvider provider;
    final pName = activityData.providerName.toLowerCase();

    if (pName == 'phorge' && phorgeData != null) {
      if (phorgeData.taskPhid != null) {
        provider = PhorgeTaskProvider(
          taskPhid: phorgeData.taskPhid,
          tags: phorgeData.tags,
        );
      } else if (phorgeData.revisionId != null) {
        provider = PhorgeRevisionProvider(revisionId: phorgeData.revisionId);
      } else {
        // Use `generic` so API JSON stays decodable by clients (their enum omits unknown).
        provider = const GenericProvider(name: 'Phorge', category: 'generic');
      }
    } else if (pName == 'github' && githubData != null) {
      provider = GitHubCommitProvider(
        repo: githubData.repo,
        branch: githubData.branch,
      );
    } else if (pName == 'github') {
      provider = const GitHubCommitProvider();
    } else if (pName == 'slack' && slackData != null) {
      provider = SlackMessageProvider(
        workspaceId: slackData.workspaceId,
        channelId: slackData.channelId,
        threadTs: slackData.threadTs,
        messageTs: slackData.messageTs,
      );
    } else if (pName == 'slack') {
      provider = const SlackMessageProvider();
    } else if (pName == 'jira' && jiraData != null) {
      provider = JiraIssueProvider(
        issueKey: jiraData.issueKey,
        projectKey: jiraData.projectKey,
        statusName: jiraData.statusName,
      );
    } else if (pName == 'jira') {
      provider = const JiraIssueProvider();
    } else if (pName == 'linear' && linearData != null) {
      provider = LinearIssueProvider(
        identifier: linearData.identifier,
        teamKey: linearData.teamKey,
        statusName: linearData.statusName,
      );
    } else if (pName == 'linear') {
      provider = const LinearIssueProvider();
    } else if (pName == 'discord' && discordData != null) {
      provider = DiscordMessageProvider(
        guildId: discordData.guildId,
        channelId: discordData.channelId,
        messageId: discordData.messageId,
        replyToId: discordData.replyToId,
      );
    } else if (pName == 'discord') {
      provider = const DiscordMessageProvider();
    } else if (pName == 'gitlab' && gitlabData != null) {
      provider = GitLabCommitProvider(
        project: gitlabData.project,
        branch: gitlabData.branch,
      );
    } else if (pName == 'gitlab') {
      provider = const GitLabCommitProvider();
    } else if (pName == 'bitbucket' && bitbucketData != null) {
      provider = BitbucketCommitProvider(
        repo: bitbucketData.repo,
        branch: bitbucketData.branch,
      );
    } else if (pName == 'bitbucket') {
      provider = const BitbucketCommitProvider();
    } else if (pName == 'figma' && figmaData != null) {
      provider = FigmaFileProvider(
        fileKey: figmaData.fileKey,
        commentId: figmaData.commentId,
        lastTouchedBy: figmaData.lastTouchedBy,
      );
    } else if (pName == 'figma') {
      provider = const FigmaFileProvider();
    } else {
      provider = GenericProvider(name: activityData.providerName);
    }

    return Activity(
      id: activityData.id,
      userId: activityData.userId,
      senderUserId: activityData.senderUserId,
      provider: provider,
      title: activityData.title,
      content: activityData.content,
      url: activityData.url,
      authorName: activityData.authorName,
      authorAvatarUrl: activityData.authorAvatarUrl,
      commentCount: activityData.commentCount,
      createdAt: activityData.createdAt.dateTime,
    );
  }
}
