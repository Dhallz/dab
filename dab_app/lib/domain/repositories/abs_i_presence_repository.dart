import '../../domain/entities/presence.dart';

abstract interface class IPresenceRepository {
  Stream<Presence> watchPresence();
}
