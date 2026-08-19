import 'dart:async';

import 'package:dab_app/domain/containers/metadata_usecases.dart';
import 'package:dab_app/domain/containers/system_usecases.dart';
import 'package:dab_app/domain/core/failures.dart';
import 'package:dab_app/domain/entities/provider/provider_config.dart';
import 'package:dab_app/domain/entities/provider/provider_connectivity_report.dart';
import 'package:dab_app/domain/entities/user/user_provider_credential_summary.dart';
import 'package:dab_app/domain/repositories/abs_i_provider_config_repository.dart';
import 'package:dab_app/domain/repositories/abs_i_user_repository.dart';
import 'package:dab_app/presentation/core/models/view_status.dart';
import 'package:dab_app/presentation/features/app/app_notifier.dart';
import 'package:dab_app/presentation/features/app/app_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

class _MockUserRepository extends Mock implements IUserRepository {}

class _MockProviderConfigRepository extends Mock
    implements IProviderConfigRepository {}

class _MockSystemUseCases extends Mock implements SystemUseCases {}

class _MockMetadataUseCases extends Mock implements MetadataUseCases {}

class _HarnessAppNotifier extends AppNotifier {
  _HarnessAppNotifier(
    IUserRepository users,
    IProviderConfigRepository providers,
  ) : super(_MockSystemUseCases(), _MockMetadataUseCases(), users, providers);

  @override
  AppState build() => const AppState(
    status: ViewStatus.success,
    configs: [
      ProviderConfig(
        id: 'github',
        name: 'GitHub',
        baseUrl: 'https://github.com',
        isActive: true,
      ),
      ProviderConfig(
        id: 'slack',
        name: 'Slack',
        baseUrl: 'https://slack.com',
        isActive: true,
      ),
    ],
  );
}

ProviderConnectivityReport _failedLiveReport() {
  const failed = ProviderSectionResult(
    status: ViewStatus.failure,
    message: 'Live webhook missing',
  );
  const ok = ProviderSectionResult(status: ViewStatus.success, message: 'ok');
  return const ProviderConnectivityReport(
    aggregate: ViewStatus.failure,
    summaryMessage: 'Live webhook missing',
    core: ok,
    live: failed,
    polling: ok,
  );
}

void main() {
  late _MockUserRepository users;
  late _MockProviderConfigRepository providers;

  setUpAll(() {
    registerFallbackValue(
      const ProviderConfig(
        id: 'fallback',
        name: 'Fallback',
        baseUrl: 'https://example.com',
        isActive: true,
      ),
    );
  });

  setUp(() {
    users = _MockUserRepository();
    providers = _MockProviderConfigRepository();
  });

  test(
    'seeds connected credentials green and does not flash red on a failed org test',
    () async {
      final githubTest =
          Completer<Either<AppFailure, ProviderConnectivityReport>>();
      when(() => users.listMyCredentials()).thenAnswer(
        (_) async => const Right([
          UserProviderCredentialSummary(
            providerId: 'github',
            status: 'connected',
            hasSecret: true,
            externalUsername: 'alice',
          ),
        ]),
      );
      when(() => providers.testProviderConfig(any())).thenAnswer((invocation) {
        final config = invocation.positionalArguments.first as ProviderConfig;
        if (config.id == 'github') return githubTest.future;
        return Future.value(Left(const ServerFailure(message: 'bot missing')));
      });

      final container = ProviderContainer(
        overrides: [
          appNotifierProvider.overrideWith(
            () => _HarnessAppNotifier(users, providers),
          ),
        ],
      );
      addTearDown(container.dispose);
      final sub = container.listen(appNotifierProvider, (_, _) {});
      addTearDown(sub.close);

      final refresh = container
          .read(appNotifierProvider.notifier)
          .refreshProviderConnectionStatuses();
      await Future<void>.delayed(Duration.zero);

      expect(
        container
            .read(appNotifierProvider)
            .providerConnectionStatuses['github']
            ?.status,
        ViewStatus.success,
      );

      githubTest.complete(Right(_failedLiveReport()));
      await refresh;

      final statuses = container
          .read(appNotifierProvider)
          .providerConnectionStatuses;
      expect(statuses['github']?.status, ViewStatus.success);
      expect(statuses['github']?.message, 'alice');
      expect(statuses['slack']?.status, ViewStatus.failure);
    },
  );
}
