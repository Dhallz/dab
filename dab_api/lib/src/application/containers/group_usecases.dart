import '../usecases/group/delete_group.dart';
import '../usecases/group/get_groups.dart';
import '../usecases/group/save_group.dart';

class GroupUseCases {
  final DeleteGroup deleteGroup;
  final GetGroups getGroups;
  final SaveGroup saveGroup;

  GroupUseCases({
    required this.deleteGroup,
    required this.getGroups,
    required this.saveGroup,
  });
}
