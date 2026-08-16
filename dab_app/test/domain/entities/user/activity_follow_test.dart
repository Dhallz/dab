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
  });

  test('git commit cards have no Follow object key', () {
    expect(
      followObjectKeyFor(const GitHubCommitProvider(repo: 'acme/app')),
      isNull,
    );
    expect(
      followObjectRefFor(const GitHubCommitProvider(repo: 'acme/app')),
      isNull,
    );
  });
}
