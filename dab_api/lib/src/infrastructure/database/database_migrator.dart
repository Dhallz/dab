import 'dart:io';

import 'package:path/path.dart' as p;

import 'database_client.dart';

class DatabaseMigrator {
  static Future<void> runMigrations() async {
    final pool = DatabaseClient().pool;

    await pool.execute('''
      CREATE TABLE IF NOT EXISTS _migrations (
        id SERIAL PRIMARY KEY,
        name TEXT NOT NULL UNIQUE,
        applied_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
      )
    ''');

    final migrationsDir = Directory('migrations');
    if (!await migrationsDir.exists()) {
      await migrationsDir.create(recursive: true);
      return;
    }

    final files = await migrationsDir
        .list()
        .where((f) => f.path.endsWith('.sql'))
        .toList();
    files.sort((a, b) => a.path.compareTo(b.path));

    for (final file in files) {
      final name = p.basename(
        file.path,
      ); // Using p.basename as per existing import

      await pool.withConnection((conn) async {
        final result = await conn.execute(
          'SELECT 1 FROM _migrations WHERE name = @name',
          parameters: {'name': name},
        );

        if (result.isEmpty) {
          print('Applying migration: $name');
          final sql = await (file as File).readAsString();
          await conn.execute(sql);
          await conn.execute(
            'INSERT INTO _migrations (name) VALUES (@name)',
            parameters: {'name': name},
          );
        }
      });
    }
  }
}
