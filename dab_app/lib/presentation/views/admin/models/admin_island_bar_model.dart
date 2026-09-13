import 'package:dart_mappable/dart_mappable.dart';

part 'admin_island_bar_model.mapper.dart';

/// [ARCH: PRESENTATION_MODEL]
/// ROLE: Read-only projection of [AdminState] for the admin toolbar metrics row.
/// CONTRACT: Immutable POD; built via [OnAdminState.islandBarModel].
@MappableClass()
class AdminIslandBarModel with AdminIslandBarModelMappable {
  final int activeProviders;
  final int totalProviders;
  final int unresolvedIdentities;
  final int usersCount;
  final int connectionOk;
  final int connectionFailed;
  final int connectionUnknown;

  const AdminIslandBarModel({
    required this.activeProviders,
    required this.totalProviders,
    required this.unresolvedIdentities,
    required this.usersCount,
    required this.connectionOk,
    required this.connectionFailed,
    required this.connectionUnknown,
  });
}
