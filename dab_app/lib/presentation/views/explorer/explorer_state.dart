import 'package:dart_mappable/dart_mappable.dart';

import '../../../../domain/entities/activity.dart';
import '../../../../domain/entities/group.dart';
import '../../../../domain/entities/user.dart';

part 'explorer_state.mapper.dart';

enum ExplorerStatus { initial, loading, success, failure }

enum DirectoryType { users, groups }

@MappableClass()
class ExplorerState with ExplorerStateMappable {
  final ExplorerStatus status;
  final List<Activity> activities;
  final String? errorMessage;
  final DateTime selectedDate;

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
    this.status = ExplorerStatus.initial,
    this.activities = const [],
    this.errorMessage,
    required this.selectedDate,
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
