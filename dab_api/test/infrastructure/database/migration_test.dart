import 'package:drift/drift.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';
import 'package:dab_api/src/infrastructure/database/app_database.dart';

class MockMigrator extends Mock implements Migrator {}
class MockQueryExecutor extends Mock implements QueryExecutor {}

void main() {
  group('Database Migration version 15', () {
    late AppDatabase db;
    late MockMigrator migrator;

    setUp(() {
      final executor = MockQueryExecutor();
      db = AppDatabase(executor);
      migrator = MockMigrator();

      registerFallbackValue(db.systemSettingsTable);
      when(() => migrator.createTable(any())).thenAnswer((_) async {});
    });

    test('should create system_settings table when upgrading from < 15', () async {
      final migration = db.migration;

      await migration.onUpgrade(migrator, 14, 15);

      verify(() => migrator.createTable(db.systemSettingsTable)).called(1);
    });
  });
}
