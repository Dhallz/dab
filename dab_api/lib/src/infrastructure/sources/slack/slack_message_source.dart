import 'package:dab_api/src/domain/entities/user.dart';
import 'package:dab_api/src/infrastructure/sources/i_activity_source.dart';
import '../../dtos/slack/slack_message_dto.dart';

/// [ARCH: INFRASTRUCTURE_SOURCE]
/// ROLE: Raw I/O Handler for Slack Message retrieval.
/// CONTRACT: Fetches technical [SlackMessageDto] from the Slack Web API.
/// CONSTRAINTS: Must be READ-ONLY. Placeholder implementation.
class SlackMessageSource implements IActivitySource<SlackMessageDto> {
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
}
