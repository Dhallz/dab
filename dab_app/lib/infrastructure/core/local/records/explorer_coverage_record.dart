import 'package:objectbox/objectbox.dart';

@Entity()
class ExplorerCoverageRecord {
  @Id()
  int id = 0;

  @Unique(onConflict: ConflictStrategy.replace)
  final String coverageKey;

  @Index()
  final String dayKey;

  @Index()
  final int dayEpochMs;

  @Index()
  final String userId;

  @Index()
  final String providerKey;

  final int lastFetchedAtEpochMs;

  ExplorerCoverageRecord({
    required this.coverageKey,
    required this.dayKey,
    required this.dayEpochMs,
    required this.userId,
    required this.providerKey,
    required this.lastFetchedAtEpochMs,
  });
}
