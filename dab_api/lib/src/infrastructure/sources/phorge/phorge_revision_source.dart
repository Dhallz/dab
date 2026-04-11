import 'package:dab_api/src/domain/entities/user/user.dart';
import 'package:dab_api/src/infrastructure/dtos/phorge/phorge_revision_data.dart';
import 'package:dab_api/src/infrastructure/connectors/phorge/phorge_client.dart';
import 'package:dab_api/src/infrastructure/sources/i_activity_source.dart';

/// [ARCH: INFRASTRUCTURE_SOURCE]
/// ROLE: Low-level I/O for Phorge Differential Revisions (Code Reviews).
/// CONTRACT: Implements [IActivitySource] for [PhorgeRevisionData].
/// CONSTRAINTS: Must be READ-ONLY. Logic is restricted to API coordination and DTO mapping.
///
/// This source handles binary protocol communication with Phorge to retrieve 
/// Differential Revisions (D-numbers) within specific time bounds.
class PhorgeRevisionSource implements IActivitySource<PhorgeRevisionData> {
  final PhorgeClient _client;

  PhorgeRevisionSource(this._client);

  @override
  /// [ARCH: INFRASTRUCTURE_ENTRY]
  /// ROLE: Entry point for fetching Phorge Revision data.
  /// CONTRACT: Performs `differential.revision.search` with optional author filtering.
  Future<List<PhorgeRevisionData>> fetchRawData(
    List<User> users,
    DateTime start,
    DateTime end,
    bool authoredOnly,
  ) async {
    final userPhids = users.map((u) => u.phorgePhid!).toList();
    
    final result = await _client.call('differential.revision.search', {
      'constraints': {
        if (authoredOnly) 'authorPHIDs': userPhids,
        'modifiedStart': start.millisecondsSinceEpoch ~/ 1000,
        'modifiedEnd': end.millisecondsSinceEpoch ~/ 1000,
      },
    });

    final rawData = result['data'] as List<dynamic>?;
    if (rawData == null) return [];

    return rawData.map((e) => _mapToRevisionData(e as Map<String, dynamic>)).toList();
  }

  /// [ARCH: INFRASTRUCTURE_INTERNAL]
  /// ROLE: Low-level protocol-to-DTO transformer for Revisions.
  /// CONTRACT: Maps raw JSON from Conduit API into a typed [PhorgeRevisionData] object.
  PhorgeRevisionData _mapToRevisionData(Map<String, dynamic> json) {
    final fields = json['fields'] as Map<String, dynamic>? ?? {};
    final status = fields['status'] as Map<String, dynamic>? ?? {};
    
    return PhorgeRevisionData(
      id: int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      phid: json['phid']?.toString() ?? '',
      authorPHID: fields['authorPHID']?.toString() ?? '',
      title: fields['title'] as String? ?? 'Unknown',
      uri: fields['uri'] as String? ?? '',
      statusName: status['name'] as String? ?? 'Unknown',
      dateModified: DateTime.fromMillisecondsSinceEpoch(
        (int.tryParse(fields['dateModified']?.toString() ?? '0') ?? 0) * 1000,
        isUtc: true,
      ),
    );
  }
}
