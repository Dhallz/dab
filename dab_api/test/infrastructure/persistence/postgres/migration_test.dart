import 'package:drift/drift.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';
import 'package:dab_api/src/infrastructure/persistence/postgres/app_database.dart';

class MockMigrator extends Mock implements Migrator {}

class MockQueryExecutor extends Mock implements QueryExecutor {}

class MockGeneratedDatabase extends Mock implements GeneratedDatabase {}

void main() {
  group('Database Migration', () {
    late AppDatabase db;
    late MockMigrator migrator;
    late MockGeneratedDatabase connection;

    setUp(() {
      final executor = MockQueryExecutor();
      db = AppDatabase(executor);
      migrator = MockMigrator();
      connection = MockGeneratedDatabase();

      registerFallbackValue(db.systemSettingsTable);
      registerFallbackValue(db.activityFollowsTable);
      when(() => migrator.createTable(any())).thenAnswer((_) async {});
      when(
        () => migrator.addColumn(
          db.activitiesTable,
          db.activitiesTable.senderUserId,
        ),
      ).thenAnswer((_) async {});
      when(() => migrator.database).thenReturn(connection);
      when(() => connection.customStatement(any(), any()))
          .thenAnswer((_) async {});
    });

    test('should create system_settings table when upgrading from < 15',
        () async {
      final migration = db.migration;

      await migration.onUpgrade(migrator, 14, 16);

      verify(() => migrator.createTable(db.systemSettingsTable)).called(1);
    });

    test('should create new provider TBT tables when upgrading from < 16',
        () async {
      final migration = db.migration;

      await migration.onUpgrade(migrator, 15, 16);

      verify(() => migrator.createTable(db.activityGitlabCommitTable))
          .called(1);
      verify(() => migrator.createTable(db.activityBitbucketCommitTable))
          .called(1);
      verify(() => migrator.createTable(db.activityLinearIssueTable))
          .called(1);
      verify(() => migrator.createTable(db.activityDiscordMessageTable))
          .called(1);
      verifyNever(() => migrator.createTable(db.systemSettingsTable));
    });

    test('should remove teams config and seed bitbucket when upgrading to 16',
        () async {
      final migration = db.migration;

      await migration.onUpgrade(migrator, 15, 16);

      final statements = verify(
        () => connection.customStatement(captureAny(), any()),
      ).captured.cast<String>();

      expect(
        statements.any(
          (s) => s.contains("DELETE FROM provider_configs WHERE id = 'teams'"),
        ),
        isTrue,
      );
      expect(
        statements.any((s) => s.contains("'bitbucket'")),
        isTrue,
      );
    });

    test(
        'should keep historical teams table step as raw SQL when upgrading from < 14',
        () async {
      final migration = db.migration;

      await migration.onUpgrade(migrator, 13, 16);

      final statements = verify(
        () => connection.customStatement(captureAny(), any()),
      ).captured.cast<String>();

      expect(
        statements.any(
          (s) => s.contains(
            'CREATE TABLE IF NOT EXISTS activity_teams_message',
          ),
        ),
        isTrue,
      );
    });

    test('should create activity_follows table when upgrading from < 19',
        () async {
      final migration = db.migration;

      await migration.onUpgrade(migrator, 18, 19);

      verify(() => migrator.createTable(db.activityFollowsTable)).called(1);
      verifyNever(
        () => migrator.addColumn(
          db.activitiesTable,
          db.activitiesTable.senderUserId,
        ),
      );
    });
  });
}
