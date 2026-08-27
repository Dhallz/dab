import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart' hide Group;

import '../../../domain/containers/user_usecases.dart';
import '../../../domain/core/failures.dart';
import '../../../domain/entities/group/group.dart';
import '../../../services/service_locator.dart';

/// [ARCH: PRESENTATION]
/// ROLE: Shared Directory groups for Explorer, Insights, and any other picker.
/// CONTRACT: One list for the session. Load from `GET /groups`; CRUD updates
/// this list so every Directory stays in sync.
final directoryGroupsProvider =
    NotifierProvider<DirectoryGroupsNotifier, List<Group>>(
      DirectoryGroupsNotifier.new,
    );

class DirectoryGroupsNotifier extends Notifier<List<Group>> {
  DirectoryGroupsNotifier({UserUseCases? userUseCases})
    : _userUseCases = userUseCases;

  final UserUseCases? _userUseCases;

  UserUseCases get _groups => _userUseCases ?? sl.userUseCases;

  @override
  List<Group> build() => const [];

  /// Replaces the shared list (used after a view fetches `GET /groups`).
  void replaceAll(List<Group> groups) {
    state = List<Group>.unmodifiable(groups);
  }

  Future<List<Group>> refresh() async {
    final result = await _groups.getGroups.execute();
    return result.fold((_) => state, (groups) {
      replaceAll(groups);
      return groups;
    });
  }

  void upsert(Group group) {
    final exists = state.any((item) => item.id == group.id);
    replaceAll(
      exists
          ? [
              for (final item in state)
                if (item.id == group.id) group else item,
            ]
          : [...state, group],
    );
  }

  void remove(String groupId) {
    replaceAll([for (final item in state) if (item.id != groupId) item]);
  }

  Future<Either<AppFailure, Group>> save(Group group) async {
    final result = await _groups.saveGroup.execute(group);
    result.fold((_) {}, upsert);
    return result;
  }

  Future<Either<AppFailure, void>> delete(String groupId) async {
    final result = await _groups.deleteGroup.execute(groupId);
    result.fold((_) {}, (_) => remove(groupId));
    return result;
  }
}
