import 'package:fpdart/fpdart.dart';

import '../../domain/core/failure.dart';
import '../../domain/entities/provider_config.dart';
import '../../domain/repositories/abs_i_provider_config_repository.dart';
import '../config/config.dart';

class ProviderConfigRepository implements AbsIProviderConfigRepository {
  final Config _config;

  ProviderConfigRepository({required Config config}) : _config = config;

  @override
  Future<Either<Failure, List<ProviderConfig>>> getConfigs() async {
    try {
      final List<ProviderConfig> configs = [];

      // Add Phorge configuration if URL is available
      if (_config.phorgeUrl.isNotEmpty) {
        configs.add(
          ProviderConfig(
            id: 'Phorge',
            baseUrl: _config.phorgeUrl,
            iconUrl: null,
          ),
        );
      }

      // Add default providers for UI presentation
      configs.addAll([
        const ProviderConfig(id: 'GitHub', baseUrl: 'https://github.com'),
        const ProviderConfig(id: 'Slack', baseUrl: 'https://slack.com'),
        const ProviderConfig(id: 'Jira', baseUrl: 'https://jira.atlassian.com'),
      ]);

      // In the future, GitHub or other providers would be added here

      return right(configs);
    } catch (e) {
      return left(
        DatabaseFailure('Failed to load provider configurations: $e'),
      );
    }
  }
}
