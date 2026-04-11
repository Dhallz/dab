import 'package:dab_api/src/application/usecases/auth/count_unresolved_identities.dart';
import 'package:dab_api/src/application/usecases/auth/get_all_identities.dart';
import 'package:dab_api/src/domain/entities/user/user_identity.dart';
import 'package:dab_api/src/domain/entities/user/user_identity_status.dart';
import 'package:test/test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

class _MockGetAll extends Mock implements GetAllIdentities {}

void main() {
  test('counts pending and failed only', () async {
    final mock = _MockGetAll();
    when(() => mock.execute()).thenAnswer(
      (_) async => Right([
        UserIdentity(
          id: '1',
          userId: 'u',
          providerId: 'p',
          externalId: 'x',
          status: UserIdentityStatus.pending,
          createdAt: DateTime.now(),
        ),
        UserIdentity(
          id: '2',
          userId: 'u',
          providerId: 'q',
          externalId: 'y',
          status: UserIdentityStatus.linked,
          createdAt: DateTime.now(),
        ),
        UserIdentity(
          id: '3',
          userId: 'u',
          providerId: 'r',
          externalId: 'z',
          status: UserIdentityStatus.failed,
          createdAt: DateTime.now(),
        ),
      ]),
    );

    final count = await CountUnresolvedIdentities(mock).execute();
    expect(count.getOrElse((_) => -1), 2);
  });
}
