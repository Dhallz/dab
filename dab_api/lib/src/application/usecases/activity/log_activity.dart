import 'package:uuid/uuid.dart';
import '../../../domain/entities/activity.dart';
import '../../../domain/entities/activity_provider.dart';
import '../../../domain/repositories/abs_i_activity_repository.dart';
import '../../../domain/repositories/abs_i_auth_repository.dart';
import '../../../infrastructure/database/redis/redis_service.dart';
import '../../../infrastructure/websockets/presence_service.dart';

/// [ARCH: APPLICATION_USECASE]
/// ROLE: Creates and propagates a new Activity across the system.
/// CONTRACT: Persists the activity and triggers real-time updates (Redis + WebSockets).
/// CONSTRAINTS: Must ensure data consistency between DB, Cache, and Broadcast.
class LogActivity {
  final AbsIActivityRepository _repo;
  final AbsIAuthRepository _authRepo;
  final PresenceService _presence;
  final RedisService _redis;
  final _uuid = const Uuid();

  LogActivity(this._repo, this._authRepo, this._presence, this._redis);

  /// Executes the activity logging process.
  /// 
  /// 1. Data Hydration: Resolves author name from [AbsIAuthRepository].
  /// 2. Entity Creation: Constructs a unified [Activity] object.
  /// 3. Persistence: Saves the activity to the primary database.
  /// 4. Propagation:
  ///    - Increments the global activity version in Redis.
  ///    - Fans out the activity data to Redis subscribers.
  ///    - Broadcasts the update via [PresenceService] (WebSockets).
  Future<void> execute({
    required String userId,
    required ActivityProvider provider,
    required String title,
    required String content,
    String? url,
  }) async {
    final userResult = await _authRepo.findById(userId);
    final authorName = userResult.getOrElse((f) => null)?.name ?? 'Unknown';

    final activity = Activity(
      id: _uuid.v4(),
      userId: userId,
      provider: provider,
      title: title,
      content: content,
      url: url,
      authorName: authorName,
      authorAvatarUrl: null,
      commentCount: 0,
      createdAt: DateTime.now(),
    );

    // Step 1: Database Persistence
    final result = await _repo.createActivity(activity);
    if (result.isLeft()) {
      final f = result.getLeft().toNullable()!;
      print('Failed to log activity: ${f.message}');
      return;
    }

    // Step 2: Global State and Real-time Propagation
    await _redis.incrementVersion();
    await _redis.fanOutActivity(activity);
    _broadcastActivity(activity);
  }

  /// Internal helper to push activity updates to the Presence WebSocket layer.
  void _broadcastActivity(Activity activity) {
    _presence.broadcast('ACTIVITY_RECEIVED', {
      'id': activity.id,
      'userId': activity.userId,
      'type': activity.type,
      'category': activity.provider.category,
      'provider': activity.provider.toMap(),
      'title': activity.title,
      'content': activity.content,
      'url': activity.url,
      'authorName': activity.authorName,
      'authorAvatarUrl': activity.authorAvatarUrl,
      'commentCount': activity.commentCount,
      'createdAt': activity.createdAt.toIso8601String(),
    });
  }
}
