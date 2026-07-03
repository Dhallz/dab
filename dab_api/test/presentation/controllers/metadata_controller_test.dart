import 'dart:convert';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
import 'package:relic/relic.dart';
import 'package:test/test.dart';
import 'package:dab_api/src/presentation/controllers/metadata_controller.dart';
import 'package:dab_api/src/application/containers/metadata_usecases.dart';
import '../../test_utils.dart';

class MockMetadataUseCases extends Mock implements MetadataUseCases {}

void main() {
  group('MetadataController.testConfig Validation', () {
    late MetadataController controller;

    setUpAll(() {
      final sl = GetIt.instance;
      if (!sl.isRegistered<MetadataUseCases>()) {
        sl.registerSingleton<MetadataUseCases>(MockMetadataUseCases());
      }
    });

    setUp(() {
      controller = MetadataController();
    });

    test('Linear: should fail if apiKey is missing', () async {
      final body = jsonEncode({
        'id': 'linear',
        'name': 'Linear',
        'baseUrl': 'https://linear.app',
        'isActive': true,
        'settings': {}
      });
      final req = TestRequest.create(
        method: Method.post,
        url: Uri.parse('http://localhost/admin/configs/test'),
        body: Body.fromString(body),
      );

      final res = await controller.testConfig(req);
      expect(res.statusCode, 400);

      final resBody = jsonDecode(await res.readAsString());
      expect(resBody['error'], 'Connection failed');
      expect(resBody['details'], contains('Linear API key is missing'));
    });

    test('Jira: should fail if credentials/instanceUrl are missing', () async {
      final body = jsonEncode({
        'id': 'jira',
        'name': 'Jira',
        'baseUrl': '',
        'isActive': true,
        'settings': {
          'apiToken': '',
          'email': '',
        }
      });
      final req = TestRequest.create(
        method: Method.post,
        url: Uri.parse('http://localhost/admin/configs/test'),
        body: Body.fromString(body),
      );

      final res = await controller.testConfig(req);
      expect(res.statusCode, 400);

      final resBody = jsonDecode(await res.readAsString());
      expect(resBody['error'], 'Connection failed');
      expect(resBody['details'], contains('Jira API token, email, and instance URL are required'));
    });

    test('Discord: should fail if botToken or guildId is missing', () async {
      final body = jsonEncode({
        'id': 'discord',
        'name': 'Discord',
        'baseUrl': 'https://discord.com',
        'isActive': true,
        'settings': {}
      });
      final req = TestRequest.create(
        method: Method.post,
        url: Uri.parse('http://localhost/admin/configs/test'),
        body: Body.fromString(body),
      );

      final res = await controller.testConfig(req);
      expect(res.statusCode, 400);

      final resBody = jsonDecode(await res.readAsString());
      expect(resBody['error'], 'Connection failed');
      expect(resBody['details'], contains('Discord bot token and guild ID are required'));
    });

    test('GitLab: should fail if apiToken or instanceUrl is missing', () async {
      final body = jsonEncode({
        'id': 'gitlab',
        'name': 'GitLab',
        'baseUrl': '',
        'isActive': true,
        'settings': {}
      });
      final req = TestRequest.create(
        method: Method.post,
        url: Uri.parse('http://localhost/admin/configs/test'),
        body: Body.fromString(body),
      );

      final res = await controller.testConfig(req);
      expect(res.statusCode, 400);

      final resBody = jsonDecode(await res.readAsString());
      expect(resBody['error'], 'Connection failed');
      expect(resBody['details'], contains('GitLab API token and instance URL are required'));
    });
  });
}
