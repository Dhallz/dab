import 'package:dab_app/domain/containers/activity_usecases.dart';
import 'package:dab_app/domain/containers/metadata_usecases.dart';
import 'package:dab_app/domain/containers/user_usecases.dart';
import 'package:dab_app/domain/entities/activity.dart';
import 'package:dab_app/domain/repositories/abs_i_activity_repository.dart';
import 'package:dab_app/domain/repositories/abs_i_user_repository.dart';
import 'package:dab_app/presentation/views/explorer/explorer_bloc.dart';
import 'package:dab_app/presentation/views/explorer/explorer_item.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockActivityRepository extends Mock implements IActivityRepository {}
class MockUserRepository extends Mock implements IUserRepository {}
class MockMetadataUseCases extends Mock implements MetadataUseCases {}

void main() {
  late ExplorerBloc explorerBloc;
  late ActivityUseCases activityUseCases;
  late UserUseCases userUseCases;
  late MockMetadataUseCases mockMetadataUseCases;
  late MockActivityRepository mockActivityRepository;
  late MockUserRepository mockUserRepository;

  setUp(() {
    mockActivityRepository = MockActivityRepository();
    mockUserRepository = MockUserRepository();
    mockMetadataUseCases = MockMetadataUseCases();

    activityUseCases = ActivityUseCases(mockActivityRepository);
    userUseCases = UserUseCases(mockUserRepository);

    explorerBloc = ExplorerBloc(
      activityUseCases,
      userUseCases,
      mockMetadataUseCases,
    );
  });

  tearDown(() {
    explorerBloc.close();
  });

  group('ExplorerBloc Grouping', () {
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

      final items = explorerBloc.testGroupActivities(activities);

      expect(items.length, 2);
      expect(items[0], isA<TaskActivityItem>());
      expect(items[1], isA<TaskActivityItem>());

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

      final items = explorerBloc.groupActivities(activities);

      expect(items.length, 1);
      expect(items[0], isA<SingleActivityItem>());
      expect((items[0] as SingleActivityItem).activity.id, '1');
    });
  });
}

// Extension to expose protected method for testing
extension ExplorerBlocTest on ExplorerBloc {
  List<ExplorerItem> testGroupActivities(List<Activity> activities) {
    return groupActivities(activities);
  }
}
