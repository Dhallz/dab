import 'package:dab_api/src/domain/dtos/teams/teams_message_dto.dart';
import 'package:dab_api/src/domain/entities/user/user.dart';
import 'package:dab_api/src/domain/ports/i_activity_source.dart';
import 'package:dab_api/src/domain/ports/i_discovery_source.dart';
import 'package:fpdart/fpdart.dart';

import '../../../domain/core/failures/failure.dart';

/// [ARCH: INFRASTRUCTURE_SOURCE]
/// ROLE: Raw I/O Handler for Microsoft Teams Message retrieval.
/// CONTRACT: Fetches technical [TeamsMessageDto] from Microsoft Graph API.
/// CONSTRAINTS: Must be READ-ONLY. Placeholder implementation.
class TeamsMessageSource
    implements IActivitySource<TeamsMessageDto>, IDiscoverySource {
  /// Placeholder for the Microsoft Teams Graph Client.
  TeamsMessageSource();

  @override
  Future<List<TeamsMessageDto>> fetchRawData(
    List<User> users,
    DateTime start,
    DateTime end,
    bool authoredOnly,
  ) async {
    // TODO: Implement Graph API message retrieval by user/channel.
    return [];
  }

  @override
  Future<Either<Failure, String?>> lookupExternalId(
    String name,
    String email,
  ) async {
    // TODO: Implement Teams user lookup by email via Graph API.
    return const Right(null);
  }
}
