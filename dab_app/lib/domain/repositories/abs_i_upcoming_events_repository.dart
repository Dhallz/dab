import 'package:fpdart/fpdart.dart';

import '../core/failures.dart';
import '../entities/upcoming/upcoming_event.dart';

/// [ARCH: DOMAIN_CONTRACT]
/// ROLE: Source-agnostic contract for retrieving upcoming time-anchored events
/// consumed by the Dashboard "Upcoming Soon" section.
/// CONTRACT: Implementations may be placeholder-only (returning a static or
/// empty set) until calendar providers are wired.
/// CONSTRAINTS: Must be idempotent; repeated calls for the same window must
/// return stable ids so banner dedupe works correctly.
abstract class IUpcomingEventsRepository {
  /// Returns events that start within the requested window. Both bounds are
  /// inclusive. Results must be sorted by `startsAt` ascending.
  Future<Either<AppFailure, List<UpcomingEvent>>> getUpcomingEvents({
    DateTime? from,
    DateTime? to,
  });
}
