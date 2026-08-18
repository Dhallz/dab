import 'package:dab_app/domain/core/activity_follow_key.dart';
import 'package:dab_app/domain/entities/activity/activity_provider.dart';
import 'package:dab_app/domain/entities/user/activity_follow.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('parses providerId and objectKey from the API map', () {
    final follow = ActivityFollow.fromMap({
      'providerId': 'jira',
      'objectKey': 'DAB-7',
    });
    expect(follow.providerId, 'jira');
    expect(follow.objectKey, 'DAB-7');
    expect(follow.objectRef, followObjectRef('jira', 'DAB-7'));
    expect(follow.displayTitle, 'DAB-7');
  });

  test('uses the stored title for watching-row copy', () {
    final follow = ActivityFollow.fromMap({
      'providerId': 'phorge',
      'objectKey': 'PHID-TASK-1',
      'title': '[T123] Fix login',
      'url': '/T123',
    });
    expect(follow.displayTitle, '[T123] Fix login');
    expect(follow.url, '/T123');
  });

  test('git Follow keys require a repo and a branch', () {
    expect(
      followObjectKeyFor(const GitHubCommitProvider(repo: 'acme/app')),
      isNull,
    );
    expect(
      followObjectRefFor(const GitHubCommitProvider(repo: 'acme/app')),
      isNull,
    );
    expect(
      followObjectKeyFor(
        const GitHubCommitProvider(repo: 'Acme/app', branch: 'feature/foo'),
      ),
      'acme/app|feature/foo',
    );
  });
}
