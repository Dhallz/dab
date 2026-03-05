import 'dart:convert';

import 'package:dab_api/src/infrastructure/database/postgres_client.dart';
import 'package:dab_api/src/presentation/controllers/health_controller.dart';
import 'package:dab_api/src/service_locator.dart';
import 'package:mocktail/mocktail.dart';
import 'package:postgres/postgres.dart' as pg;
import 'package:test/test.dart';

import '../../test_utils.dart';

class MockPostgresClient extends Mock implements PostgresClient {}

class MockPool extends Mock implements pg.Pool {}

void main() {
  group('HealthController', () {
    late HealthController controller;
    late MockPostgresClient mockPg;
    late MockPool mockPool;

    setUp(() {
      mockPg = MockPostgresClient();
      mockPool = MockPool();

      sl.reset();
      sl.registerSingleton<PostgresClient>(mockPg);

      when(() => mockPg.pool).thenReturn(mockPool);

      controller = HealthController();
    });

    test('check should return healthy API status', () async {
      final request = TestRequest.create(
        url: Uri.parse('http://localhost/health'),
      );

      final response = await controller.check(request);

      expect(response.statusCode, equals(200));
      final body = jsonDecode(await response.readAsString());
      expect(body['status'], equals('healthy'));
      expect(body.containsKey('database'), isFalse);
    });

    test('checkDb should return healthy when DB is connected', () async {
      final request = TestRequest.create(
        url: Uri.parse('http://localhost/health/db'),
      );

      final emptyResult = pg.Result(
        rows: [],
        affectedRows: 0,
        schema: pg.ResultSchema([]),
      );

      when(() => mockPool.execute(any())).thenAnswer((_) async => emptyResult);

      final response = await controller.checkDb(request);

      expect(response.statusCode, equals(200));
      final body = jsonDecode(await response.readAsString());
      expect(body['status'], equals('healthy'));
      expect(body['database'], equals('connected'));
    });

    test('checkDb should return degraded when DB fails', () async {
      final request = TestRequest.create(
        url: Uri.parse('http://localhost/health/db'),
      );

      when(() => mockPool.execute(any())).thenThrow(Exception('DB Down'));

      final response = await controller.checkDb(request);

      expect(
        response.statusCode,
        equals(200),
      ); // Still returns 200 with degraded status
      final body = jsonDecode(await response.readAsString());
      expect(body['status'], equals('degraded'));
      expect(body['database'], equals('disconnected'));
    });
  });
}
