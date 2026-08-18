import 'package:dab_api/src/application/services/live_ingest_persister.dart';
import 'package:dab_api/src/domain/core/failures/failure.dart';
import 'package:dab_api/src/domain/contracts/ports/abs_i_live_feed_store.dart';
import 'package:dab_api/src/domain/contracts/ports/abs_i_presence_broadcaster.dart';
import 'package:dab_api/src/domain/contracts/repositories/abs_i_activity_repository.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import '../../test_factories.dart';

class _MockActivities extends Mock implements AbsIActivityRepository {}

class _MockLiveFeed extends Mock implements AbsILiveFeedStore {}

class _MockPresence extends Mock implements AbsIPresenceBroadcaster {}

void main() {
  late _MockActivities activities;
  late _MockLiveFeed liveFeed;
  late _MockPresence presence;
  late LiveIngestPersister persister;

  setUpAll(() {
    registerFallbackValue(TestData.activity(id: 'fallback'));
  });

  setUp(() {
    activities = _MockActivities();
    liveFeed = _MockLiveFeed();
    presence = _MockPresence();
    persister = LiveIngestPersister(
      activities: activities,
      liveFeed: liveFeed,
      presence: presence,
    );
    when(() => presence.broadcast(any(), any())).thenReturn(null);
    when(() => presence.broadcastToUser(any(), any(), any())).thenReturn(null);
    when(() => liveFeed.incrementVersion()).thenAnswer((_) async => 1);
    when(() => liveFeed.fanOutActivity(any())).thenAnswer((_) async {});
    when(() => liveFeed.recordLiveIngestSuccess(any())).thenAnswer((_) async {});
  });

  test('persists, fans out, and records success', () async {
    final activity = TestData.activity(id: 'a-1', userId: 'u-1');
    when(
      () => activities.createActivity(any()),
    ).thenAnswer((_) async => const Right(null));

    final result = await persister.persist(
      activities: [activity],
      providerId: 'github',
      emptyReason: 'no_eligible_commits',
      logTag: 'GITHUB_WEBHOOK',
    );

    expect(result.getOrElse((_) => throw StateError('left')).ingested, isTrue);
    verify(() => activities.createActivity(activity)).called(1);
    verify(() => liveFeed.fanOutActivity(activity)).called(1);
    verify(() => liveFeed.recordLiveIngestSuccess('github')).called(1);
  });

  test('skips duplicate-key failures and reports emptyReason', () async {
    final activity = TestData.activity(id: 'a-dup');
    when(() => activities.createActivity(any())).thenAnswer(
      (_) async => const Left(DatabaseFailure('duplicate key value')),
    );

    final result = await persister.persist(
      activities: [activity],
      providerId: 'slack',
      emptyReason: 'duplicate_activity',
    );

    final outcome = result.getOrElse((_) => throw StateError('left'));
    expect(outcome.ingested, isFalse);
    expect(outcome.reason, 'duplicate_activity');
    verifyNever(() => liveFeed.recordLiveIngestSuccess(any()));
    verifyNever(() => liveFeed.fanOutActivity(any()));
  });

  test('returns Left on non-duplicate database failure', () async {
    final activity = TestData.activity(id: 'a-fail');
    when(() => activities.createActivity(any())).thenAnswer(
      (_) async => const Left(DatabaseFailure('connection refused')),
    );

    final result = await persister.persist(
      activities: [activity],
      providerId: 'jira',
      emptyReason: 'duplicate_activity',
    );

    expect(result.isLeft(), isTrue);
    expect(result.getLeft().toNullable()!.message, contains('connection'));
    verifyNever(() => liveFeed.recordLiveIngestSuccess(any()));
  });

  test('empty list is ignored without touching the store', () async {
    final result = await persister.persist(
      activities: const [],
      providerId: 'gitlab',
      emptyReason: 'no_attributable_users',
    );

    final outcome = result.getOrElse((_) => throw StateError('left'));
    expect(outcome.ingested, isFalse);
    expect(outcome.reason, 'no_attributable_users');
    verifyNever(() => activities.createActivity(any()));
    verifyNever(() => liveFeed.recordLiveIngestSuccess(any()));
  });
}
