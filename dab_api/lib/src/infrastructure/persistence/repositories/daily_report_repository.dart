import 'package:drift/drift.dart';
import 'package:fpdart/fpdart.dart';
import 'package:uuid/uuid.dart';

import '../../../domain/contracts/repositories/abs_i_daily_report_repository.dart';
import '../../../domain/core/failures/failure.dart';
import '../../../domain/entities/user/daily_report.dart';
import '../../../domain/entities/user/daily_report_line.dart';
import '../../../domain/entities/user/daily_report_line_role.dart';
import '../postgres/app_database.dart';
import '../postgres/drift_row_mappers.dart';

/// [ARCH: INFRASTRUCTURE_REPOSITORY]
/// ROLE: Persists personal daily reports and their curated lines.
class DailyReportRepository implements AbsIDailyReportRepository {
  DailyReportRepository(this._db);

  final AppDatabase _db;
  static const _uuid = Uuid();

  @override
  Future<Either<Failure, DailyReport?>> findByUserAndDate({
    required String userId,
    required String date,
  }) async {
    try {
      final header =
          await (_db.select(_db.dailyReportsTable)..where(
                (t) => t.userId.equals(userId) & t.reportDate.equals(date),
              ))
              .getSingleOrNull();
      if (header == null) return const Right(null);
      final lineRows = await (_db.select(
        _db.dailyReportLinesTable,
      )..where((t) => t.reportId.equals(header.id))).get();
      return Right(_mapReport(header, lineRows));
    } catch (e) {
      return Left(DatabaseFailure('Failed to load daily report: $e'));
    }
  }

  @override
  Future<Either<Failure, List<String>>> listDatesByUser({
    required String userId,
  }) async {
    try {
      final rows =
          await (_db.select(_db.dailyReportsTable)
                ..where((t) => t.userId.equals(userId))
                ..orderBy([
                  (t) => OrderingTerm(
                    expression: t.reportDate,
                    mode: OrderingMode.desc,
                  ),
                ]))
              .get();
      return Right([for (final row in rows) row.reportDate]);
    } catch (e) {
      return Left(DatabaseFailure('Failed to list daily reports: $e'));
    }
  }

  @override
  Future<Either<Failure, DailyReport>> save(DailyReport report) async {
    try {
      final now = DateTime.now().toUtc();
      await _db.transaction(() async {
        await _db
            .into(_db.dailyReportsTable)
            .insert(
              DailyReportsTableCompanion.insert(
                id: report.id,
                userId: report.userId,
                reportDate: report.date,
                includeFollowing: Value(report.includeFollowing ? 1 : 0),
                createdAt: Value(now.toPgDateTime()),
                updatedAt: Value(now.toPgDateTime()),
              ),
              onConflict: DoUpdate(
                (_) => DailyReportsTableCompanion(
                  includeFollowing: Value(report.includeFollowing ? 1 : 0),
                  updatedAt: Value(now.toPgDateTime()),
                ),
                target: [
                  _db.dailyReportsTable.userId,
                  _db.dailyReportsTable.reportDate,
                ],
              ),
            );

        final savedHeader =
            await (_db.select(_db.dailyReportsTable)..where(
                  (t) =>
                      t.userId.equals(report.userId) &
                      t.reportDate.equals(report.date),
                ))
                .getSingle();

        await (_db.delete(
          _db.dailyReportLinesTable,
        )..where((t) => t.reportId.equals(savedHeader.id))).go();

        if (report.lines.isEmpty) return;

        await _db.batch((batch) {
          batch.insertAll(_db.dailyReportLinesTable, [
            for (final line in report.lines)
              DailyReportLinesTableCompanion.insert(
                id: _uuid.v5(
                  Namespace.url.value,
                  'day-report-line|${savedHeader.id}|${line.subjectKey}',
                ),
                reportId: savedHeader.id,
                subjectKey: line.subjectKey,
                included: Value(line.included ? 1 : 0),
                note: Value(line.note),
                role: Value(line.role.wireName),
                title: Value(line.title),
                url: Value(line.url),
                occurredAt: Value(line.occurredAt?.toUtc().toPgDateTime()),
                providerId: Value(line.providerId),
              ),
          ]);
        });
      });

      final reloaded = await findByUserAndDate(
        userId: report.userId,
        date: report.date,
      );
      return await reloaded.fold(
        (failure) => Left(failure),
        (saved) => Right(saved ?? report.copyWith(updatedAt: now)),
      );
    } catch (e) {
      return Left(DatabaseFailure('Failed to save daily report: $e'));
    }
  }

  DailyReport _mapReport(
    DailyReportsTableData header,
    List<DailyReportLinesTableData> lineRows,
  ) {
    final lines = lineRows.map(_mapLine).toList()
      ..sort((a, b) {
        final aAt = a.occurredAt;
        final bAt = b.occurredAt;
        if (aAt == null && bAt == null) return 0;
        if (aAt == null) return 1;
        if (bAt == null) return -1;
        return bAt.compareTo(aAt);
      });
    return DailyReport(
      id: header.id,
      userId: header.userId,
      date: header.reportDate,
      includeFollowing: header.includeFollowing == 1,
      lines: lines,
      updatedAt: header.updatedAt?.dateTime,
    );
  }

  DailyReportLine _mapLine(DailyReportLinesTableData row) {
    return DailyReportLine(
      subjectKey: row.subjectKey,
      included: row.included == 1,
      note: row.note,
      role: dailyReportLineRoleFromWire(row.role),
      title: row.title,
      url: row.url,
      occurredAt: row.occurredAt?.dateTime,
      providerId: row.providerId,
    );
  }
}
