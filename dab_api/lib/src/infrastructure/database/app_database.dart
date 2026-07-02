import 'package:dab_api/src/infrastructure/database/tables/activities_table.dart';
import 'package:dab_api/src/infrastructure/database/tables/activity_github_commit_table.dart';
import 'package:dab_api/src/infrastructure/database/tables/activity_jira_issue_table.dart';
import 'package:dab_api/src/infrastructure/database/tables/activity_phorge_table.dart';
import 'package:dab_api/src/infrastructure/database/tables/activity_slack_message_table.dart';
import 'package:dab_api/src/infrastructure/database/tables/activity_teams_message_table.dart';
import 'package:dab_api/src/infrastructure/database/tables/group_members_table.dart';
import 'package:dab_api/src/infrastructure/database/tables/groups_table.dart';
import 'package:dab_api/src/infrastructure/database/tables/provider_configs_table.dart';
import 'package:dab_api/src/infrastructure/database/tables/sessions_table.dart';
import 'package:dab_api/src/infrastructure/database/tables/system_settings_table.dart';
import 'package:dab_api/src/infrastructure/database/tables/user_identities_table.dart';
import 'package:dab_api/src/infrastructure/database/tables/users_table.dart';
import 'package:drift/drift.dart';
import 'package:drift_postgres/drift_postgres.dart';
import 'package:postgres/postgres.dart' hide Session;

part 'app_database.g.dart';

