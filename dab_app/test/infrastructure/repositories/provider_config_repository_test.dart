import 'package:dab_app/domain/entities/provider/provider_config.dart';
import 'package:dab_app/infrastructure/datasources/provider_config_remote_data_source.dart';
import 'package:dab_app/infrastructure/repositories/provider_config_repository.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockProviderConfigRemoteDataSource extends Mock
    implements ProviderConfigRemoteDataSource {}

class MockResponse extends Mock implements Response {}

void main() {
  late ProviderConfigRepository repository;
  late MockProviderConfigRemoteDataSource mockDataSource;

  setUp(() {
    mockDataSource = MockProviderConfigRemoteDataSource();
    repository = ProviderConfigRepository(mockDataSource);
  });

  group('getProviderConfigs', () {
    final tConfigs = [
      const ProviderConfig(
        id: 'github',
        name: 'GitHub',
        baseUrl: 'https://github.com',
        isActive: true,
        iconUrl: 'https://github.com/favicon.ico',
      ),
      const ProviderConfig(
        id: 'phorge',
        name: 'Phorge',
        baseUrl: 'https://phorge.com',
        isActive: true,
        iconUrl: 'https://phorge.com/favicon.ico',
      ),
    ];

    final tResponseData = {
      'data': [
        {
          'id': 'github',
          'name': 'GitHub',
          'baseUrl': 'https://github.com',
          'iconUrl': 'https://github.com/favicon.ico',
          'isActive': true,
        },
        {
          'id': 'phorge',
          'name': 'Phorge',
          'baseUrl': 'https://phorge.com',
          'iconUrl': 'https://phorge.com/favicon.ico',
          'isActive': true,
        },
      ],
    };

    test(
      'should return list of ProviderConfigs when data source call is successful',
      () async {
        // arrange
        final response = Response(
          data: tResponseData,
          requestOptions: RequestOptions(path: ''),
          statusCode: 200,
        );
        when(
          () => mockDataSource.getProviderConfigs(),
        ).thenAnswer((_) async => response);

        // act
        final result = await repository.getProviderConfigs();

        // assert
        result.fold((failure) => fail('Should not return failure: $failure'), (
          configs,
        ) {
          expect(configs, equals(tConfigs));
          expect(configs.length, 2);
          expect(configs[0].id, 'github');
        });
        verify(() => mockDataSource.getProviderConfigs()).called(1);
      },
    );

    test('should return AppFailure when data source call fails', () async {
      // arrange
      when(
        () => mockDataSource.getProviderConfigs(),
      ).thenThrow(DioException(requestOptions: RequestOptions(path: '')));

      // act
      final result = await repository.getProviderConfigs();

      // assert
      expect(result.isLeft(), true);
    });
  });
}
