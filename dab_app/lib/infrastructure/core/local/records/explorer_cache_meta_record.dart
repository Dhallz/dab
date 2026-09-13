import 'package:objectbox/objectbox.dart';

@Entity()
class ExplorerCacheMetaRecord {
  @Id()
  int id = 0;

  final int cacheSchemaVersion;
  final int? lastMigrationAtEpochMs;

  ExplorerCacheMetaRecord({
    this.id = 0,
    required this.cacheSchemaVersion,
    this.lastMigrationAtEpochMs,
  });
}
