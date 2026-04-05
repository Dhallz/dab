import 'package:fpdart/fpdart.dart';
import '../../domain/core/failure.dart';
import '../../domain/entities/provider_config.dart';
import '../../domain/repositories/abs_i_provider_config_repository.dart';
import '../config/config.dart';

/// [ARCH: INFRASTRUCTURE_REPOSITORY]
/// ROLE: Source of truth for external platform configurations.
/// CONTRACT: Implements [AbsIProviderConfigRepository].
/// CONSTRAINTS: Mixes environment-derived (Phorge) and static-defined (GitHub/Slack) configs.
/// 
/// This repository provides the necessary URLs and metadata for the client 
/// to interact with external providers.
class ProviderConfigRepository implements AbsIProviderConfigRepository {
  final Config _config;

  ProviderConfigRepository({required Config config}) : _config = config;

  /// Retrieves the current set of supported provider configurations.
  /// 
  /// 1. Dynamically adds Phorge if the environment [phorgeUrl] is present.
  /// 2. Includes static placeholder configs for UI consistency (Slack, GitHub).
  @override
  Future<Either<Failure, List<ProviderConfig>>> getConfigs() async {
    try {
      final List<ProviderConfig> configs = [];

      // Add Phorge configuration if URL is available (Environment-driven)
      if (_config.phorgeUrl.isNotEmpty) {
        configs.add(
          ProviderConfig(
            id: 'Phorge',
            baseUrl: _config.phorgeUrl,
            iconUrl: null,
          ),
        );
      }

      // Add default providers for UI presentation (Static identifiers)
      configs.addAll([
        const ProviderConfig(id: 'GitHub', baseUrl: 'https://github.com'),
        const ProviderConfig(id: 'Slack', baseUrl: 'https://slack.com'),
        const ProviderConfig(id: 'Jira', baseUrl: 'https://jira.atlassian.com'),
      ]);

      return right(configs);
    } catch (e) {
      return left(
        DatabaseFailure('Failed to load provider configurations: $e'),
      );
    }
  }
}
