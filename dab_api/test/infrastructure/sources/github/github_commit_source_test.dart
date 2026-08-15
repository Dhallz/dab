import 'package:dab_api/src/domain/dtos/github/github_commit_dto.dart';
import 'package:dab_api/src/domain/entities/provider/provider_config.dart';
import 'package:dab_api/src/domain/entities/user/user.dart';
import 'package:dab_api/src/domain/entities/user/user_identity.dart';
import 'package:dab_api/src/domain/entities/user/user_identity_status.dart';
import 'package:dab_api/src/domain/entities/user/user_role.dart';
import 'package:dab_api/src/domain/repositories/abs_i_provider_config_repository.dart';
import 'package:dab_api/src/domain/repositories/abs_i_user_repository.dart';
import 'package:dab_api/src/infrastructure/protocols/rest/json_rest_protocol.dart';
import 'package:dab_api/src/infrastructure/sources/github/github_commit_source.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import '../../../fakes/fake_credential_resolver.dart';

class _MockConfigs extends Mock implements AbsIProviderConfigRepository {}

class _MockUsers extends Mock implements IUserRepository {}

class _MockJsonRest extends Mock implements JsonRestProtocol {}

void main() {
  late _MockConfigs configs;
  late _MockUsers users;
  late _MockJsonRest jsonRest;

  final alice = User(
    id: 'alice',
    name: 'Alice',
    email: 'alice@example.com',
    passwordHash: 'x',
    role: UserRole.standard,
    createdAt: DateTime.utc(2026, 1, 1),
  );
  final bob = User(
    id: 'bob',
    name: 'Bob',
    email: 'bob@example.com',
    passwordHash: 'x',
    role: UserRole.standard,
    createdAt: DateTime.utc(2026, 1, 1),
  );
  final carol = User(
    id: 'carol',
    name: 'Carol',
    email: 'carol@example.com',
    passwordHash: 'x',
    role: UserRole.standard,
    createdAt: DateTime.utc(2026, 1, 1),
  );

  UserIdentity identity(User user, String login) => UserIdentity(
    id: '${user.id}_github',
    userId: user.id,
    providerId: 'github',
    externalId: login,
    status: UserIdentityStatus.linked,
    createdAt: DateTime.utc(2026, 1, 1),
  );

  setUpAll(() {
    registerFallbackValue(Uri.parse('https://api.github.com'));
  });

  setUp(() {
    configs = _MockConfigs();
    users = _MockUsers();
    jsonRest = _MockJsonRest();
    when(() => configs.getConfigs()).thenAnswer(
      (_) async => Right([
        ProviderConfig(
          id: 'github',
          name: 'GitHub',
          baseUrl: 'https://github.com',
          isActive: true,
          settings: const {'repos': ['acme/app']},
        ),
      ]),
    );
    when(
      () => users.getIdentitiesForUsersAndProvider(any(), 'github'),
    ).thenAnswer(
      (_) async => Right([
        identity(alice, 'alice'),
        identity(bob, 'bob'),
        identity(carol, 'carol'),
      ]),
    );
  });

  test('merges commits from two PATs and skips a user without a token', () async {
    final source = GitHubCommitSource(
      configs,
      users,
      jsonRest,
      FakeCredentialResolver({
        'alice': {'api.token': 'pat-alice'},
        'bob': {'api.token': 'pat-bob'},
      }),
    );

    when(
      () => jsonRest.getJsonList(any(), headers: any(named: 'headers')),
    ).thenAnswer((invocation) async {
      final uri = invocation.positionalArguments.first as Uri;
      final headers =
          invocation.namedArguments[#headers] as Map<String, String>;
      final token = headers['Authorization']?.replaceFirst('Bearer ', '');
      if (uri.queryParameters['author'] == 'alice' && token == 'pat-alice') {
        return [
          {
            'sha': 'aaa',
            'html_url': 'https://github.com/acme/app/commit/aaa',
            'author': {'login': 'alice', 'avatar_url': 'https://x/a'},
            'commit': {
              'message': 'alice work',
              'author': {
                'name': 'Alice',
                'email': 'alice@example.com',
                'date': '2026-06-01T10:00:00Z',
              },
            },
          },
        ];
      }
      if (uri.queryParameters['author'] == 'bob' && token == 'pat-bob') {
        return [
          {
            'sha': 'bbb',
            'html_url': 'https://github.com/acme/app/commit/bbb',
            'author': {'login': 'bob', 'avatar_url': 'https://x/b'},
            'commit': {
              'message': 'bob work',
              'author': {
                'name': 'Bob',
                'email': 'bob@example.com',
                'date': '2026-06-01T11:00:00Z',
              },
            },
          },
        ];
      }
      return const <Map<String, dynamic>>[];
    });

    final rows = await source.fetchRawData(
      [alice, bob, carol],
      DateTime.utc(2026, 6, 1),
      DateTime.utc(2026, 6, 2),
      true,
    );
    expect(rows.map((r) => r.sha), containsAll(['aaa', 'bbb']));
    expect(rows.where((r) => r.userId == 'carol'), isEmpty);
    expect(rows, isA<List<GitHubCommitDto>>());
  });
}
