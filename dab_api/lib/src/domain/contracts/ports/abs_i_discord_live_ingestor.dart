import 'package:fpdart/fpdart.dart';

import '../../core/failures/failure.dart';

/// [ARCH: DOMAIN_PORT]
/// ROLE: Hands Discord Gateway `MESSAGE_CREATE` payloads to live ingest.
/// CONTRACT: Infrastructure Gateway depends on this port so it never imports
/// application use cases. Returns [Right] on handled payloads (including
/// ignored) and [Left] only on persistence failures.
abstract interface class AbsIDiscordLiveIngestor {
  /// Ingests a Discord Gateway message-create dispatch payload.
  Future<Either<Failure, void>> ingestMessageCreate(
    Map<String, dynamic> payload,
  );
}
