import 'package:dab_api/src/domain/core/activity_inbox_lane.dart';
import 'package:test/test.dart';

void main() {
  test('inboxLaneTargets emits directed then follow, including overlap', () {
    final targets = inboxLaneTargets(
      directedUserIds: ['u-ada', ' u-bob '],
      followerUserIds: ['u-bob', 'u-cara'],
    );

    expect(targets, [
      ('u-ada', ActivityInboxLane.directed),
      ('u-bob', ActivityInboxLane.directed),
      ('u-bob', ActivityInboxLane.follow),
      ('u-cara', ActivityInboxLane.follow),
    ]);
  });

  test('withInboxLaneId keeps directed seeds stable', () {
    expect(
      ('phorge-tx-1-u-ada').withInboxLaneId(ActivityInboxLane.directed),
      'phorge-tx-1-u-ada',
    );
    expect(
      ('phorge-tx-1-u-ada').withInboxLaneId(ActivityInboxLane.follow),
      'phorge-tx-1-u-ada|follow',
    );
  });

  test('resolveInboxLaneTargets falls back to a directed poll row', () {
    expect(resolveInboxLaneTargets(fallbackUserId: 'u-ada'), [
      ('u-ada', ActivityInboxLane.directed),
    ]);
    expect(resolveInboxLaneTargets(fallbackUserId: '  '), isEmpty);
  });
}
