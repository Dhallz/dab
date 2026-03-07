import 'dart:convert';

import 'package:dab_api/src/application/metadata_service.dart';
import 'package:dab_api/src/domain/entities/provider_config.dart';
import 'package:dab_api/src/presentation/controllers/metadata_controller.dart';
import 'package:dab_api/src/service_locator.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import '../../test_utils.dart';

class MockMetadataService extends Mock implements MetadataService {}

void main() {
  group('MetadataController', () {
    late MetadataController controller;
    late MockMetadataService mockService;

    setUp(() {
      mockService = MockMetadataService();
      sl.reset();
      sl.registerSingleton<MetadataService>(mockService);
      controller = MetadataController();
    });

    test('getConfigs should return list of provider configs', () async {
      final request = TestRequest.create(
        url: Uri.parse('http://localhost/metadata/configs'),
      );

      final mockConfigs = [
        const ProviderConfig(
          id: 'phorge',
          baseUrl: 'https://phorge.example.com',
        ),
      ];

      when(() => mockService.getConfigs()).thenAnswer((_) async => mockConfigs);

      final response = await controller.getConfigs(request);

      expect(response.statusCode, equals(200));
      final body = jsonDecode(await response.readAsString());

      expect(body['data'], isA<List>());
      expect(body['data'].length, 1);
      expect(body['data'][0]['id'], equals('phorge'));
      expect(body['data'][0]['baseUrl'], equals('https://phorge.example.com'));
      expect(body['meta']['dataType'], equals('list:provider_config'));
    });
  });
}
