import 'package:dab_api/src/domain/entities/activity/activity.dart';
import 'package:dab_api/src/domain/entities/activity/activity_provider.dart';
import 'package:dab_api/src/domain/entities/user/user.dart';
import 'package:dart_mappable/dart_mappable.dart';
import 'package:uuid/uuid.dart';

part 'phorge_revision_data.mapper.dart';

final _phorgeRevisionActivityUuid = const Uuid();

/// [ARCH: DOMAIN_DTO]
/// ROLE: Nested `fields` object from `differential.revision.search` rows.
/// CONTRACT: Shapes match Conduit (`authorPHID`, `title`, `uri`, `dateModified` in seconds, `status`).
@MappableClass()
class PhorgeRevisionFields with PhorgeRevisionFieldsMappable {
  final String authorPHID;
  final String title;
  final String uri;

  /// Epoch seconds (Conduit `fields.dateModified`; wire int).
  final int dateModified;

  final PhorgeRevisionStatusFields status;

  const PhorgeRevisionFields({
    required this.authorPHID,
    required this.title,
    required this.uri,
    required this.dateModified,
    required this.status,
  });
}

/// [ARCH: DOMAIN_DTO]
/// ROLE: Nested `fields.status` object (`name`; extra Conduit keys ignored on decode).
@MappableClass()
class PhorgeRevisionStatusFields with PhorgeRevisionStatusFieldsMappable {
  final String name;

  const PhorgeRevisionStatusFields({required this.name});
}

/// [ARCH: DOMAIN_DTO]
/// ROLE: One `differential.revision.search` datum — top-level matches Conduit (`id`, `phid`, `fields`).
/// CONTRACT: Prefer [fromConduit]; shape matches decoded Conduit rows (unknown keys skipped by mapper).
/// CONSTRAINTS: Mappable-generated decode only — no Infrastructure-side field lifting.
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

  /// Decodes one `revision.search` element after [`jsonDecode`].
  factory PhorgeRevisionData.fromConduit(Map<String, dynamic> raw) =>
      PhorgeRevisionDataMapper.ensureInitialized().decodeMap<PhorgeRevisionData>(
        raw,
      );
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
        id: _phorgeRevisionGenerateUuid('phorge-rev-$id'),
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

String _phorgeRevisionGenerateUuid(String source) {
  return _phorgeRevisionActivityUuid.v5(Namespace.url.value, source);
}
