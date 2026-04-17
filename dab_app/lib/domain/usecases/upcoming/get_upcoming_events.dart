import 'package:fpdart/fpdart.dart';

import '../../core/failures.dart';
import '../../entities/upcoming/upcoming_event.dart';
import '../../repositories/abs_i_upcoming_events_repository.dart';

/// [ARCH: APPLICATION_USECASE]
/// ROLE: Reads upcoming events from the configured repository for the
/// Dashboard "Upcoming Soon" section.
class GetUpcomingEvents {
  final IUpcomingEventsRepository repository;

  GetUpcomingEvents(this.repository);

  Future<Either<AppFailure, List<UpcomingEvent>>> execute({
    DateTime? from,
    DateTime? to,
  }) {
    return repository.getUpcomingEvents(from: from, to: to);
  }
}
