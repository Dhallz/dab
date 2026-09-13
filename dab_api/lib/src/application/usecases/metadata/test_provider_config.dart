import 'package:fpdart/fpdart.dart';

import '../../../domain/core/failures/failure.dart';
import '../../../domain/entities/provider/provider_config.dart';
import '../../../domain/entities/provider/provider_connectivity_report.dart';
import '../../services/provider_config_connectivity_service.dart';

/// [ARCH: APPLICATION_USECASE]
/// ROLE: Tests provider configuration connectivity across Core, Live, and Polling.
/// CONTRACT: Returns [ProviderConnectivityReport] or [ValidationFailure] when required config is missing.
class TestProviderConfig {
  final ProviderConfigConnectivityService _service;

  TestProviderConfig(this._service);

  Future<Either<Failure, ProviderConnectivityReport>> execute(
    ProviderConfig config,
  ) {
    return _service.test(config);
  }
}
