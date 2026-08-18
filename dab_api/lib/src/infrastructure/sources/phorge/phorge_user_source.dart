import 'package:dab_api/src/domain/core/failures/failure.dart';
import 'package:dab_api/src/domain/dtos/phorge/phorge_user/phorge_user_dto.dart';
import 'package:dab_api/src/domain/contracts/ports/abs_i_discovery_source.dart';
import 'package:dab_api/src/infrastructure/protocols/conduit/conduit_protocol.dart';
import 'package:fpdart/fpdart.dart';

/// [ARCH: INFRASTRUCTURE_SOURCE]
/// ROLE: Infrastructure Source for Phorge User identities and profile data.
/// CONTRACT: Fetches raw User PHIDs and DTOs from the Phorge Conduit API.
/// CONSTRAINTS: Must be READ-ONLY. Implements heuristic identity resolution.
class PhorgeUserSource implements AbsIDiscoverySource {
  final ConduitProtocol _client;

  PhorgeUserSource(this._client);

  /// Searches Phorge for a user PHID by name or email.
  Future<String?> lookupUserPhid(String name, String email) async {
    final prefix = email.split('@').first;

    // Attempt 1: Prefix search
    var result = await _client.call('user.search', {
      'constraints': {'query': prefix},
    });

    var data = result['data'] as List<dynamic>?;
    if (data != null && data.isNotEmpty) {
      return (data.first as Map<String, dynamic>)['phid']?.toString();
    }

    // Attempt 2: Full name fallback
    result = await _client.call('user.search', {
      'constraints': {'query': name},
    });

    data = result['data'] as List<dynamic>?;
    if (data != null && data.isNotEmpty) {
      return (data.first as Map<String, dynamic>)['phid']?.toString();
    }

    return null;
  }

  @override
  Future<Either<Failure, String?>> lookupExternalId(
    String name,
    String email,
  ) async {
    try {
      final phid = await lookupUserPhid(name, email);
      return Right(phid);
    } catch (e) {
      return Left(DatabaseFailure('Phorge discovery failed: $e'));
    }
  }

  /// Fetches all active users from Phorge.
  Future<List<PhorgeUserDto>> fetchAllUsers() async {
    final result = await _client.call('user.search', {
      'constraints': {'isDisabled': false},
    });

    final data = result['data'] as List<dynamic>?;
    if (data == null) return [];

    return data
        .map((e) => PhorgeUserDtoMapper.fromMap(e as Map<String, dynamic>))
        .toList();
  }

  /// Full directory enumeration for provisioning ([AbsIPhorgeFacade] delegates here).
  Future<Either<Failure, List<PhorgeUserDto>>> fetchDirectoryUsers() async {
    try {
      final dtos = await fetchAllUsers();
      return Right(dtos);
    } catch (e) {
      return Left(DatabaseFailure('Phorge directory fetch failed: $e'));
    }
  }
}
