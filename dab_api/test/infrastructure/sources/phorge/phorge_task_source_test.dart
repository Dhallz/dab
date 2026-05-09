import 'package:dab_api/src/domain/services/phorge_sprint_service.dart';
import 'package:dab_api/src/infrastructure/protocols/conduit/conduit_protocol.dart';
import 'package:dab_api/src/infrastructure/sources/phorge/phorge_task_source.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import '../../../test_factories.dart';

class _MockConduitProtocol extends Mock implements ConduitProtocol {}

class _MockSprintService extends Mock implements PhorgeSprintService {}

void main() {
  late _MockConduitProtocol client;
  late _MockSprintService sprintService;
  late PhorgeTaskSource source;

  setUp(() {
    client = _MockConduitProtocol();
    sprintService = _MockSprintService();
    source = PhorgeTaskSource(client, sprintService);
  });

  test('paginates authored transaction search for older date ranges', () async {
    final user = TestData.user(
      id: 'u-1',
      phorgeUsername: 'alice',
    ).copyWith(phorgePhid: 'PHID-USER-ALICE');
    final start = DateTime.utc(2026, 2, 1);
    final end = DateTime.utc(2026, 2, 28, 23, 59, 59);

    when(
      () => sprintService.getCurrentSprintTag(any()),
    ).thenReturn('DS2026-05');

    when(() => client.call('transaction.search', any())).thenAnswer((
      invocation,
    ) async {
      final params = invocation.positionalArguments[1] as Map<String, dynamic>;
      final after = params['after']?.toString();

      if (after == null) {
        return {
          'data': [
            _txRow(
              id: 100,
              objectPhid: 'PHID-TASK-RECENT',
              authorPhid: 'PHID-USER-ALICE',
              createdAt: DateTime.utc(2026, 2, 27),
            ),
          ],
          'cursor': {'after': 'cursor-2'},
        };
      }

      if (after == 'cursor-2') {
        return {
          'data': [
            _txRow(
              id: 99,
              objectPhid: 'PHID-TASK-OLDER',
              authorPhid: 'PHID-USER-ALICE',
              createdAt: DateTime.utc(2026, 2, 2),
            ),
            _txRow(
              id: 98,
              objectPhid: 'PHID-TASK-TOO-OLD',
              authorPhid: 'PHID-USER-ALICE',
              createdAt: DateTime.utc(2026, 1, 20),
            ),
          ],
          'cursor': {'after': 'cursor-3'},
        };
      }

      fail('Unexpected pagination cursor: $after');
    });

    when(() => client.call('maniphest.search', any())).thenAnswer((
      invocation,
    ) async {
      final params = invocation.positionalArguments[1] as Map<String, dynamic>;
      final phids =
          (params['constraints'] as Map<String, dynamic>)['phids'] as List;

      expect(phids, containsAll(['PHID-TASK-RECENT', 'PHID-TASK-OLDER']));
      expect(phids, isNot(contains('PHID-TASK-TOO-OLD')));

      return {
        'data': [
          _taskRow('PHID-TASK-RECENT', 1201),
          _taskRow('PHID-TASK-OLDER', 1202),
        ],
      };
    });

    final bundles = await source.fetchRawData([user], start, end, true);

    expect(bundles, hasLength(2));
    final allTxIds = bundles
        .expand((bundle) => bundle.transactions)
        .map((tx) => tx.id);
    expect(allTxIds, containsAll([100, 99]));
    expect(allTxIds, isNot(contains(98)));

    verify(() => client.call('transaction.search', any())).called(2);
  });
}

Map<String, dynamic> _txRow({
  required int id,
  required String objectPhid,
  required String authorPhid,
  required DateTime createdAt,
}) {
  return {
    'id': id,
    'phid': 'PHID-XACT-$id',
    'objectPHID': objectPhid,
    'authorPHID': authorPhid,
    'type': 'comment',
    'oldValue': null,
    'newValue': null,
    'comments': [
      {
        'content': {'raw': 'comment $id'},
      },
    ],
    'dateCreated': createdAt.millisecondsSinceEpoch ~/ 1000,
  };
}

Map<String, dynamic> _taskRow(String phid, int id) {
  return {
    'id': id,
    'phid': phid,
    'fields': {
      'name': 'Task $id',
      'uri': 'https://phorge.example.com/T$id',
      'ownerPHID': 'PHID-USER-ALICE',
      'dateModified': DateTime.utc(2026, 2, 10).millisecondsSinceEpoch ~/ 1000,
    },
    'attachments': {
      'projects': {'projectPHIDs': []},
    },
  };
}
