import 'package:fpdart/fpdart.dart';

import '../../domain/core/failures.dart';
import '../../domain/entities/upcoming/upcoming_event.dart';
import '../../domain/repositories/abs_i_upcoming_events_repository.dart';

/// [ARCH: INFRASTRUCTURE_REPOSITORY]
/// ROLE: Placeholder source for Dashboard upcoming events until a real
/// calendar connector is wired. Returns whatever static [seed] list the
/// caller provides.
/// CONTRACT: Implements [IUpcomingEventsRepository]. Filters the in-memory
/// seed by the requested window and returns ascending start times.
/// CONSTRAINTS: Does not reach out to any network or cache. Intended for
/// local development and test doubles; production builds should swap this
/// for the real repository once provider metadata lands.
class PlaceholderUpcomingEventsRepository implements IUpcomingEventsRepository {
  final List<UpcomingEvent> Function() _seedProvider;

  PlaceholderUpcomingEventsRepository({
    List<UpcomingEvent> Function()? seedProvider,
  }) : _seedProvider = seedProvider ?? (() => const <UpcomingEvent>[]);

  @override
  Future<Either<AppFailure, List<UpcomingEvent>>> getUpcomingEvents({
    DateTime? from,
    DateTime? to,
  }) async {
    final events = List<UpcomingEvent>.from(_seedProvider());
    events.sort((a, b) => a.startsAt.compareTo(b.startsAt));
    final windowed = events
        .where((event) {
          if (from != null && event.startsAt.isBefore(from)) return false;
          if (to != null && event.startsAt.isAfter(to)) return false;
          return true;
        })
        .toList(growable: false);
    return Right(windowed);
  }
}
