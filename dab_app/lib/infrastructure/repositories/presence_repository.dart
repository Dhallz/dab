import 'dart:convert';
import '../../../domain/entities/presence.dart';
import '../../../domain/repositories/abs_i_presence_repository.dart';
import '../datasources/presence_remote_data_source.dart';
import '../repositories/core/repository.dart';

/// [ARCH: INFRASTRUCTURE_REPOSITORY]
/// ROLE: Implementation of Real-time Presence tracking in the Client.
/// CONTRACT: Implements [IPresenceRepository].
/// CONSTRAINTS: Bridges [PresenceRemoteDataSource] (WebSocket) to Domain Entities. 
class PresenceRepository extends Repository implements IPresenceRepository {
  final PresenceRemoteDataSource _remoteDataSource;

  PresenceRepository(this._remoteDataSource);

  @override
  Stream<Presence> watchPresence() {
    return _remoteDataSource
        .watchPresence()
        .map((event) {
          final Map<String, dynamic> json = jsonDecode(event);
          if (json['type'] == 'PRESENCE_UPDATE') {
            return PresenceMapper.fromMap(json['data']);
          }
          // Filter out or handle other events. We'll return null and whereType will filter it later,
          // but Dart stream needs non-null if type is Presence. So we throw exception to be caught or filter.
          throw Exception('Not a presence event');
        })
        .handleError((e) {
          print('Error watching presence: $e');
        });
  }
}
