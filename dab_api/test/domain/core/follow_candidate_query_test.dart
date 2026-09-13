import 'package:dab_api/src/domain/core/follow_candidate_query.dart';
import 'package:dab_api/src/domain/entities/user/follow_candidate.dart';
import 'package:test/test.dart';

void main() {
  const task = FollowCandidate(
    providerId: 'phorge',
    objectKey: 'PHID-TASK-12',
    title: '[T12] Fix login',
  );

  test('empty query matches every row', () {
    expect(followCandidateTitleContains(task, ''), isTrue);
    expect(followCandidateTitleContains(task, '  '), isTrue);
  });

  test('matches task number or keyword in the display title', () {
    expect(followCandidateTitleContains(task, '12'), isTrue);
    expect(followCandidateTitleContains(task, 'T12'), isTrue);
    expect(followCandidateTitleContains(task, 'LOGIN'), isTrue);
    expect(followCandidateTitleContains(task, 'schema'), isFalse);
  });
}
