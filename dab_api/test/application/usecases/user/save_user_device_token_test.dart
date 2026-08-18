import 'package:dab_api/src/application/usecases/user/delete_user_device_token.dart';
import 'package:dab_api/src/application/usecases/user/save_user_device_token.dart';
import 'package:dab_api/src/domain/core/failures/failure.dart';
import 'package:dab_api/src/domain/entities/user/user_device_token.dart';
import 'package:dab_api/src/domain/contracts/repositories/abs_i_user_device_token_repository.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class _MockTokens extends Mock implements AbsIUserDeviceTokenRepository {}

void main() {
  late _MockTokens tokens;
  late SaveUserDeviceToken save;
  late DeleteUserDeviceToken delete;

  setUpAll(() {
    registerFallbackValue(
      UserDeviceToken(
        id: 'id',
        userId: 'u-1',
        platform: 'android',
        token: 'tok',
        createdAt: DateTime.utc(2026, 1, 1),
      ),
    );
  });

  setUp(() {
    tokens = _MockTokens();
    save = SaveUserDeviceToken(tokens);
    delete = DeleteUserDeviceToken(tokens);
  });

  test('saves android and ios tokens and rejects other platforms', () async {
    when(() => tokens.upsert(any())).thenAnswer((invocation) async {
      return Right(invocation.positionalArguments.first as UserDeviceToken);
    });

    final android = await save.execute(
      userId: 'u-1',
      platform: 'Android',
      token: ' tok-a ',
    );
    final saved = android.getOrElse((_) => throw StateError('left'));
    expect(saved.platform, 'android');
    expect(saved.token, 'tok-a');

    final ios = await save.execute(
      userId: 'u-1',
      platform: 'ios',
      token: 'tok-i',
    );
    expect(ios.isRight(), isTrue);

    final rejected = await save.execute(
      userId: 'u-1',
      platform: 'web',
      token: 'tok',
    );
    expect(rejected.getLeft().toNullable(), isA<ValidationFailure>());
  });

  test('deletes a token and rejects an empty value', () async {
    when(
      () => tokens.delete(
        userId: any(named: 'userId'),
        token: any(named: 'token'),
      ),
    ).thenAnswer((_) async => const Right(null));

    final ok = await delete.execute(userId: 'u-1', token: ' tok ');
    expect(ok.isRight(), isTrue);
    verify(() => tokens.delete(userId: 'u-1', token: 'tok')).called(1);

    final rejected = await delete.execute(userId: 'u-1', token: '  ');
    expect(rejected.getLeft().toNullable(), isA<ValidationFailure>());
  });
}
