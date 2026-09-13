import 'linear_team.dart';

/// [ARCH: DOMAIN_ENTITY]
/// ROLE: Linear teams the signed-in user can see plus instance watch keys.
class LinearTeamWatchList {
  final List<LinearTeam> available;
  final List<String> selected;

  const LinearTeamWatchList({
    this.available = const [],
    this.selected = const [],
  });

  factory LinearTeamWatchList.fromMap(Map<String, dynamic> map) {
    final rawAvailable = map['available'];
    final available = <LinearTeam>[];
    if (rawAvailable is List) {
      for (final item in rawAvailable) {
        if (item is Map<String, dynamic>) {
          available.add(LinearTeam.fromMap(item));
        } else if (item is Map) {
          available.add(LinearTeam.fromMap(Map<String, dynamic>.from(item)));
        }
      }
    }
    final rawSelected = map['selected'];
    final selected = <String>[];
    if (rawSelected is List) {
      for (final item in rawSelected) {
        final key = item.toString().trim();
        if (key.isNotEmpty) selected.add(key);
      }
    }
    return LinearTeamWatchList(available: available, selected: selected);
  }
}
