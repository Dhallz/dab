import 'package:dab_api/src/infrastructure/protocols/graphql/http_graphql_protocol.dart';
import 'package:dab_api/src/infrastructure/protocols/protocol_exceptions.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class _MockClient extends Mock implements http.Client {}

void main() {
  late _MockClient mockClient;
  late HttpGraphqlProtocol protocol;

  setUp(() {
    mockClient = _MockClient();
    protocol = HttpGraphqlProtocol(client: mockClient);
    registerFallbackValue(Uri.parse('https://api.linear.app/graphql'));
  });

  group('execute', () {
    test('returns data map on 200 with data envelope', () async {
      final uri = Uri.parse('https://api.linear.app/graphql');
      when(
        () => mockClient.post(any(), headers: any(named: 'headers'), body: any(named: 'body')),
      ).thenAnswer(
        (_) async => http.Response(
          '{"data":{"issues":{"nodes":[]}}}',
          200,
        ),
      );

      final data = await protocol.execute(
        uri,
        bearerToken: 'tok',
        document: 'query { issues { nodes { id } } }',
      );

      expect(data, {'issues': {'nodes': []}});
      verify(
        () => mockClient.post(
          uri,
          headers: any(named: 'headers'),
          body: any(named: 'body'),
        ),
      ).called(1);
    });

    test('throws GraphqlProtocolException when errors array is non-empty', () async {
      final uri = Uri.parse('https://api.linear.app/graphql');
      when(
        () => mockClient.post(any(), headers: any(named: 'headers'), body: any(named: 'body')),
      ).thenAnswer(
        (_) async => http.Response(
          '{"errors":[{"message":"bad"}],"data":null}',
          200,
        ),
      );

      expect(
        () => protocol.execute(uri, bearerToken: 't', document: 'query { x }'),
        throwsA(
          predicate((Object e) =>
              e is GraphqlProtocolException &&
              e.errors.length == 1 &&
              e.errors.first is Map &&
              (e.errors.first as Map)['message'] == 'bad'),
        ),
      );
    });

    test('throws GraphqlProtocolException on non-2xx HTTP', () async {
      final uri = Uri.parse('https://api.linear.app/graphql');
      when(
        () => mockClient.post(any(), headers: any(named: 'headers'), body: any(named: 'body')),
      ).thenAnswer((_) async => http.Response('Unauthorized', 401));

      expect(
        () => protocol.execute(uri, bearerToken: 't', document: 'q'),
        throwsA(
          predicate(
            (Object e) =>
                e is GraphqlProtocolException && e.statusCode == 401,
          ),
        ),
      );
    });
  });
}
