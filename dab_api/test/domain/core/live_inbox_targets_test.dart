import 'package:dab_api/src/domain/core/live_inbox_targets.dart';
import 'package:dab_api/src/domain/entities/user/user_identity.dart';
import 'package:dab_api/src/domain/entities/user/user_identity_status.dart';
import 'package:test/test.dart';

void main() {
  final alice = UserIdentity(
    id: 'i-1',
    userId: 'u-alice',
    providerId: 'slack',
    externalId: 'U-ALICE',
    status: UserIdentityStatus.linked,
    createdAt: DateTime.utc(2026, 1, 1),
  );
  final bob = UserIdentity(
    id: 'i-2',
    userId: 'u-bob',
    providerId: 'slack',
    externalId: 'U-BOB',
    status: UserIdentityStatus.linked,
    createdAt: DateTime.utc(2026, 1, 1),
  );
  final pending = UserIdentity(
    id: 'i-3',
    userId: 'u-pending',
    providerId: 'slack',
    externalId: 'U-PENDING',
    status: UserIdentityStatus.pending,
    createdAt: DateTime.utc(2026, 1, 1),
  );

  test('linkedExternalToUser drops pending identities', () {
    final map = linkedExternalToUser([alice, bob, pending]);
    expect(map, {'U-ALICE': 'u-alice', 'U-BOB': 'u-bob'});
  });

  test('liveInboxTargets keeps the sender when they are mentioned', () {
    final map = linkedExternalToUser([alice, bob]);
    expect(
      liveInboxTargets(
        externalIds: ['U-ALICE', 'U-BOB', 'U-UNKNOWN'],
        externalToUser: map,
      ),
      {'u-alice', 'u-bob'},
    );
  });

  test('liveInboxTargets keeps a self-only mention', () {
    final map = linkedExternalToUser([alice]);
    expect(
      liveInboxTargets(
        externalIds: ['U-ALICE'],
        externalToUser: map,
      ),
      {'u-alice'},
    );
  });

  test('liveInboxBroadcastTargets excludes the sender', () {
    expect(
      liveInboxBroadcastTargets(
        linkedUserIds: ['u-alice', 'u-bob', ''],
        senderUserId: 'u-alice',
      ),
      {'u-bob'},
    );
  });
}
