import 'package:dab_api/src/domain/entities/session.dart';
import 'package:dab_api/src/domain/entities/user.dart';
import 'package:dab_api/src/infrastructure/database/tables/activities_table.dart';
import 'package:dab_api/src/infrastructure/database/tables/activity_phorge_table.dart';
import 'package:dab_api/src/infrastructure/database/tables/sessions_table.dart';
import 'package:dab_api/src/infrastructure/database/tables/users_table.dart';
import 'package:drift/drift.dart';
import 'package:drift_postgres/drift_postgres.dart';
import 'package:postgres/postgres.dart' hide Session;

part 'app_database.g.dart';

@DriftDatabase(
  tables: [UsersTable, ActivitiesTable, ActivityPhorgeTable, SessionsTable],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase(super.e);

  @override
  int get schemaVersion => 2; // Incremented for new activity structure

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) async {
      await m.createAll();
    },
    onUpgrade: (m, from, to) async {
      if (from < 2) {
        // Handle migration from old activities to new structure
        // Since this is early dev, we can just recreate or add tables
        await m.createTable(activityPhorgeTable);
        // Note: activitiesTable column changes are handled by Drift usually,
        // but since we renamed column, we might need a migration step if data exists.
      }
    },
    beforeOpen: (details) async {
      // PRAGMA foreign_keys = ON is for SQLite, but we use Postgres.
      // Postgres handles FKs by default.
    },
  );

  static AppDatabase connect({
    required String host,
    required int port,
    required String database,
    required String user,
    required String password,
  }) {
    return AppDatabase(
      PgDatabase(
        endpoint: Endpoint(
          host: host,
          port: port,
          database: database,
          username: user,
          password: password,
        ),
        settings: const ConnectionSettings(sslMode: SslMode.disable),
      ),
    );
  }

  @override
  Future<void> close() async {
    await super.close();
  }
}
