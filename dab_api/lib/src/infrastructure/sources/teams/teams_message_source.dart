import 'package:dab_api/src/domain/entities/user.dart';
import 'package:dab_api/src/infrastructure/sources/i_activity_source.dart';
import '../../dtos/teams/teams_message_dto.dart';

/// [ARCH: INFRASTRUCTURE_SOURCE]
/// ROLE: Raw I/O Handler for Microsoft Teams Message retrieval.
/// CONTRACT: Fetches technical [TeamsMessageDto] from Microsoft Graph API.
/// CONSTRAINTS: Must be READ-ONLY. Placeholder implementation.
class TeamsMessageSource implements IActivitySource<TeamsMessageDto> {
  /// Placeholder for the MS Graph Client.
  TeamsMessageSource();

  @override
  Future<List<TeamsMessageDto>> fetchRawData(
    List<User> users,
    DateTime start,
    DateTime end,
    bool authoredOnly,
  ) async {
    // TODO: Implement MS Graph API message retrieval by user/chat.
    return [];
  }
}
