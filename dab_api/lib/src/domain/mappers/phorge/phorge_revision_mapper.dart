import 'package:dab_api/src/domain/entities/activity.dart';
import 'package:dab_api/src/domain/entities/activity_provider.dart';
import 'package:dab_api/src/domain/entities/user.dart';
import 'package:dab_api/src/domain/mappers/i_activity_mapper.dart';
import 'package:dab_api/src/infrastructure/dtos/phorge/phorge_revision_data.dart';
import 'package:uuid/uuid.dart';

/// [ARCH: DOMAIN_MAPPER]
/// ROLE: Business Logic Transformer for Phorge Code Reviews (Revisions).
/// CONTRACT: Implements [IActivityMapper] for [PhorgeRevisionData].
/// CONSTRAINTS: Pure Logic (No I/O). Maps technical revision states to DAB Activities.
///
/// This mapper interprets technical code review data (Revisions) as a human-readable 
/// activity in the DAB feed.
class PhorgeRevisionMapper implements IActivityMapper<PhorgeRevisionData> {
  final _uuid = const Uuid();

  @override
  String get providerName => 'phorge';

  @override
  /// [ARCH: DOMAIN_ENTRY]
  /// ROLE: Entry point for Revision-to-Activity transformation.
  /// CONTRACT: Resolves the author from the provided user list and returns a singleton list.
  List<Activity> mapToActivities(PhorgeRevisionData data, List<User> users) {
    // Resolve author
    final author = users.firstWhere(
      (u) => u.phorgePhid == data.authorPHID,
      orElse: () => users.first,
    );

    return [
      Activity(
        id: _generateUuid('phorge-rev-${data.id}'),
        userId: author.id,
        authorName: author.name,
        commentCount: 0,
        provider: PhorgeRevisionProvider(revisionId: data.phid),
        title: 'D${data.id}: ${data.title}',
        content: 'Status: ${data.statusName}',
        url: '/D${data.id}',
        createdAt: data.dateModified,
      )
    ];
  }

  String _generateUuid(String source) {
    return _uuid.v5(Namespace.url.value, source);
  }
}
