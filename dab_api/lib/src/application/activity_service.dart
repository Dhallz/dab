import 'dart:async';

import 'package:uuid/uuid.dart';

import '../domain/entities/activity.dart';
import '../domain/entities/activity_provider.dart';
import '../domain/repositories/abs_i_activity_repository.dart';
import '../domain/repositories/abs_i_auth_repository.dart';
import '../infrastructure/connectors/phorge/phorge_connector.dart';
import '../infrastructure/database/redis/redis_service.dart';
import 'presence_service.dart';

class ActivityService {
  final AbsIActivityRepository _repo;
  final AbsIAuthRepository _authRepo;
  final PresenceService _presence;
  final RedisService _redis;
  final PhorgeConnector _phorge = PhorgeConnector();
  final _uuid = const Uuid();

  Timer? _phorgeTimer;
  final Set<String> _processedIds = {};

  ActivityService({
    required AbsIActivityRepository activityRepo,
    required AbsIAuthRepository authRepo,
    required PresenceService presence,
    required RedisService redis,
  }) : _repo = activityRepo,
       _authRepo = authRepo,
       _presence = presence,
       _redis = redis;

  void startPolling() {
    _phorgeTimer?.cancel();
    _phorgeTimer = Timer.periodic(
      const Duration(minutes: 1),
      (_) => _pollPhorge(),
    );
    // Initial poll
    _pollPhorge();
  }

  Future<List<Activity>> getRecent() async {
    final result = await _repo.getRecentActivities();
    return result.match(
      (f) => throw Exception(f.message),
      (activities) => activities,
    );
  }

  Future<List<Activity>> fetchPastActivities(
    String userId,
    DateTime date,
  ) async {
    final userResult = await _authRepo.findById(userId);
    return userResult.match(
      (f) => throw Exception('Failed to fetch user: ${f.message}'),
      (user) async {
        if (user == null) throw Exception('User not found');
        if (user.phorgePhid == null) return [];

        // Directly query Phorge for the historical date.
        // We do NOT save these to the database. They are hydrated at runtime.
        return await _phorge.fetchUserActivities(user: user, date: date);
      },
    );
  }

  Future<void> _pollPhorge() async {
    try {
      final usersResult = await _authRepo.findUsersWithPhorge();
      await usersResult.match(
        (f) async => print('DB Error during polling: ${f.message}'),
        (users) async {
          for (final user in users) {
            final activities = await _phorge.fetchUserActivities(user: user);
            for (final activity in activities) {
              if (_processedIds.contains(activity.id)) continue;

              final activityWithUser = Activity(
                id: activity.id,
                userId: user.id,
                provider: activity.provider,
                title: activity.title,
                content: activity.content,
                url: activity.url,
                createdAt: activity.createdAt,
              );

              final createResult = await _repo.createActivity(activityWithUser);
              await createResult.match(
                (f) async =>
                    print('Failed to save polled activity: ${f.message}'),
                (_) async {
                  await _redis.incrementVersion();
                  await _redis.fanOutActivity(activityWithUser);
                  _broadcastActivity(activityWithUser);
                  _processedIds.add(activity.id);
                },
              );

              if (_processedIds.length > 500) {
                _processedIds.remove(_processedIds.first);
              }
            }
          }
        },
      );
    } catch (e) {
      print('Error polling Phorge: $e');
    }
  }

  Future<void> logActivity({
    required String userId,
    required ActivityProvider provider,
    required String title,
    required String content,
    String? url,
  }) async {
    final activity = Activity(
      id: _uuid.v4(),
      userId: userId,
      provider: provider,
      title: title,
      content: content,
      url: url,
      createdAt: DateTime.now(),
    );

    final result = await _repo.createActivity(activity);
    await result.match(
      (f) async => print('Failed to log activity: ${f.message}'),
      (_) async {
        await _redis.incrementVersion();
        await _redis.fanOutActivity(activity);
        _broadcastActivity(activity);
      },
    );
  }

  void _broadcastActivity(Activity activity) {
    _presence.broadcast('ACTIVITY_RECEIVED', {
      'id': activity.id,
      'userId': activity.userId,
      'type': activity.type, // Backwards compatible getter
      'category': activity.provider.category,
      'provider': activity.provider.toMap(),
      'title': activity.title,
      'content': activity.content,
      'url': activity.url,
      'createdAt': activity.createdAt.toIso8601String(),
    });
  }

  void stopPolling() {
    _phorgeTimer?.cancel();
  }
}
