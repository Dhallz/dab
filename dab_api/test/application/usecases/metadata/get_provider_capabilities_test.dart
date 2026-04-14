import 'package:dab_api/src/application/services/provider_capability_catalog.dart';
import 'package:dab_api/src/application/usecases/metadata/get_provider_capabilities.dart';
import 'package:dab_api/src/domain/entities/provider/provider_config.dart';
import 'package:dab_api/src/domain/repositories/abs_i_provider_config_repository.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class _ConfigRepo extends Mock implements AbsIProviderConfigRepository {}

void main() {
  late _ConfigRepo configRepo;
  late GetProviderCapabilities useCase;

  setUp(() {
    configRepo = _ConfigRepo();
    useCase = GetProviderCapabilities(configRepo, ProviderCapabilityCatalog());
  });

  test(
    'returns capabilities for configured providers and marks active ones',
    () async {
      when(() => configRepo.getConfigs()).thenAnswer(
        (_) async => Right([
          ProviderConfig(
            id: 'github',
            name: 'GitHub',
            baseUrl: 'https://github.com',
            isActive: true,
          ),
          ProviderConfig(
            id: 'jira',
            name: 'Jira',
            baseUrl: 'https://atlassian.net',
            isActive: false,
          ),
        ]),
      );

      final capabilities = await useCase.execute();
      final github = capabilities.firstWhere(
        (item) => item['providerId'] == 'github',
      );
      final jira = capabilities.firstWhere(
        (item) => item['providerId'] == 'jira',
      );

      expect(capabilities, hasLength(2));
      expect(github['isActive'], isTrue);
      expect(github['supportsWebhook'], isTrue);
      expect(jira['isActive'], isFalse);
      expect(jira['supportsPolling'], isTrue);
    },
  );
}
