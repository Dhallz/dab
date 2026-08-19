import 'package:dab_api/src/domain/entities/provider/provider_config.dart';
import 'package:dab_api/src/domain/entities/user/activity_follow.dart';
import 'package:dab_api/src/domain/entities/user/user.dart';
import 'package:dab_api/src/domain/entities/user/user_identity.dart';
import 'package:dab_api/src/domain/entities/user/user_identity_status.dart';
import 'package:dab_api/src/domain/entities/user/user_role.dart';
import 'package:dab_api/src/domain/contracts/repositories/abs_i_activity_follow_repository.dart';
import 'package:dab_api/src/domain/contracts/repositories/abs_i_provider_config_repository.dart';
import 'package:dab_api/src/domain/contracts/repositories/abs_i_user_repository.dart';
import 'package:dab_api/src/infrastructure/protocols/protocol_exceptions.dart';
import 'package:dab_api/src/infrastructure/protocols/rest/json_rest_protocol.dart';
import 'package:dab_api/src/infrastructure/sources/figma/figma_file_source.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import '../../../fakes/fake_credential_resolver.dart';
import '../../../fakes/fake_oauth_credential_refresher.dart';

class _MockConfigs extends Mock implements AbsIProviderConfigRepository {}

class _MockUsers extends Mock implements IUserRepository {}

class _MockJsonRest extends Mock implements JsonRestProtocol {}

class _MockFollows extends Mock implements AbsIActivityFollowRepository {}

