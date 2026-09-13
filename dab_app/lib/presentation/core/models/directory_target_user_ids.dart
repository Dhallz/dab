import '../../../domain/entities/group/group.dart';
import 'directory_type.dart';

/// [ARCH: PRESENTATION_CORE]
/// ROLE: Resolves Directory selection to DAB user ids for search/filter.
Set<String> directoryTargetUserIds({
  required DirectoryType directoryType,
  required Set<String> selectedUserIds,
  required Set<String> selectedGroupIds,
  required List<Group> groups,
}) {
  if (directoryType == DirectoryType.users) {
    return Set<String>.from(selectedUserIds);
  }
  final ids = <String>{};
  for (final groupId in selectedGroupIds) {
    for (final group in groups) {
      if (group.id != groupId) continue;
      ids.addAll(group.members.map((member) => member.id));
    }
  }
  return ids;
}
