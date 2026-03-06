import 'package:dart_mappable/dart_mappable.dart';

part 'explorer_event.mapper.dart';

@MappableClass()
sealed class ExplorerEvent with ExplorerEventMappable {
  const ExplorerEvent();
}

@MappableClass()
class ExplorerStarted extends ExplorerEvent with ExplorerStartedMappable {
  const ExplorerStarted();
}

@MappableClass()
class ExplorerDateChanged extends ExplorerEvent
    with ExplorerDateChangedMappable {
  final DateTime date;
  const ExplorerDateChanged(this.date);
}

@MappableClass()
class ExplorerActivityReceived extends ExplorerEvent
    with ExplorerActivityReceivedMappable {
  final dynamic activity;
  const ExplorerActivityReceived(this.activity);
}
