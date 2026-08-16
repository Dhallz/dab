import 'package:dab_api/src/domain/dtos/phorge/phorge_task/phorge_task_bundle_dto.dart';
import 'package:dab_api/src/domain/dtos/phorge/phorge_task/phorge_task_dto.dart';
import 'package:dab_api/src/domain/dtos/phorge/phorge_task/phorge_task_wire_fields_dto.dart';
import 'package:dab_api/src/domain/dtos/phorge/phorge_transaction/phorge_transaction_dto.dart';
import 'package:dab_api/src/domain/entities/user/user.dart';
import 'package:dab_api/src/domain/entities/user/user_role.dart';
import 'package:test/test.dart';

void main() {
  final ada = User(
    id: 'u-ada',
    name: 'Ada',
    email: 'ada@example.com',
    passwordHash: 'hash',
    role: UserRole.standard,
    phorgePhid: 'PHID-USER-ada',
    phorgeUsername: 'ada',
    createdAt: DateTime.utc(2026, 1, 1),
  );
  final bob = User(
    id: 'u-bob',
    name: 'Bob',
    email: 'bob@example.com',
    passwordHash: 'hash',
    role: UserRole.standard,
    phorgePhid: 'PHID-USER-bob',
    phorgeUsername: 'bob',
    createdAt: DateTime.utc(2026, 1, 1),
  );
  final users = [ada, bob];

  PhorgeTaskBundleDto bundle({
    required String ownerPhid,
    required PhorgeTransactionDto tx,
  }) {
    return PhorgeTaskBundleDto(
      task: PhorgeTaskDto(
        id: 42,
        phid: 'PHID-TASK-1',
        fields: PhorgeTaskWireFieldsDto(
          name: 'Fix login bug',
          ownerPHID: ownerPhid,
        ),
      ),
      transactions: [tx],
      sprintTag: 'DS2026-01',
    );
  }

  PhorgeTransactionDto tx({
    required String type,
    String authorPhid = 'PHID-USER-ada',
    String? commentText,
    dynamic newValue,
  }) {
    return PhorgeTransactionDto(
      id: 101,
      phid: 'PHID-XACT-TASK-aa',
      objectPHID: 'PHID-TASK-1',
      authorPHID: authorPhid,
      type: type,
      commentText: commentText,
      newValue: newValue,
      dateCreated: DateTime.utc(2026, 1, 1),
    );
  }

  test('comment on own task without a mention does not land for the author', () {
    final activities = bundle(
      ownerPhid: 'PHID-USER-ada',
      tx: tx(type: 'comment', commentText: 'Working on this'),
    ).toActivities(users, inbound: true);

    expect(activities, isEmpty);
  });

  test('self-@ on own task lands in the author inbox', () {
    final activities = bundle(
      ownerPhid: 'PHID-USER-ada',
      tx: tx(type: 'comment', commentText: 'Note to self @ada'),
    ).toActivities(users, inbound: true);

    expect(activities.single.userId, 'u-ada');
    expect(activities.single.senderUserId, 'u-ada');
  });

  test('{@PHID} self-mention lands in the author inbox', () {
    final activities = bundle(
      ownerPhid: 'PHID-USER-ada',
      tx: tx(type: 'comment', commentText: 'Ping {@PHID-USER-ada}'),
    ).toActivities(users, inbound: true);

    expect(activities.single.userId, 'u-ada');
  });

  test('comment on own task still fans out to an @mention of someone else', () {
    final activities = bundle(
      ownerPhid: 'PHID-USER-ada',
      tx: tx(type: 'comment', commentText: 'Please look @bob'),
    ).toActivities(users, inbound: true);

    expect(activities.single.userId, 'u-bob');
    expect(activities.single.senderUserId, 'u-ada');
  });

  test('reassign to self lands in the author inbox', () {
    final activities = bundle(
      ownerPhid: 'PHID-USER-ada',
      tx: tx(type: 'owner', newValue: 'PHID-USER-ada'),
    ).toActivities(users, inbound: true);

    expect(activities.single.userId, 'u-ada');
    expect(activities.single.content, 'Changed task assignee');
  });

  test('adding yourself as a reviewer lands in the author inbox', () {
    final activities = bundle(
      ownerPhid: 'PHID-USER-ada',
      tx: tx(
        type: 'reviewers',
        newValue: {'PHID-USER-ada': 'added'},
      ),
    ).toActivities(users, inbound: true);

    expect(activities.single.userId, 'u-ada');
    expect(activities.single.content, 'Updated reviewers');
  });

  test('adding yourself as a subscriber lands in the author inbox', () {
    final activities = bundle(
      ownerPhid: 'PHID-USER-ada',
      tx: tx(
        type: 'subscribers',
        newValue: ['PHID-USER-ada'],
      ),
    ).toActivities(users, inbound: true);

    expect(activities.single.userId, 'u-ada');
    expect(activities.single.content, 'Updated subscribers');
  });

  test('Explorer poll mapping still omits assignee and CC transactions', () {
    final activities = bundle(
      ownerPhid: 'PHID-USER-bob',
      tx: tx(type: 'owner', newValue: 'PHID-USER-bob'),
    ).toActivities(users);

    expect(activities, isEmpty);
  });

  test('untagged comment on someone else\'s owned task is empty without Follow', () {
    final activities = bundle(
      ownerPhid: 'PHID-USER-bob',
      tx: tx(type: 'comment', commentText: 'Looks good!'),
    ).toActivities(users, inbound: true);

    expect(activities, isEmpty);
  });

  test('followers receive untagged comments including the author', () {
    final activities = bundle(
      ownerPhid: 'PHID-USER-bob',
      tx: tx(type: 'comment', commentText: 'Working on this'),
    ).toActivities(users, inbound: true, followerUserIds: ['u-ada']);

    expect(activities.single.userId, 'u-ada');
    expect(activities.single.senderUserId, 'u-ada');
  });
}
