import 'dart:io';

import 'package:dab_api/src/application/services/connector_registry.dart';
import 'package:dab_api/src/application/services/unified_activity_fetcher.dart';
import 'package:dab_api/src/domain/core/failure.dart';
import 'package:dab_api/src/domain/entities/provider/provider_config.dart';
import 'package:dab_api/src/domain/entities/user/user.dart';
import 'package:dab_api/src/domain/entities/user/user_role.dart';
import 'package:dab_api/src/domain/mappers/phorge/phorge_revision_mapper.dart';
import 'package:dab_api/src/domain/mappers/phorge/phorge_task_mapper.dart';
import 'package:dab_api/src/domain/repositories/abs_i_provider_config_repository.dart';
import 'package:dab_api/src/domain/services/phorge_sprint_service.dart';
import 'package:dab_api/src/infrastructure/config/config.dart';
import 'package:dab_api/src/infrastructure/connectors/phorge/phorge_client.dart';
import 'package:dab_api/src/infrastructure/sources/phorge/phorge_project_source.dart';
import 'package:dab_api/src/infrastructure/sources/phorge/phorge_revision_source.dart';
import 'package:dab_api/src/infrastructure/sources/phorge/phorge_task_source.dart';
import 'package:fpdart/fpdart.dart';

void main() async {
  final config = Config();

  if (config.phorgeUrl.contains('example.com') ||
      config.phorgeApiToken.isEmpty) {
    print('====================================================');
    print('❌ MISSING CONFIGURATION!');
    print('Please create a .env file in the dab_api directory:');
    print('PHORGE_URL=https://your-company.phorge.com');
    print('PHORGE_API_TOKEN=api-your-long-conduit-token');
    print('====================================================');
    exit(1);
  }

  print('\n🔗 Connecting to Phorge at ${config.phorgeUrl}...\n');

  final client = PhorgeClient();
  final sprintService = PhorgeSprintService();

  // -----------------------------------------------------
  // [ARCH: TEST]
  // ROLE: Integration Test for Activity Architecture.
  // CONTRACT: Validates the Source -> Registry -> Fetcher pipeline.
  // -----------------------------------------------------

  print('🧪 Initializing Activity System (Source/Mapper Pair)...');

  // Infrastructure Sources (Raw I/O)
  final projectSource = PhorgeProjectSource(client, sprintService);
  final taskSource = PhorgeTaskSource(client, sprintService);
  final revisionSource = PhorgeRevisionSource(client);

  // Application Registry
  final registry = ConnectorRegistry();
  registry.register(taskSource, PhorgeTaskMapper());
  registry.register(revisionSource, PhorgeRevisionMapper());

  // Mock config repository to allow "Phorge" activities
  final mockConfigRepo = _MockProviderConfigRepo();

  // Application Orchestrator
  final fetcher = UnifiedActivityFetcher(registry, mockConfigRepo);

  try {
    print('==========================================');
    print('1. Testing Authentication (user.whoami)');
    print('==========================================');
    final whoami = await client.call('user.whoami', {});
    final phid = whoami['phid'];
    final realName = whoami['realName'];
    print('✅ Authenticated successfully as $realName ($phid)\n');

    print('==========================================');
    print('2. Testing Metadata (Available Tags)');
    print('==========================================');
    final projects = await projectSource.fetchActiveSprintProjects(phid);
    print('✅ Successfully fetched ${projects.length} active tags.');

    final sampleSize = projects.length > 5 ? 5 : projects.length;
    print('   Showing first $sampleSize tags:');
    for (var i = 0; i < sampleSize; i++) {
      final color = projects[i].color != null
          ? '[Color: ${projects[i].color}]'
          : '';
      print('   - ${projects[i].name} $color');
    }
    print('');

    print('==========================================');
    print('3. Testing Dashboard Activity Feed');
    print('==========================================');
    final dummyUser = User(
      id: 'test-user',
      name: realName,
      email: 'test@example.com',
      passwordHash: '',
      role: UserRole.standard,
      createdAt: DateTime.now(),
      phorgePhid: phid,
    );

    print('⏳ Querying activities using UnifiedActivityFetcher...');
    final start = DateTime.now().subtract(const Duration(days: 7));
    final end = DateTime.now();

    final activities = await fetcher.fetchAll(
      users: [dummyUser],
      start: start,
      end: end,
      authoredOnly: true,
    );

    print('✅ Successfully fetched ${activities.length} activities:');

    for (var act in activities) {
      print(
        '\n   [ ${act.createdAt.toLocal().toString().split('.')[0]} ] ${act.title}',
      );
      print('   ↳ ${act.content}');
      print('   🔗 ${act.url}');
    }

    print('\n🎉 INTEGRATION TEST COMPLETE 🎉');
  } catch (e) {
    print('\n❌ PIPELINE ERROR: $e');
  } finally {
    exit(0);
  }
}

class _MockProviderConfigRepo implements AbsIProviderConfigRepository {
  @override
  Future<Either<Failure, List<ProviderConfig>>> getConfigs() async {
    return Right([
      ProviderConfig(
        id: 'phorge',
        name: 'Phorge',
        baseUrl: 'https://phorge.example.com',
        settings: {},
        isActive: true,
      ),
    ]);
  }

  @override
  Future<Either<Failure, int>> countActiveConfigs() async => const Right(1);

  @override
  Future<Either<Failure, ProviderConfig>> saveConfig(
    ProviderConfig config,
  ) async => Right(config);
}
