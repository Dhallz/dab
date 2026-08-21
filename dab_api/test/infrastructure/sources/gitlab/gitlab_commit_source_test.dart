import 'package:dab_api/src/domain/core/gitlab_scope.dart';
import 'package:dab_api/src/domain/dtos/gitlab/gitlab_commit_dto.dart';
import 'package:dab_api/src/domain/dtos/gitlab/gitlab_commit_mapping.dart';
import 'package:dab_api/src/domain/entities/provider/provider_config.dart';
import 'package:dab_api/src/domain/entities/user/user.dart';
import 'package:dab_api/src/domain/entities/user/user_role.dart';
import 'package:dab_api/src/domain/contracts/repositories/abs_i_provider_config_repository.dart';
import 'package:dab_api/src/domain/contracts/repositories/abs_i_user_repository.dart';
import 'package:dab_api/src/infrastructure/protocols/rest/json_rest_protocol.dart';
import 'package:dab_api/src/infrastructure/sources/gitlab/gitlab_commit_source.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import '../../../fakes/fake_credential_resolver.dart';

class _MockProviderConfigRepository extends Mock
    implements AbsIProviderConfigRepository {}

class _MockUserRepository extends Mock implements IUserRepository {}

class _MockJsonRestProtocol extends Mock implements JsonRestProtocol {}

void main() {
  late _MockProviderConfigRepository configRepository;
  late _MockUserRepository userRepository;
  late _MockJsonRestProtocol jsonRest;
  late GitLabCommitSource source;

  final user = User(
    id: 'u-gitlab',
    name: 'Ada',
    email: 'ada@example.com',
    passwordHash: 'hash',
    role: UserRole.standard,
    createdAt: DateTime.utc(2026, 1, 1),
  );

  final config = ProviderConfig(
    id: 'gitlab',
    name: 'GitLab',
    baseUrl: 'https://gitlab.example.com',
    isActive: true,
    settings: const {
      'apiToken': 'glpat-token',
      'projects': ['group/project'],
    },
  );

  final commitJson = {
    'id': 'abc123',
    'title': 'Fix login bug',
    'message': 'Fix login bug\n\nDetails here.',
    'author_name': 'Ada L.',
    'author_email': 'ada@example.com',
    'committed_date': '2026-06-30T10:00:00.000+00:00',
    'web_url': 'https://gitlab.example.com/group/project/-/commit/abc123',
  };

  setUpAll(() {
    registerFallbackValue(Uri.parse('https://gitlab.example.com/api/v4'));
  });

  setUp(() {
    configRepository = _MockProviderConfigRepository();
    userRepository = _MockUserRepository();
    jsonRest = _MockJsonRestProtocol();
    source = GitLabCommitSource(
      configRepository,
      userRepository,
      jsonRest,
      FakeCredentialResolver(),
    );

    when(
      () => configRepository.getConfigs(),
    ).thenAnswer((_) async => Right([config]));
    when(
      () => userRepository.getIdentitiesForUsersAndProvider(any(), any()),
    ).thenAnswer((_) async => const Right([]));
  });

  group('fetchRawData', () {
    test('maps project commits attributed by author email', () async {
      Uri? requestedUri;
      when(
        () => jsonRest.getJsonList(any(), headers: any(named: 'headers')),
      ).thenAnswer((invocation) async {
        requestedUri = invocation.positionalArguments.first as Uri;
        return [commitJson];
      });

      final dtos = await source.fetchRawData(
        [user],
        DateTime.utc(2026, 6, 1),
        DateTime.utc(2026, 7, 1),
        false,
      );

      expect(dtos, hasLength(1));
      expect(dtos.single.sha, 'abc123');
      expect(dtos.single.userId, 'u-gitlab');
      expect(
        requestedUri!.path,
        '/api/v4/projects/group%2Fproject/repository/commits',
      );

      final activities = dtos.single.toActivities([user]);
      expect(activities, hasLength(1));
      expect(activities.single.title, 'Fix login bug');
      expect(activities.single.content, 'Details here.');
    });

    test('returns empty without config, token, or projects', () async {
      when(() => configRepository.getConfigs()).thenAnswer(
        (_) async => Right([
          config.copyWith(settings: const {'apiToken': 'glpat-token'}),
        ]),
      );

      expect(
        await source.fetchRawData(
          [user],
          DateTime.utc(2026, 6, 1),
          DateTime.utc(2026, 7, 1),
          false,
        ),
        isEmpty,
      );
      verifyNever(
        () => jsonRest.getJsonList(any(), headers: any(named: 'headers')),
      );
    });
  });

  group('lookupExternalId', () {
    test('resolves usernames via user search', () async {
      when(
        () => jsonRest.getJsonList(any(), headers: any(named: 'headers')),
      ).thenAnswer(
        (_) async => [
          {'id': 7, 'username': 'ada'},
        ],
      );

      final result = await source.lookupExternalId('Ada', 'ada@example.com');
      expect(result.getOrElse((_) => null), 'ada');
    });
  });

  group('gitLabApiBase', () {
    test('prefers explicit apiBaseUrl, then instance URL, then gitlab.com',
        () {
      expect(
        (const {'apiBaseUrl': 'https://x.example.com/api/v4/'}).gitLabApiBase(),
        'https://x.example.com/api/v4',
      );
      expect(
        (const {}).gitLabApiBase('https://gitlab.example.com'),
        'https://gitlab.example.com/api/v4',
      );
      expect((const {}).gitLabApiBase(), 'https://gitlab.com/api/v4');
    });
  });

  group('mapGitLabCommitJson', () {
    test('returns null for rows without id or date', () {
      expect(
        mapGitLabCommitJson(const {'message': 'x'}, project: 'g/p'),
        isNull,
      );
      expect(
        mapGitLabCommitJson(const {'id': 'abc'}, project: 'g/p'),
        isNull,
      );
    });
  });
}
