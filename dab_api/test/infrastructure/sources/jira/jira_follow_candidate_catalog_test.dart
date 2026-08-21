import 'package:dab_api/src/domain/entities/provider/provider_config.dart';
import 'package:dab_api/src/domain/contracts/repositories/abs_i_provider_config_repository.dart';
import 'package:dab_api/src/infrastructure/protocols/rest/json_rest_protocol.dart';
import 'package:dab_api/src/infrastructure/sources/jira/jira_follow_candidate_catalog.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import '../../../fakes/fake_credential_resolver.dart';

class _MockConfigs extends Mock implements AbsIProviderConfigRepository {}

class _MockJsonRest extends Mock implements JsonRestProtocol {}

void main() {
  late _MockConfigs configs;
  late _MockJsonRest jsonRest;
  late JiraFollowCandidateCatalog catalog;

  const config = ProviderConfig(
    id: 'jira',
    name: 'Jira',
    baseUrl: 'https://acme.atlassian.net',
    settings: {
      'apiToken': 'jira-oauth',
      'tokenType': 'oauth',
      'cloudId': 'cloud-1',
    },
  );

  setUpAll(() {
    registerFallbackValue(Uri.parse('https://api.atlassian.com'));
  });

  setUp(() {
    configs = _MockConfigs();
    jsonRest = _MockJsonRest();
    catalog = JiraFollowCandidateCatalog(
      configs,
      FakeCredentialResolver(),
      jsonRest,
    );
    when(
      () => configs.getConfigs(),
    ).thenAnswer((_) async => const Right([config]));
  });

  test('empty query lists involved issues', () async {
    late Uri captured;
    when(
      () => jsonRest.getJsonMap(any(), headers: any(named: 'headers')),
    ).thenAnswer((invocation) async {
      captured = invocation.positionalArguments[0] as Uri;
      return {
        'issues': [
          {
            'key': 'DAB-1',
            'fields': {'summary': 'Mine'},
          },
        ],
      };
    });

    final result = await catalog.list(userId: 'u-1', query: '');
    final rows = result.getOrElse((_) => throw StateError('left'));
    expect(rows.single.objectKey, 'DAB-1');
    final jql = captured.queryParameters['jql']!;
    expect(jql, contains('currentUser()'));
    expect(jql, isNot(contains('key =')));
  });

  test('typed key searches any issue, not involvement', () async {
    late Uri captured;
    when(
      () => jsonRest.getJsonMap(any(), headers: any(named: 'headers')),
    ).thenAnswer((invocation) async {
      captured = invocation.positionalArguments[0] as Uri;
      return {
        'issues': [
          {
            'key': 'DAB-7',
            'fields': {'summary': 'Someone else'},
          },
        ],
      };
    });

    final result = await catalog.list(userId: 'u-1', query: 'DAB-7');
    final rows = result.getOrElse((_) => throw StateError('left'));
    expect(rows.single.objectKey, 'DAB-7');
    expect(rows.single.title, '[DAB-7] Someone else');
    final jql = captured.queryParameters['jql']!;
    expect(jql, contains('key = "DAB-7"'));
    expect(jql, isNot(contains('currentUser()')));
  });
}
