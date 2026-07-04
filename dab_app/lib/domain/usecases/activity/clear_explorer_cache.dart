import 'package:fpdart/fpdart.dart';

import '../../core/failures.dart';
import '../../entities/activity/explorer_cache_clear_request.dart';
import '../../repositories/abs_i_activity_repository.dart';

/// [ARCH: APPLICATION_USECASE]
/// ROLE: Clears Explorer ObjectBox activity and coverage rows.
/// CONTRACT: Without [request], removes the entire local Explorer cache.
/// With [request], removes only matching provider rows in the org-calendar date window.
class ClearExplorerCache {
  final IActivityRepository _repository;

  ClearExplorerCache(this._repository);

  Future<Either<AppFailure, ExplorerCacheClearResult>> execute({
    ExplorerCacheClearRequest? request,
  }) {
    if (request != null) {
      final normalizedProviders = request.providerIds
          .map((id) => id.trim().toLowerCase())
          .where((id) => id.isNotEmpty)
          .toSet();
      if (normalizedProviders.isEmpty) {
        return Future.value(
          left(
            const ValidationFailure(
              errors: {'providers': ['At least one provider is required.']},
              message:
                  'Select at least one provider to clear Explorer cache.',
            ),
          ),
        );
      }

      final start = DateTime(
        request.startDate.year,
        request.startDate.month,
        request.startDate.day,
      );
      final end = DateTime(
        request.endDate.year,
        request.endDate.month,
        request.endDate.day,
      );
      if (start.isAfter(end)) {
        return Future.value(
          left(
            const ValidationFailure(
              errors: {'dateRange': ['Start must be on or before end.']},
              message: 'Start date must be on or before end date.',
            ),
          ),
        );
      }

      return _repository.clearExplorerCache(
        request: ExplorerCacheClearRequest(
          startDate: start,
          endDate: end,
          providerIds: normalizedProviders,
          orgTimezoneId: request.orgTimezoneId,
        ),
      );
    }

    return _repository.clearExplorerCache();
  }
}
