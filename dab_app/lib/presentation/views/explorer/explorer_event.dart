import 'package:dart_mappable/dart_mappable.dart';

import '../../../../domain/entities/activity/activity_category.dart';
import 'models/explorer_date_mode.dart';
import 'models/directory_type.dart';

part 'explorer_event.mapper.dart';

@MappableClass()
sealed class ExplorerEvent with ExplorerEventMappable {
  const ExplorerEvent();
}

@MappableClass()
class ExplorerStarted extends ExplorerEvent with ExplorerStartedMappable {
  final String? connectedUserId;
  const ExplorerStarted({this.connectedUserId});
}

@MappableClass()
class ExplorerDateChanged extends ExplorerEvent
    with ExplorerDateChangedMappable {
  final DateTime date;
  const ExplorerDateChanged(this.date);
}

@MappableClass()
class ExplorerDateModeChanged extends ExplorerEvent
    with ExplorerDateModeChangedMappable {
  final ExplorerDateMode mode;
  const ExplorerDateModeChanged(this.mode);
}

@MappableClass()
class ExplorerDateRangeChanged extends ExplorerEvent
    with ExplorerDateRangeChangedMappable {
  final DateTime startDate;
  final DateTime endDate;
  const ExplorerDateRangeChanged({
    required this.startDate,
    required this.endDate,
  });
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
class ExplorerGroupRenamed extends ExplorerEvent
    with ExplorerGroupRenamedMappable {
  final String groupId;
  final String name;
  const ExplorerGroupRenamed({required this.groupId, required this.name});
}

@MappableClass()
class ExplorerGroupDeleted extends ExplorerEvent
    with ExplorerGroupDeletedMappable {
  final String groupId;
  const ExplorerGroupDeleted(this.groupId);
}

@MappableClass()
class ExplorerActivityCategoryToggled extends ExplorerEvent
    with ExplorerActivityCategoryToggledMappable {
  final ActivityCategory category;
  const ExplorerActivityCategoryToggled(this.category);
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
