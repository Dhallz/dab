import 'package:dab_app/domain/containers/activity_usecases.dart';
import 'package:dab_app/domain/containers/metadata_usecases.dart';
import 'package:dab_app/domain/containers/user_usecases.dart';
import 'package:dab_app/domain/entities/activity/activity.dart';
import 'package:dab_app/domain/repositories/abs_i_activity_repository.dart';
import 'package:dab_app/domain/repositories/abs_i_user_repository.dart';
import 'package:dab_app/presentation/views/explorer/explorer_notifier.dart';
import 'package:dab_app/presentation/views/explorer/models/explorer_item.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockActivityRepository extends Mock implements IActivityRepository {}

class MockUserRepository extends Mock implements IUserRepository {}

class MockMetadataUseCases extends Mock implements MetadataUseCases {}

void main() {
  late ProviderContainer container;
  late ExplorerNotifier notifier;

  setUp(() {
    final mockActivityRepository = MockActivityRepository();
    final mockUserRepository = MockUserRepository();
    final mockMetadataUseCases = MockMetadataUseCases();

    final activityUseCases = ActivityUseCases(mockActivityRepository);
    final userUseCases = UserUseCases(mockUserRepository);

    container = ProviderContainer(
      overrides: [
        explorerNotifierProvider.overrideWith(
          () => ExplorerNotifier(
            activityUseCases,
            userUseCases,
            mockMetadataUseCases,
          ),
        ),
      ],
    );
    notifier = container.read(explorerNotifierProvider.notifier);
  });

  tearDown(() {
    container.dispose();
  });

  group('ExplorerNotifier grouping', () {
    test('should group activities correctly', () {
      final date = DateTime.now();
      final activities = [
        Activity(
          id: '1',
          userId: 'user1',
          provider: const PhorgeTaskProvider(taskPhid: 'T123'),
          title: 'Title 1',
          content: 'Content 1',
          authorName: 'Author 1',
          commentCount: 0,
          createdAt: date.subtract(const Duration(minutes: 5)),
        ),
        Activity(
          id: '2',
          userId: 'user1',
          provider: const PhorgeTaskProvider(taskPhid: 'T123'),
          title: 'Title 2',
          content: 'Content 2',
          authorName: 'Author 1',
          commentCount: 0,
          createdAt: date,
        ),
        Activity(
          id: '3',
          userId: 'user2',
          provider: const PhorgeTaskProvider(taskPhid: 'T123'),
          title: 'Title 3',
          content: 'Content 3',
          authorName: 'Author 2',
          commentCount: 0,
          createdAt: date.subtract(const Duration(minutes: 10)),
        ),
      ];

      final items = notifier.groupActivities(activities);

      expect(items.length, 2);
      expect(items[0], isA<TaskActivityItem>());
      expect(items[1], isA<SingleActivityItem>());

      final stack = items[0] as TaskActivityItem;
      expect(stack.activities.length, 2);
      expect(stack.taskId, 'T123');
      expect(stack.userId, 'user1');
    });

    test('should deduplicate activities by ID', () {
      final date = DateTime.now();
      final activity1 = Activity(
        id: '1',
        userId: 'user1',
        provider: const PhorgeTaskProvider(taskPhid: 'T123'),
        title: 'Title 1',
        content: 'Content 1',
        authorName: 'Author 1',
        commentCount: 0,
        createdAt: date,
      );

      final activities = [activity1, activity1];

      final items = notifier.groupActivities(activities);

      expect(items.length, 1);
      expect(items[0], isA<SingleActivityItem>());
      expect((items[0] as SingleActivityItem).activity.id, '1');
    });

    test('groups slack threaded messages by channel and thread', () {
      final date = DateTime.now();
      final activities = [
        Activity(
          id: 'slack-1',
          userId: 'user1',
          provider: const SlackMessageProvider(
            channelId: 'C123',
            threadTs: '1730000000.0001',
            messageTs: '1730000001.0001',
          ),
          title: 'message 1',
          content: 'first',
          authorName: 'Alice',
          commentCount: 0,
          createdAt: date.subtract(const Duration(minutes: 2)),
        ),
        Activity(
          id: 'slack-2',
          userId: 'user2',
          provider: const SlackMessageProvider(
            channelId: 'C123',
            threadTs: '1730000000.0001',
            messageTs: '1730000002.0001',
          ),
          title: 'message 2',
          content: 'second',
          authorName: 'Bob',
          commentCount: 0,
          createdAt: date,
        ),
      ];

      final items = notifier.groupActivities(activities);
      expect(items.length, 1);
      expect(items.first, isA<SlackConversationItem>());
      final grouped = items.first as SlackConversationItem;
      expect(grouped.activities.length, 2);
      expect(grouped.channelId, 'C123');
      expect(grouped.threadTs, '1730000000.0001');
    });

    test('does not group slack messages from different threads', () {
      final date = DateTime.now();
      final activities = [
        Activity(
          id: 'slack-3',
          userId: 'user1',
          provider: const SlackMessageProvider(
            channelId: 'C123',
            threadTs: '1730000000.0001',
            messageTs: '1730000003.0001',
          ),
          title: 'message 3',
          content: 'thread A',
          authorName: 'Alice',
          commentCount: 0,
          createdAt: date.subtract(const Duration(minutes: 1)),
        ),
        Activity(
          id: 'slack-4',
          userId: 'user2',
          provider: const SlackMessageProvider(
            channelId: 'C123',
            threadTs: '1730000000.0002',
            messageTs: '1730000004.0001',
          ),
          title: 'message 4',
          content: 'thread B',
          authorName: 'Bob',
          commentCount: 0,
          createdAt: date,
        ),
      ];

      final items = notifier.groupActivities(activities);
      expect(items.length, 2);
      expect(items.whereType<SlackConversationItem>().length, 0);
      expect(items.every((i) => i is SingleActivityItem), isTrue);
    });

    test('keeps non-threaded slack messages as single activity items', () {
      final date = DateTime.now();
      final activities = [
        Activity(
          id: 'slack-5',
          userId: 'user1',
          provider: const SlackMessageProvider(
            channelId: 'C123',
            messageTs: '1730000005.0001',
          ),
          title: 'message 5',
          content: 'standalone',
          authorName: 'Alice',
          commentCount: 0,
          createdAt: date,
        ),
      ];

      final items = notifier.groupActivities(activities);
      expect(items.length, 1);
      expect(items.first, isA<SingleActivityItem>());
    });

    test('groups non-threaded slack messages in same 15-min user window', () {
      final date = DateTime.utc(2026, 1, 1, 10, 5);
      final activities = [
        Activity(
          id: 'slack-6',
          userId: 'user1',
          provider: const SlackMessageProvider(
            channelId: 'C123',
            messageTs: '1730000006.0001',
          ),
          title: 'message 6',
          content: 'burst 1',
          authorName: 'Alice',
          commentCount: 0,
          createdAt: date,
        ),
        Activity(
          id: 'slack-7',
          userId: 'user1',
          provider: const SlackMessageProvider(
            channelId: 'C123',
            messageTs: '1730000007.0001',
          ),
          title: 'message 7',
          content: 'burst 2',
          authorName: 'Alice',
          commentCount: 0,
          createdAt: date.add(const Duration(minutes: 6)),
        ),
      ];

      final items = notifier.groupActivities(activities);
      expect(items.length, 1);
      expect(items.first, isA<SlackConversationItem>());
      final grouped = items.first as SlackConversationItem;
      expect(grouped.activities.length, 2);
      expect(grouped.threadTs, startsWith('burst:'));
    });

    test('does not group non-thread slack messages across 15-min windows', () {
      final date = DateTime.utc(2026, 1, 1, 10, 5);
      final activities = [
        Activity(
          id: 'slack-8',
          userId: 'user1',
          provider: const SlackMessageProvider(
            channelId: 'C123',
            messageTs: '1730000008.0001',
          ),
          title: 'message 8',
          content: 'window A',
          authorName: 'Alice',
          commentCount: 0,
          createdAt: date,
        ),
        Activity(
          id: 'slack-9',
          userId: 'user1',
          provider: const SlackMessageProvider(
            channelId: 'C123',
            messageTs: '1730000009.0001',
          ),
          title: 'message 9',
          content: 'window B',
          authorName: 'Alice',
          commentCount: 0,
          createdAt: date.add(const Duration(minutes: 20)),
        ),
      ];

      final items = notifier.groupActivities(activities);
      expect(items.length, 2);
      expect(items.every((item) => item is SingleActivityItem), isTrue);
    });
  });
}
