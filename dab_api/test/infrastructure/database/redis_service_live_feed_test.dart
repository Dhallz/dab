import 'package:dab_api/src/domain/entities/activity/activity.dart';
import 'package:dab_api/src/domain/entities/activity/activity_provider.dart';
import 'package:dab_api/src/infrastructure/database/redis/redis_service.dart';
import 'package:test/test.dart';

void main() {
  group('RedisService live-feed window', () {
    final clock = DateTime.utc(2026, 4, 17, 15, 30);

    test('liveFeedStartOfTodayForTimezone uses org calendar date', () {
      expect(
        RedisService.liveFeedStartOfTodayForTimezone('America/New_York', clock),
        DateTime.utc(2026, 4, 17, 4),
      );
    });

    test('shouldRemoveFromLiveFeed drops archived', () {
      final startOfToday = RedisService.liveFeedStartOfTodayForTimezone(
        'UTC',
        clock,
      );
      final a = Activity(
        id: 'a1',
        userId: 'u1',
        provider: const GenericProvider(name: 'x', category: 'c'),
        title: 't',
        content: '',
        authorName: 'n',
        createdAt: clock,
        archived: true,
      );
      expect(RedisService.shouldRemoveFromLiveFeed(a, startOfToday), isTrue);
    });

    test('shouldRemoveFromLiveFeed drops before start of today', () {
      final startOfToday = RedisService.liveFeedStartOfTodayForTimezone(
        'UTC',
        clock,
      );
      final a = Activity(
        id: 'a1',
        userId: 'u1',
        provider: const GenericProvider(name: 'x', category: 'c'),
        title: 't',
        content: '',
        authorName: 'n',
        createdAt: DateTime.utc(2026, 4, 16, 23, 59),
        archived: false,
      );
      expect(RedisService.shouldRemoveFromLiveFeed(a, startOfToday), isTrue);
    });

    test('shouldRemoveFromLiveFeed keeps today non-archived', () {
      final startOfToday = RedisService.liveFeedStartOfTodayForTimezone(
        'UTC',
        clock,
      );
      final a = Activity(
        id: 'a1',
        userId: 'u1',
        provider: const GenericProvider(name: 'x', category: 'c'),
        title: 't',
        content: '',
        authorName: 'n',
        createdAt: DateTime.utc(2026, 4, 17, 0, 0),
        archived: false,
      );
      expect(RedisService.shouldRemoveFromLiveFeed(a, startOfToday), isFalse);
    });
  });
}
