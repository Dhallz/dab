import 'package:dab_api/src/domain/entities/user/user.dart';
import 'package:dab_api/src/domain/services/abs_i_discovery_source.dart';
import 'package:dab_api/src/infrastructure/sources/i_activity_source.dart';
import 'package:fpdart/fpdart.dart';
import '../../../domain/core/failure.dart';
import '../../dtos/slack/slack_message_dto.dart';

/// [ARCH: INFRASTRUCTURE_SOURCE]
/// ROLE: Raw I/O Handler for Slack Message retrieval.
/// CONTRACT: Fetches technical [SlackMessageDto] from the Slack Web API.
/// CONSTRAINTS: Must be READ-ONLY. Placeholder implementation.
class SlackMessageSource implements IActivitySource<SlackMessageDto>, IDiscoverySource {
  /// Placeholder for the Slack Web Client.
  SlackMessageSource();

  @override
  Future<List<SlackMessageDto>> fetchRawData(
    List<User> users,
    DateTime start,
    DateTime end,
    bool authoredOnly,
  ) async {
    // TODO: Implement Slack Web API message retrieval by user/channel.
    return [];
  }

  @override
  Future<Either<Failure, String?>> lookupExternalId(String name, String email) async {
    // TODO: Implement Slack user lookup by email.
    return const Right(null);
  }
}
