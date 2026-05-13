import 'package:dab_api/src/domain/dtos/phorge/phorge_revision_data.dart';
import 'package:dab_api/src/domain/entities/user/user.dart';
import 'package:dab_api/src/domain/ports/i_activity_source.dart';
import 'package:dab_api/src/infrastructure/protocols/conduit/conduit_protocol.dart';

/// [ARCH: INFRASTRUCTURE_SOURCE]
/// ROLE: Low-level I/O for Phorge Differential Revisions (Code Reviews).
/// CONTRACT: Implements [IActivitySource] for [PhorgeRevisionData].
/// CONSTRAINTS: Must be READ-ONLY. Logic is restricted to API coordination and DTO mapping.
///
/// This source handles binary protocol communication with Phorge to retrieve
/// Differential Revisions (D-numbers) within specific time bounds.
class PhorgeRevisionSource implements IActivitySource<PhorgeRevisionData> {
  final ConduitProtocol _client;

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
    final userPhids = users
        .map((u) => u.phorgePhid?.trim())
        .whereType<String>()
        .where((phid) => phid.isNotEmpty)
        .toSet()
        .toList();
    if (authoredOnly && userPhids.isEmpty) {
      return [];
    }

    final result = await _client.call('differential.revision.search', {
      'constraints': {
        if (authoredOnly && userPhids.isNotEmpty) 'authorPHIDs': userPhids,
        'modifiedStart': start.millisecondsSinceEpoch ~/ 1000,
        'modifiedEnd': end.millisecondsSinceEpoch ~/ 1000,
      },
    });

    final rawData = result['data'] as List<dynamic>?;
    if (rawData == null) return [];

    return rawData
        .map((e) => PhorgeRevisionData.fromConduit(e as Map<String, dynamic>))
        .toList();
  }
}
