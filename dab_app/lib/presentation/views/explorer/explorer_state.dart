import 'package:dab_app/presentation/core/models/view_status.dart';
import 'package:dart_mappable/dart_mappable.dart';

import '../../../../domain/entities/group/group.dart';
import '../../../../domain/entities/user/user.dart';
import 'explorer_item.dart';
import 'models/explorer_date_mode.dart';
import 'models/directory_type.dart';

part 'explorer_state.mapper.dart';

/// [ARCH: PRESENTATION_STATE]
/// ROLE: Snapshot of the Explorer screen state.
@MappableClass()
class ExplorerState with ExplorerStateMappable {
  final ViewStatus status;
  final List<ExplorerItem> items;
  final String? errorMessage;
  final DateTime selectedDate;
  final ExplorerDateMode dateMode;
  final DateTime? rangeStartDate;
  final DateTime? rangeEndDate;

  // Directory
  final DirectoryType directoryType;
  final List<User> users;
  final List<Group> groups;
  final Set<String> selectedUserIds;
  final Set<String> selectedGroupIds;

  // Filters
  final List<String> availableProviders;
  final Set<String> selectedProviders;

  const ExplorerState({
    this.status = ViewStatus.initial,
    this.items = const [],
    this.errorMessage,
    required this.selectedDate,
    this.dateMode = ExplorerDateMode.singleDay,
    this.rangeStartDate,
    this.rangeEndDate,
    this.directoryType = DirectoryType.users,
    this.users = const [],
    this.groups = const [],
    this.selectedUserIds = const {},
    this.selectedGroupIds = const {},
    this.availableProviders = const [],
    this.selectedProviders = const {},
  });

  factory ExplorerState.initial() =>
      ExplorerState(selectedDate: DateTime.now());
}
