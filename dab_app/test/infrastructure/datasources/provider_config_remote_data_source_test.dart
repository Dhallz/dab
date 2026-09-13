import 'package:dab_app/infrastructure/core/remote/rest_api_client.dart';
import 'package:dab_app/infrastructure/datasources/provider_config_remote_data_source.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockRestApiClient extends Mock implements RestApiClient {}

void main() {
  late ProviderConfigRemoteDataSource dataSource;
  late MockRestApiClient mockRestClient;

  setUp(() {
    mockRestClient = MockRestApiClient();
    dataSource = ProviderConfigRemoteDataSource(mockRestClient);
  });

  group('getProviderConfigs', () {
    test('should perform a GET request on /metadata/configs', () async {
      // arrange
      final tResponse = Response(
        data: {'data': []},
        requestOptions: RequestOptions(path: '/metadata/configs'),
        statusCode: 200,
      );
      when(
        () => mockRestClient.get('/metadata/configs'),
      ).thenAnswer((_) async => tResponse);

      // act
      final result = await dataSource.getProviderConfigs();

      // assert
      expect(result, equals(tResponse));
      verify(() => mockRestClient.get('/metadata/configs')).called(1);
    });
  });
}
