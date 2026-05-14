import 'package:dab_api/src/domain/dtos/phorge/phorge_revision/phorge_revision_activity_uuid.dart';
import 'package:dab_api/src/domain/dtos/phorge/phorge_revision/phorge_revision_fields.dart';
import 'package:dab_api/src/domain/entities/activity/activity.dart';
import 'package:dab_api/src/domain/entities/activity/activity_provider.dart';
import 'package:dab_api/src/domain/entities/user/user.dart';
import 'package:dart_mappable/dart_mappable.dart';

part 'phorge_revision_data.mapper.dart';

/// [ARCH: DOMAIN_DTO]
/// ROLE: One `differential.revision.search` datum — top-level matches Conduit (`id`, `phid`, `fields`).
/// CONTRACT: Decode with [PhorgeRevisionDataMapper.fromMap] after JSON decode; shape matches Conduit rows.
/// CONSTRAINTS: Mappable-generated decode only — no Infrastructure-side field lifting. Feed mapping via [OnPhorgeRevisionData.toActivities].
@MappableClass()
class PhorgeRevisionData with PhorgeRevisionDataMappable {
  final int id;

  /// The revision PHID (`PHID-DREV-…`).
  final String phid;

  final PhorgeRevisionFields fields;

  const PhorgeRevisionData({
    required this.id,
    required this.phid,
    required this.fields,
  });
}

/// [ARCH: DOMAIN]
/// ROLE: Revision DTO → code-review [`Activity`].
extension OnPhorgeRevisionData on PhorgeRevisionData {
  List<Activity> toActivities(List<User> users) {
    final f = fields;
    final author = users.firstWhere(
      (u) => u.phorgePhid == f.authorPHID,
      orElse: () => users.first,
    );
    final modified = DateTime.fromMillisecondsSinceEpoch(
      f.dateModified * 1000,
      isUtc: true,
    );

    return [
      Activity(
        id: phorgeRevisionActivityUuid('phorge-rev-$id'),
        userId: author.id,
        authorName:
            (author.phorgeUsername ?? '').trim().isNotEmpty
                ? author.phorgeUsername!.trim()
                : author.name,
        commentCount: 0,
        provider: PhorgeRevisionProvider(revisionId: phid),
        title: 'D$id: ${f.title}',
        content: 'Status: ${f.status.name}',
        url: '/D$id',
        createdAt: modified,
      ),
    ];
  }
}
