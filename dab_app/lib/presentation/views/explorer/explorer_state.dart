import 'package:dart_mappable/dart_mappable.dart';

import '../../../../domain/entities/activity.dart';

part 'explorer_state.mapper.dart';

enum ExplorerStatus { initial, loading, success, failure }

@MappableClass()
class ExplorerState with ExplorerStateMappable {
  final ExplorerStatus status;
  final List<Activity> activities;
  final String? errorMessage;
  final DateTime selectedDate;

  const ExplorerState({
    this.status = ExplorerStatus.initial,
    this.activities = const [],
    this.errorMessage,
    required this.selectedDate,
  });

  factory ExplorerState.initial() =>
      ExplorerState(selectedDate: DateTime.now());
}