void main() {
  late _MockConfigs configs;
  late _MockUsers users;
  late _MockJsonRest jsonRest;
  late _MockFollows follows;

  final alice = User(
    id: 'u-alice',
    name: 'Alice',
    email: 'alice@example.com',
    passwordHash: 'x',
    role: UserRole.standard,
    createdAt: DateTime.utc(2026, 1, 1),
  );

  final identity = UserIdentity(
    id: 'ident-figma',
    userId: 'u-alice',
    providerId: 'figma',
    externalId: '948500924847399940',
    externalUsername: 'alice',
    status: UserIdentityStatus.linked,
    createdAt: DateTime.utc(2026, 1, 1),
  );

  const fileKey = 'Abc12345Key';
  final start = DateTime.utc(2026, 8, 17);
  final end = DateTime.utc(2026, 8, 18);

  setUpAll(() {
    registerFallbackValue(Uri.parse('https://api.figma.com'));
  });

  setUp(() {
    configs = _MockConfigs();
    users = _MockUsers();
    jsonRest = _MockJsonRest();
    follows = _MockFollows();
    when(() => configs.getConfigs()).thenAnswer(
      (_) async => Right([
        ProviderConfig(
          id: 'figma',
          name: 'Figma',
          baseUrl: 'https://www.figma.com',
          isActive: true,
          settings: const {},
        ),
      ]),
    );
    when(
      () => users.getIdentitiesForUsersAndProvider(any(), 'figma'),
    ).thenAnswer((_) async => Right([identity]));
    when(() => follows.listForUser(any())).thenAnswer(
      (_) async => Right(<ActivityFollow>[]),
    );
    when(
      () => jsonRest.getJsonMap(any(), headers: any(named: 'headers')),
    ).thenAnswer((invocation) async {
      final uri = invocation.positionalArguments.first as Uri;
      if (uri.path.endsWith('/comments')) {
        return {
          'comments': [
            {
              'id': 'c-1',
              'message': 'Please take a look',
              'created_at': '2026-08-17T15:00:00Z',
              'user': {'id': '948500924847399940', 'handle': 'alice'},
              'mentions': <Object>[],
            },
          ],
        };
      }
      if (uri.path.endsWith('/meta')) {
        return {
          'name': 'Onboarding',
          'last_touched_at': '2026-08-16T12:00:00Z',
        };
      }
      if (uri.path.contains('/teams/')) {
        throw StateError('team listing is not available to Connect OAuth');
      }
      throw StateError('unexpected ${uri.path}');
    });
  });

  FigmaFileSource source({
    Map<String, dynamic> settings = const {},
    FakeOauthCredentialRefresher? oauth,
  }) {
    when(() => configs.getConfigs()).thenAnswer(
      (_) async => Right([
        ProviderConfig(
          id: 'figma',
          name: 'Figma',
          baseUrl: 'https://www.figma.com',
          isActive: true,
          settings: settings,
        ),
      ]),
    );
    return FigmaFileSource(
      configs,
      users,
      jsonRest,
      FakeCredentialResolver({
        'u-alice': {'api.token': 'figma-oauth'},
      }),
      follows: follows,
      oauth: oauth,
    );
  }

  test('polls comments from a pasted Figma file URL', () async {
    final rows = await source(
      settings: {
        'fileKeys': 'https://www.figma.com/design/$fileKey/Onboarding',
      },
    ).fetchRawData([alice], start, end, true);

    expect(rows, hasLength(1));
    expect(rows.single.commentMessage, 'Please take a look');
    expect(rows.single.dabUserId, 'u-alice');
    expect(rows.single.fileKey, fileKey);
    expect(rows.single.fileName, 'Onboarding');
  });

  test('titles the file as [folder_name] name from nested meta', () async {
    when(
      () => jsonRest.getJsonMap(any(), headers: any(named: 'headers')),
    ).thenAnswer((invocation) async {
      final uri = invocation.positionalArguments.first as Uri;
      if (uri.path.endsWith('/comments')) {
        return {
          'comments': [
            {
              'id': 'c-1',
              'message': 'Please take a look',
              'created_at': '2026-08-17T15:00:00Z',
              'user': {'id': '948500924847399940', 'handle': 'alice'},
              'mentions': <Object>[],
            },
          ],
        };
      }
      if (uri.path.endsWith('/meta')) {
        return {
          'file': {
            'name': 'DAB',
            'folder_name': 'dajo. Plugin',
            'last_touched_at': '2026-08-16T12:00:00Z',
          },
        };
      }
      return <String, dynamic>{};
    });

    final rows = await source(
      settings: {'fileKeys': fileKey},
    ).fetchRawData([alice], start, end, true);

    expect(rows, hasLength(1));
    expect(rows.single.fileName, '[dajo. Plugin] DAB');
  });

  test('polls files the searched user Follows when Admin catalog is empty', () async {
    when(() => follows.listForUser('u-alice')).thenAnswer(
      (_) async => Right([
        ActivityFollow(
          id: 'follow-1',
          userId: 'u-alice',
          providerId: 'figma',
          objectKey: fileKey,
          title: 'Onboarding',
          createdAt: DateTime.utc(2026, 8, 1),
        ),
      ]),
    );

    final rows = await source().fetchRawData([alice], start, end, true);

    expect(rows, hasLength(1));
    expect(rows.single.fileKey, fileKey);
    expect(rows.single.commentId, 'c-1');
  });

  test('keeps comments authored by an unlinked Figma user for Explorer', () async {
    when(
      () => jsonRest.getJsonMap(any(), headers: any(named: 'headers')),
    ).thenAnswer((invocation) async {
      final uri = invocation.positionalArguments.first as Uri;
      if (uri.path.endsWith('/comments')) {
        return {
          'comments': [
            {
              'id': 'c-other',
              'message': 'From a teammate',
              'created_at': '2026-08-17T15:00:00Z',
              'user': {'id': 'someone-else', 'handle': 'bob'},
              'mentions': <Object>[],
            },
          ],
        };
      }
      if (uri.path.endsWith('/meta')) {
        return {'name': 'Onboarding'};
      }
      return <String, dynamic>{};
    });

    final rows = await source(
      settings: {'fileKeys': fileKey},
    ).fetchRawData([alice], start, end, true);

    expect(rows.single.commentId, 'c-other');
    expect(rows.single.dabUserId, 'u-alice');
  });

  test('keeps comments that mention a searched Figma identity', () async {
    when(
      () => jsonRest.getJsonMap(any(), headers: any(named: 'headers')),
    ).thenAnswer((invocation) async {
      final uri = invocation.positionalArguments.first as Uri;
      if (uri.path.endsWith('/comments')) {
        return {
          'comments': [
            {
              'id': 'c-mention',
              'message': '@alice please look',
              'created_at': '2026-08-17T15:00:00Z',
              'user': {'id': 'someone-else', 'handle': 'bob'},
              'mentions': [
                {'id': '948500924847399940'},
              ],
            },
          ],
        };
      }
      if (uri.path.endsWith('/meta')) {
        return {'name': 'Onboarding'};
      }
      return <String, dynamic>{};
    });

    final rows = await source(
      settings: {'fileKeys': fileKey},
    ).fetchRawData([alice], start, end, true);

    expect(rows.single.commentId, 'c-mention');
    expect(rows.single.dabUserId, 'u-alice');
  });

  test('refreshes user OAuth before polling comments', () async {
    final oauth = FakeOauthCredentialRefresher({
      'u-alice': {'api.token': 'fresh-oauth', 'tokenType': 'oauth'},
    });
    final rows = await source(
      settings: {'fileKeys': fileKey},
      oauth: oauth,
    ).fetchRawData([alice], start, end, true);

    expect(oauth.calls, greaterThan(0));
    expect(rows.single.commentId, 'c-1');
  });

  test('retries comments once after an expired-token 401', () async {
    var commentCalls = 0;
    when(
      () => jsonRest.getJsonMap(any(), headers: any(named: 'headers')),
    ).thenAnswer((invocation) async {
      final uri = invocation.positionalArguments.first as Uri;
      if (uri.path.endsWith('/comments')) {
        commentCalls += 1;
        if (commentCalls == 1) {
          throw JsonRestProtocolException(
            message: 'HTTP 401',
            statusCode: 401,
            uri: uri,
          );
        }
        return {
          'comments': [
            {
              'id': 'c-after-refresh',
              'message': 'Still here',
              'created_at': '2026-08-17T15:00:00Z',
              'user': {'id': '948500924847399940', 'handle': 'alice'},
              'mentions': <Object>[],
            },
          ],
        };
      }
      if (uri.path.endsWith('/meta')) {
        return {'name': 'Onboarding'};
      }
      return <String, dynamic>{};
    });

    final oauth = FakeOauthCredentialRefresher({
      'u-alice': {'api.token': 'rotated-oauth', 'tokenType': 'oauth'},
    });
    final rows = await source(
      settings: {'fileKeys': fileKey},
      oauth: oauth,
    ).fetchRawData([alice], start, end, true);

    expect(oauth.forced, isTrue);
    expect(commentCalls, 2);
    expect(rows.single.commentId, 'c-after-refresh');
  });
}
