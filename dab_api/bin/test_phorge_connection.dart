import 'dart:io';

import 'package:dab_api/src/application/services/connector_registry.dart';
import 'package:dab_api/src/application/services/unified_activity_fetcher.dart';
import 'package:dab_api/src/domain/core/failures/failure.dart';
import 'package:dab_api/src/domain/dtos/phorge/phorge_project/phorge_project_dto.dart';
import 'package:dab_api/src/domain/dtos/phorge/phorge_revision/phorge_revision_dto.dart';
import 'package:dab_api/src/domain/dtos/phorge/phorge_task/phorge_task_bundle_dto.dart';
import 'package:dab_api/src/domain/entities/group/group.dart';
import 'package:dab_api/src/domain/entities/provider/provider_config.dart';
import 'package:dab_api/src/domain/entities/user/user.dart';
import 'package:dab_api/src/domain/entities/user/user_identity.dart';
import 'package:dab_api/src/domain/entities/user/user_identity_status.dart';
import 'package:dab_api/src/domain/entities/user/user_role.dart';
import 'package:dab_api/src/domain/core/provider_credential_keys.dart';
import 'package:dab_api/src/domain/contracts/ports/abs_i_credential_resolver.dart';
import 'package:dab_api/src/domain/contracts/repositories/abs_i_provider_config_repository.dart';
import 'package:dab_api/src/domain/contracts/repositories/abs_i_user_repository.dart';
import 'package:dab_api/src/infrastructure/core/config/config.dart';
import 'package:dab_api/src/infrastructure/protocols/conduit/http_conduit_protocol.dart';
import 'package:dab_api/src/infrastructure/sources/phorge/phorge_project_source.dart';
import 'package:dab_api/src/infrastructure/sources/phorge/phorge_revision_source.dart';
import 'package:dab_api/src/infrastructure/sources/phorge/phorge_task_source.dart';
import 'package:fpdart/fpdart.dart' hide Group;

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

  final client = HttpConduitProtocol();
  final mockUserRepo = _MockUserRepo();

  // -----------------------------------------------------
  // [ARCH: TEST]
  // ROLE: Integration Test for Activity Architecture.
  // CONTRACT: Validates the Source -> Registry -> Fetcher pipeline.
  // -----------------------------------------------------

  print('🧪 Initializing Activity System (Source + typed pair)...');

  // Infrastructure Sources (Raw I/O)
  final mockConfigRepo = _MockProviderConfigRepo();
  final projectSource = PhorgeProjectSource(client);
  final taskSource = PhorgeTaskSource(
    client,
    credentials: _EmptyCredentialResolver(),
    configs: mockConfigRepo,
  );
  final revisionSource = PhorgeRevisionSource(
    client,
    credentials: _EmptyCredentialResolver(),
    configs: mockConfigRepo,
  );

  // Application Registry
  final registry = ConnectorRegistry();
  registry.register<PhorgeTaskBundleDto>(
    TypedConnectorPair<PhorgeTaskBundleDto>(
      source: taskSource,
      providerId: 'phorge',
      mapItemToActivities: (bundle, users) => bundle.toActivities(users),
    ),
  );
  registry.register<PhorgeRevisionDto>(
    TypedConnectorPair<PhorgeRevisionDto>(
      source: revisionSource,
      providerId: 'phorge',
      mapItemToActivities: (data, users) => data.toActivities(users),
    ),
  );

  // Mock config repository to allow "Phorge" activities

  // Application Orchestrator
  final fetcher = UnifiedActivityFetcher(
    registry,
    mockConfigRepo,
    mockUserRepo,
    (_, {String level = 'INFO', Map<String, dynamic>? extra}) {},
  );

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
    mockUserRepo.identities = [
      UserIdentity(
        id: '${dummyUser.id}_phorge',
        userId: dummyUser.id,
        providerId: 'phorge',
        externalId: phid.toString(),
        status: UserIdentityStatus.linked,
        createdAt: DateTime.now(),
      ),
    ];

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

class _EmptyCredentialResolver implements AbsICredentialResolver {
  @override
  Future<Map<String, dynamic>?> getUserSettings({
    required String userId,
    required String providerId,
  }) async => null;

  @override
  Future<Map<String, Map<String, dynamic>>> getUserSettingsForUsers({
    required Iterable<String> userIds,
    required String providerId,
  }) async => const {};

  @override
  Map<String, dynamic> overlay({
    required Map<String, dynamic> orgSettings,
    Map<String, dynamic>? userSettings,
  }) {
    return overlayProviderSecrets(
      orgSettings: orgSettings,
      userSettings: userSettings,
    );
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

class _MockUserRepo implements IUserRepository {
  List<UserIdentity> identities = [];

  @override
  Future<Either<DatabaseFailure, List<UserIdentity>>>
  getIdentitiesForUsersAndProvider(
    Iterable<String> userIds,
    String providerId,
  ) async {
    final ids = userIds.toSet();
    return Right(
      identities
          .where((i) => i.providerId == providerId && ids.contains(i.userId))
          .toList(),
    );
  }

  @override
  Future<Either<DatabaseFailure, UserIdentity?>> getIdentity(
    String userId,
    String providerId,
  ) async => Right(
    identities
        .where((i) => i.userId == userId && i.providerId == providerId)
        .firstOrNull,
  );

  @override
  Future<Either<DatabaseFailure, List<UserIdentity>>>
  getAllIdentities() async => Right(identities);

  @override
  Future<Either<DatabaseFailure, List<UserIdentity>>> getIdentities(
    String userId,
  ) async => Right(identities.where((i) => i.userId == userId).toList());

  @override
  Future<Either<DatabaseFailure, UserIdentity>> linkIdentity(
    UserIdentity identity,
  ) async => Right(identity);

  @override
  Future<Either<Failure, void>> deleteIdentity(String identityId) async {
    final before = identities.length;
    identities.removeWhere((i) => i.id == identityId);
    if (identities.length == before) {
      return Left(NotFoundFailure('Identity not found: $identityId'));
    }
    return const Right(null);
  }

  @override
  Future<Either<DatabaseFailure, void>> deleteGroup(String id) async =>
      const Left(DatabaseFailure('Not implemented in test script'));

  @override
  Future<Either<DatabaseFailure, User?>> findByEmail(String email) async =>
      const Left(DatabaseFailure('Not implemented in test script'));

  @override
  Future<Either<DatabaseFailure, List<Group>>> getGroups() async =>
      const Left(DatabaseFailure('Not implemented in test script'));

  @override
  Future<Either<Failure, User>> getUser(String id) async =>
      const Left(DatabaseFailure('Not implemented in test script'));

  @override
  Future<Either<DatabaseFailure, List<User>>> getUsers() async =>
      const Left(DatabaseFailure('Not implemented in test script'));

  @override
  Future<Either<DatabaseFailure, List<User>>> getUsersByGroup(
    String groupId,
  ) async => const Left(DatabaseFailure('Not implemented in test script'));

  @override
  Future<Either<DatabaseFailure, Group>> saveGroup(Group group) async =>
      const Left(DatabaseFailure('Not implemented in test script'));

  @override
  Future<Either<DatabaseFailure, void>> saveUser(User user) async =>
      const Left(DatabaseFailure('Not implemented in test script'));
}