@DriftDatabase(
  tables: [
    UsersTable,
    ActivitiesTable,
    ActivityPhorgeTable,
    ActivityGithubCommitTable,
    ActivityJiraIssueTable,
    ActivitySlackMessageTable,
    ActivityTeamsMessageTable,
    SessionsTable,
    GroupsTable,
    GroupMembersTable,
    ProviderConfigsTable,
    UserIdentitiesTable,
    SystemSettingsTable,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase(super.e);

  @override
  int get schemaVersion => 15;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) async {
      await m.createAll();
    },
    onUpgrade: (m, from, to) async {
      if (from < 2) {
        await m.createTable(activityPhorgeTable);
      }
      if (from < 3) {
        await m.addColumn(usersTable, usersTable.avatarUrl);
        await m.createTable(groupsTable);
        await m.createTable(groupMembersTable);
      }
      if (from < 4) {
        await m.createTable(providerConfigsTable);
        await m.createTable(userIdentitiesTable);
      }
      if (from < 5) {
        // Older Drift schemas used BOOLEAN; Postgres driver maps flags as 0/1 integers.
        await m.database.customStatement(r'''
DO $$
BEGIN
  IF EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_schema = 'public'
      AND table_name = 'provider_configs'
      AND column_name = 'is_active'
      AND data_type = 'boolean'
  ) THEN
    ALTER TABLE provider_configs
      ALTER COLUMN is_active DROP DEFAULT,
      ALTER COLUMN is_active TYPE integer USING (CASE WHEN is_active THEN 1 ELSE 0 END),
      ALTER COLUMN is_active SET DEFAULT 1;
  END IF;
END $$;
''');
      }
      if (from < 6) {
        // Migrate all BIGINT timestamp columns (epoch ms) to TIMESTAMPTZ.
        // This resolves the error: "column 'created_at' is of type bigint but expression is of type timestamp with time zone"
        const tablesToMigrate = {
          'users': ['created_at', 'updated_at'],
          'activities': ['created_at'],
          'sessions': ['expires_at'],
          'user_identities': ['created_at', 'updated_at'],
          'provider_configs': ['updated_at'],
        };

        for (final entry in tablesToMigrate.entries) {
          final tableName = entry.key;
          final columns = entry.value;

          for (final column in columns) {
            await m.database.customStatement('''
DO \$\$
BEGIN
  IF EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_schema = 'public'
      AND table_name = '$tableName'
      AND column_name = '$column'
      AND data_type = 'bigint'
  ) THEN
    ALTER TABLE $tableName 
      ALTER COLUMN $column TYPE timestamptz USING to_timestamp($column / 1000.0);
  END IF;
END \$\$;
''');
          }
        }
      }
      if (from < 7) {
        await m.addColumn(providerConfigsTable, providerConfigsTable.settings);
      }
      if (from < 8) {
        await m.createTable(activityGithubCommitTable);
      }
      if (from < 9) {
        await m.database.customStatement(r'''
INSERT INTO user_identities (id, user_id, provider_id, external_id, status, created_at, updated_at)
SELECT
  users.id || '_phorge' AS id,
  users.id AS user_id,
  'phorge' AS provider_id,
  users.phorge_phid AS external_id,
  'linked' AS status,
  users.created_at AS created_at,
  NOW() AS updated_at
FROM users
WHERE users.phorge_phid IS NOT NULL
  AND users.phorge_phid <> ''
  AND NOT EXISTS (
    SELECT 1
    FROM user_identities ui
    WHERE ui.user_id = users.id
      AND ui.provider_id = 'phorge'
  );
''');
      }
      if (from < 10) {
        await m.addColumn(
          userIdentitiesTable,
          userIdentitiesTable.externalUsername,
        );
        await m.database.customStatement(r'''
UPDATE user_identities ui
SET external_username = users.phorge_username,
    updated_at = NOW()
FROM users
WHERE ui.user_id = users.id
  AND ui.provider_id = 'phorge'
  AND users.phorge_username IS NOT NULL
  AND users.phorge_username <> ''
  AND (ui.external_username IS NULL OR ui.external_username = '');
''');
      }
      if (from < 11) {
        await m.createTable(activitySlackMessageTable);
      }
      if (from < 12) {
        // slack-edge CDN returns 403 for mobile/Flutter clients loading provider icons.
        await m.database.customStatement(r'''
UPDATE provider_configs
SET icon_url = 'https://slack.com/favicon.ico',
    updated_at = NOW()
WHERE id = 'slack'
  AND icon_url LIKE '%slack-edge.com%';
''');
      }
      if (from < 13) {
        await m.createTable(activityJiraIssueTable);
      }
      if (from < 14) {
        await m.createTable(activityTeamsMessageTable);
      }
      if (from < 15) {
        await m.createTable(systemSettingsTable);
      }
    },
    beforeOpen: (details) async {
      final configCount = await select(providerConfigsTable).get();
      if (configCount.isEmpty) {
        await batch((batch) {
          batch.insertAll(providerConfigsTable, [
            ProviderConfigsTableCompanion.insert(
              id: 'phorge',
              name: 'Phorge',
              baseUrl: 'https://phorge.example.com',
              isActive: const Value(1),
              iconUrl: const Value('https://phorge.it/favicon.ico'),
              settings: const Value('{}'),
            ),
            ProviderConfigsTableCompanion.insert(
              id: 'linear',
              name: 'Linear',
              baseUrl: 'https://linear.app',
              isActive: const Value(1),
              iconUrl: const Value('https://linear.app/favicon.ico'),
              settings: const Value('{}'),
            ),
            ProviderConfigsTableCompanion.insert(
              id: 'jira',
              name: 'Jira',
              baseUrl: 'https://atlassian.net',
              isActive: const Value(1),
              iconUrl: const Value(
                'https://wac-cdn.atlassian.com/assets/img/favicons/atlassian/favicon.png',
              ),
              settings: const Value('{}'),
            ),
            ProviderConfigsTableCompanion.insert(
              id: 'teams',
              name: 'Microsoft Teams',
              baseUrl: 'https://teams.microsoft.com',
              isActive: const Value(1),
              iconUrl: const Value(
                'https://statics.teams.cdn.office.net/evergreen-assets/icons/favicon.ico',
              ),
              settings: const Value('{}'),
            ),
            ProviderConfigsTableCompanion.insert(
              id: 'slack',
              name: 'Slack',
              baseUrl: 'https://slack.com',
              isActive: const Value(1),
              iconUrl: const Value(
                'https://slack.com/favicon.ico',
              ),
              settings: const Value('{}'),
            ),
            ProviderConfigsTableCompanion.insert(
              id: 'discord',
              name: 'Discord',
              baseUrl: 'https://discord.com',
              isActive: const Value(1),
              iconUrl: const Value('https://discord.com/favicon.ico'),
              settings: const Value('{}'),
            ),
            ProviderConfigsTableCompanion.insert(
              id: 'github',
              name: 'GitHub',
              baseUrl: 'https://github.com',
              isActive: const Value(1),
              iconUrl: const Value(
                'https://github.githubassets.com/favicons/favicon.svg',
              ),
              settings: const Value('{}'),
            ),
            ProviderConfigsTableCompanion.insert(
              id: 'gitlab',
              name: 'GitLab',
              baseUrl: 'https://gitlab.com',
              isActive: const Value(1),
              iconUrl: const Value('https://gitlab.com/favicon.ico'),
              settings: const Value('{}'),
            ),
          ]);
        });
      }
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
