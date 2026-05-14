import 'package:dab_api/src/domain/core/failures/failure.dart';
import 'package:dab_api/src/domain/dtos/slack/slack_message_dto.dart';
import 'package:dab_api/src/domain/entities/user/user.dart';
import 'package:fpdart/fpdart.dart';

/// [ARCH: DOMAIN_PORT]
/// ROLE: Read-only Slack Web API contract — returns message DTOs only.
/// CONTRACT: Implementations handle tokens, channels, and workspace resolution in infrastructure.
/// CONSTRAINTS: Read-only toward Slack; failures surface as [Either] left values.
abstract interface class AbsISlackGateway {
  /// Fetches Slack message payloads visible to [users] in \[start, end\].
  /// [authoredOnly] requests messages attributed to linked Slack workspace members where applicable.
  Future<Either<Failure, List<SlackMessageDto>>> fetchMessageDtos({
    required List<User> users,
    required DateTime start,
    required DateTime end,
    required bool authoredOnly,
  });
}
