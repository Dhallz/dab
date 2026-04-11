import 'package:dart_mappable/dart_mappable.dart';

import 'models/directory_type.dart';

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

@MappableClass()
class ExplorerDirectoryTypeChanged extends ExplorerEvent
    with ExplorerDirectoryTypeChangedMappable {
  final DirectoryType type;
  const ExplorerDirectoryTypeChanged(this.type);
}

@MappableClass()
class ExplorerUserToggled extends ExplorerEvent
    with ExplorerUserToggledMappable {
  final String userId;
  const ExplorerUserToggled(this.userId);
}

@MappableClass()
class ExplorerGroupToggled extends ExplorerEvent
    with ExplorerGroupToggledMappable {
  final String groupId;
  const ExplorerGroupToggled(this.groupId);
}

@MappableClass()
class ExplorerProviderToggled extends ExplorerEvent
    with ExplorerProviderToggledMappable {
  final String provider;
  const ExplorerProviderToggled(this.provider);
}

@MappableClass()
class ExplorerRefreshRequested extends ExplorerEvent
    with ExplorerRefreshRequestedMappable {
  const ExplorerRefreshRequested();
}

@MappableClass()
class ExplorerGroupSaved extends ExplorerEvent with ExplorerGroupSavedMappable {
  final dynamic group;
  const ExplorerGroupSaved(this.group);
}

@MappableClass()
class ExplorerStackToggled extends ExplorerEvent
    with ExplorerStackToggledMappable {
  final String taskId;
  const ExplorerStackToggled(this.taskId);
}
