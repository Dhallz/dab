import 'package:dab_api/src/domain/entities/activity.dart';
import 'package:dab_api/src/domain/entities/user.dart';

/// [ARCH: DOMAIN]
/// ROLE: Business Logic definer for external platform interpretation.
/// CONTRACT: Transforms raw DTO data [T] into unified Domain [Activity] entities.
/// CONSTRAINTS: Must be a pure function. Must reside in the Domain layer.
///
/// This interface defines the "Logic of Meaning." A Mapper knows that a status 
/// like "Resolved" in Phorge means the task is internally "Done."
abstract interface class IActivityMapper<T> {
  /// The platform identifier (e.g. "phorge", "github").
  String get providerName;

  /// Transforms the raw technical DTO [data] into high-level Domain Activities.
  /// 
  /// The [users] list is provided to resolve external PHIDs/IDs to internal DAB Users.
  List<Activity> mapToActivities(T data, List<User> users);
}
