import 'package:fpdart/fpdart.dart';

import '../../../domain/core/failures/failure.dart';
import '../../../domain/entities/user/user_identity_status.dart';
import 'get_all_identities.dart';

/// [ARCH: APPLICATION_USECASE]
/// ROLE: Counts identity rows that still need admin resolution (pending or failed).
/// CONTRACT: Uses the same merged identity list as [GetAllIdentities].
class CountUnresolvedIdentities {
  final GetAllIdentities _getAllIdentities;

  CountUnresolvedIdentities(this._getAllIdentities);

  Future<Either<DatabaseFailure, int>> execute() async {
    final result = await _getAllIdentities.execute();
    return result.map(
      (list) => list.where((i) => i.status != UserIdentityStatus.linked).length,
    );
  }
}
