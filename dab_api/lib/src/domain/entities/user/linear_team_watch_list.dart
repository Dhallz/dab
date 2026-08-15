import 'linear_team.dart';

final _linearTeamKeyPattern = RegExp(r'^[A-Za-z][A-Za-z0-9_]{0,99}$');

/// Parses Admin/watch-list `teamKeys` (newline or comma separated).
List<String> parseLinearTeamKeys(dynamic raw) {
  if (raw is List) {
    return [
      for (final item in raw)
        if (_linearTeamKeyPattern.hasMatch(item.toString().trim()))
          item.toString().trim(),
    ];
  }
  final text = (raw ?? '').toString();
  if (text.trim().isEmpty) return const [];
  return [
    for (final part in text.split(RegExp(r'[\n,]+')))
      if (_linearTeamKeyPattern.hasMatch(part.trim())) part.trim(),
  ];
}

/// [ARCH: DOMAIN]
/// ROLE: Linear teams available to the caller plus the instance watch list.
class LinearTeamWatchList {
  const LinearTeamWatchList({
    required this.available,
    required this.selected,
  });

  final List<LinearTeam> available;
  final List<String> selected;

  Map<String, dynamic> toMap() => {
    'available': available.map((t) => t.toMap()).toList(),
    'selected': selected,
  };
}
