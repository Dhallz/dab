import 'package:dab_api/src/domain/core/provider_credential_keys.dart';
import 'package:dab_api/src/domain/entities/user/user_provider_credential.dart';
import 'package:dab_api/src/domain/entities/user/user_provider_credential_status.dart';
import 'package:dab_api/src/domain/repositories/abs_i_user_provider_credential_repository.dart';
import 'package:dab_api/src/infrastructure/services/credential_resolver.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class _MockCredRepo extends Mock
    implements AbsIUserProviderCredentialRepository {}

void main() {
  late _MockCredRepo repo;
  late CredentialResolver resolver;

  setUp(() {
    repo = _MockCredRepo();
    resolver = CredentialResolver(repo);
  });

  UserProviderCredential cred({
    required String userId,
    Map<String, dynamic> settings = const {'api.token': 'user-pat'},
  }) {
    return UserProviderCredential(
      id: '${userId}_github',
      userId: userId,
      providerId: 'github',
      settings: settings,
      status: UserProviderCredentialStatus.connected,
      createdAt: DateTime.utc(2026, 1, 1),
    );
  }

  test('user secret wins over org token', () {
    final merged = resolver.overlay(
      orgSettings: {'api.token': 'org', 'repos': ['acme/app']},
      userSettings: {'api.token': 'alice'},
    );
    expect(merged['api.token'], 'alice');
    expect(merged['repos'], ['acme/app']);
  });

  test('org token is used when the user has no credential', () {
    final merged = resolver.overlay(
      orgSettings: {'api.token': 'org', 'repos': ['acme/app']},
      userSettings: null,
    );
    expect(merged['api.token'], 'org');
  });

  test('empty user secret does not blank the org token', () {
    final merged = overlayProviderSecrets(
      orgSettings: {'api.token': 'org'},
      userSettings: {'api.token': '  '},
    );
    expect(merged['api.token'], 'org');
  });

  test('getUserSettingsForUsers omits siblings not in the requested set', () async {
    when(() => repo.listForProvider('github')).thenAnswer(
      (_) async => Right([
        cred(userId: 'alice', settings: const {'api.token': 'pat-a'}),
        cred(userId: 'bob', settings: const {'api.token': 'pat-b'}),
      ]),
    );
    final map = await resolver.getUserSettingsForUsers(
      userIds: ['alice'],
      providerId: 'github',
    );
    expect(map.keys, ['alice']);
    expect(map['alice']?['api.token'], 'pat-a');
  });
}
