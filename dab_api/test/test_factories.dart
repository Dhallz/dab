import 'package:dab_api/src/domain/entities/activity/activity.dart';
import 'package:dab_api/src/domain/entities/activity/activity_provider.dart';
import 'package:dab_api/src/domain/entities/user/user.dart';
import 'package:dab_api/src/domain/entities/user/user_role.dart';
import 'package:uuid/uuid.dart';

/// A central location for generating realistic test data (Object Mother pattern).
class TestData {
  static const _uuid = Uuid();

  /// Generates a realistic User entity.
  static User user({
    String? id,
    String name = 'John Doe',
    String email = 'john.doe@example.com',
    UserRole role = UserRole.standard,
    String? phorgeUsername = 'jdoe',
  }) {
    return User(
      id: id ?? _uuid.v4(),
      name: name,
      email: email,
      passwordHash: 'hashed_password_123',
      role: role,
      phorgePhid: phorgeUsername != null
          ? 'PHID-USER-${_uuid.v4().substring(0, 8)}'
          : null,
      phorgeUsername: phorgeUsername,
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
    );
  }

  /// Generates a realistic Phorge Task Activity.
  static Activity phorgeTask({
    String? id,
    String? userId,
    String taskSuffix = '123',
    String taskName = 'Fix production bug',
  }) {
    return Activity(
      id: id ?? _uuid.v4(),
      userId: userId ?? _uuid.v4(),
      provider: PhorgeTaskProvider(
        taskPhid: 'PHID-TASK-${_uuid.v4().substring(0, 8)}',
        tags: 'critical,bug',
      ),
      title: 'T$taskSuffix: $taskName',
      content: 'Moved task T$taskSuffix from "Open" to "Resolved".',
      url: 'https://phorge.example.com/T$taskSuffix',
      authorName: 'Test Phorge User',
      authorAvatarUrl: null,
      commentCount: 2,
      createdAt: DateTime.now(),
    );
  }

  /// Generates a realistic GitHub Commit Activity.
  static Activity githubCommit({
    String? id,
    String? userId,
    String repo = 'dab-api',
    String branch = 'main',
  }) {
    final commitHash = _uuid.v4().substring(0, 7);
    return Activity(
      id: id ?? _uuid.v4(),
      userId: userId ?? _uuid.v4(),
      provider: GitHubCommitProvider(repo: 'dhallz/$repo', branch: branch),
      title: '[$repo:$branch] New commit $commitHash',
      content: 'feat: add test data factories for better unit testing',
      url: 'https://github.com/dhallz/$repo/commit/$commitHash',
      authorName: 'dhallz',
      authorAvatarUrl: 'https://avatars.githubusercontent.com/u/123456',
      commentCount: 0,
      createdAt: DateTime.now(),
    );
  }

  /// Generates a generic Slack/Message Activity.
  static Activity slackMessage({
    String? id,
    String? userId,
    String channel = '#dev-announcements',
  }) {
    return Activity(
      id: id ?? _uuid.v4(),
      userId: userId ?? _uuid.v4(),
      provider: GenericProvider(name: 'Slack', category: 'message'),
      title: 'New message in $channel',
      content: "Hey team, I've finished the unit tests for the Vegas pattern.",
      authorName: 'Slack User',
      authorAvatarUrl: null,
      commentCount: 1,
      createdAt: DateTime.now(),
    );
  }

  /// Default generic activity for quick tests.
  static Activity activity({
    String? id,
    String? userId,
    String title = 'Test Activity',
  }) {
    return Activity(
      id: id ?? _uuid.v4(),
      userId: userId ?? _uuid.v4(),
      provider: const GenericProvider(name: 'Mock'),
      title: title,
      content: 'Test content for $title',
      authorName: 'Mock Author',
      authorAvatarUrl: null,
      commentCount: 0,
      createdAt: DateTime.now(),
    );
  }
}
