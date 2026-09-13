import 'package:dab_api/src/domain/core/activity_inbox_lane.dart';
import 'package:dab_api/src/domain/dtos/figma/figma_file_dto.dart';
import 'package:dab_api/src/domain/entities/activity/activity_provider.dart';
import 'package:test/test.dart';

import '../../../test_factories.dart';

void main() {
  final alice = TestData.user(id: 'u-alice', name: 'Alice');
  final bob = TestData.user(id: 'u-bob', name: 'Bob');

  test('comment maps mentions to Directed and Followers to Follow', () {
    final dto = FigmaFileDto(
      fileKey: 'Abc123File',
      fileName: 'Onboarding',
      createdAt: DateTime.utc(2026, 8, 1, 12),
      commentId: 'c-1',
      commentMessage: 'Please take a look',
      authorHandle: 'Alice',
      mentionIds: const ['fig-bob'],
      dabUserId: 'u-alice',
    );

    final rows = dto.toActivities(
      [alice, bob],
      forUserIds: ['u-bob'],
      followerUserIds: ['u-bob'],
      senderUserId: 'u-alice',
    );

    expect(rows, hasLength(2));
    expect(rows.map((a) => a.id).toSet(), hasLength(2));
    expect(rows.every((a) => a.userId == 'u-bob'), isTrue);
    expect(rows.every((a) => a.title == 'Onboarding'), isTrue);
    expect(rows.every((a) => a.content == 'Please take a look'), isTrue);
    expect(
      rows.every((a) => a.provider is FigmaFileProvider),
      isTrue,
    );
    expect(
      rows.map((a) => a.inboxLane).toSet(),
      {ActivityInboxLane.directed, ActivityInboxLane.follow},
    );
  });

  test('last-edited uses a stable id across later touches', () {
    final first = FigmaFileDto(
      fileKey: 'Abc123File',
      fileName: 'Onboarding',
      createdAt: DateTime.utc(2026, 8, 1, 15),
      authorHandle: 'Alice',
      lastEdited: true,
    );
    final second = FigmaFileDto(
      fileKey: 'Abc123File',
      fileName: 'Onboarding',
      createdAt: DateTime.utc(2026, 8, 1, 16),
      authorHandle: 'Alice',
      lastEdited: true,
    );

    final a = first.toActivities(
      [alice, bob],
      forUserIds: const [],
      followerUserIds: ['u-bob'],
    );
    final b = second.toActivities(
      [alice, bob],
      forUserIds: const [],
      followerUserIds: ['u-bob'],
    );

    expect(a, hasLength(1));
    expect(b.single.id, a.single.id);
    expect(a.single.inboxLane, ActivityInboxLane.follow);
    expect(a.single.title, 'Onboarding');
    expect(a.single.content, 'last edited by Alice');
    expect(b.single.createdAt, DateTime.utc(2026, 8, 1, 16));
    expect((a.single.provider as FigmaFileProvider).category, 'generic');
  });

  test('poll comment maps to the linked author without live fan-out', () {
    final dto = FigmaFileDto(
      fileKey: 'Abc123File',
      fileName: 'Onboarding',
      createdAt: DateTime.utc(2026, 8, 1, 12),
      commentId: 'c-poll',
      commentMessage: 'Looks good',
      authorHandle: 'Alice',
      dabUserId: 'u-alice',
    );

    final rows = dto.toActivities([alice, bob]);
    expect(rows, hasLength(1));
    expect(rows.single.userId, 'u-alice');
    expect(rows.single.title, 'Onboarding');
    expect(rows.single.content, 'Looks good');
    expect(rows.single.authorName, 'Alice');
    expect(rows.single.inboxLane, ActivityInboxLane.directed);
  });

  test('skips numeric Figma user ids as authorName', () {
    final dto = FigmaFileDto(
      fileKey: 'Abc123File',
      fileName: 'Onboarding',
      createdAt: DateTime.utc(2026, 8, 1, 12),
      commentId: 'c-poll',
      commentMessage: 'Looks good',
      authorId: '948500924847399940',
      authorHandle: '948500924847399940',
      dabUserId: 'u-alice',
    );

    final rows = dto.toActivities([alice]);
    expect(rows.single.authorName, 'Alice');
  });

  test('omits the person when last-touched handle is missing', () {
    final dto = FigmaFileDto(
      fileKey: 'Abc123File',
      fileName: 'Onboarding',
      createdAt: DateTime.utc(2026, 8, 1, 15),
      lastEdited: true,
    );
    final rows = dto.toActivities(
      [bob],
      forUserIds: const [],
      followerUserIds: ['u-bob'],
    );
    expect(rows.single.title, 'Onboarding');
    expect(rows.single.content, 'Edited recently');
  });
}
