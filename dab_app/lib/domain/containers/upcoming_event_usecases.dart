import '../repositories/abs_i_upcoming_events_repository.dart';
import '../usecases/upcoming/get_upcoming_events.dart';

/// Aggregates the upcoming-event use cases consumed by the Dashboard notifier.
class UpcomingEventUseCases {
  final GetUpcomingEvents getUpcomingEvents;

  UpcomingEventUseCases(IUpcomingEventsRepository repository)
    : getUpcomingEvents = GetUpcomingEvents(repository);
}
