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

  /// Epoch seconds (Phorge `fields.dateModified`).
  final int dateModified;

  final PhorgeRevisionStatusFields status;

  const PhorgeRevisionFields({
    required this.authorPHID,
    required this.title,
    required this.uri,
    required this.dateModified,
    required this.status,
  });

  factory PhorgeRevisionFields.fromConduit(Map<String, dynamic> raw) {
    final statusRaw = raw['status'];
    return PhorgeRevisionFields(
      authorPHID: raw['authorPHID']?.toString() ?? '',
      title: raw['title'] as String? ?? 'Unknown',
      uri: raw['uri'] as String? ?? '',
      dateModified:
          int.tryParse(raw['dateModified']?.toString() ?? '0') ?? 0,
      status: switch (statusRaw) {
        final Map<String, dynamic> m =>
          PhorgeRevisionStatusFields.fromConduit(m),
        final String s =>
          PhorgeRevisionStatusFields(name: s),
        _ =>
          const PhorgeRevisionStatusFields(name: 'Unknown'),
      },
    );
  }
}

/// [ARCH: DOMAIN_DTO]
/// ROLE: Status sub-map under `fields.status` (`name`, plus optional conduit keys ignored here).
@MappableClass()
class PhorgeRevisionStatusFields with PhorgeRevisionStatusFieldsMappable {
  final String name;

  const PhorgeRevisionStatusFields({required this.name});

  factory PhorgeRevisionStatusFields.fromConduit(Map<String, dynamic> raw) {
    return PhorgeRevisionStatusFields(
      name: raw['name'] as String? ?? 'Unknown',
    );
  }
}

/// [ARCH: DOMAIN_DTO]
/// ROLE: One `differential.revision.search` datum — top-level matches Conduit (`id`, `phid`, `fields`).
/// CONTRACT: Use [fromConduit] after JSON decode only; mapped to [`Activity`] via [OnPhorgeRevisionData.toActivities].
/// CONSTRAINTS: Mappable for persistence; parsing stays in domain factories, not Infrastructure.
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

  factory PhorgeRevisionData.fromConduit(Map<String, dynamic> raw) {
    final fieldsRaw = raw['fields'] as Map<String, dynamic>? ?? {};
    return PhorgeRevisionData(
      id: int.tryParse(raw['id']?.toString() ?? '0') ?? 0,
      phid: raw['phid']?.toString() ?? '',
      fields: PhorgeRevisionFields.fromConduit(fieldsRaw),
    );
  }
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
