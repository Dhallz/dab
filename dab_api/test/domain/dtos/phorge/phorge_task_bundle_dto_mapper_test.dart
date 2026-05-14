import 'package:dab_api/src/domain/dtos/phorge/phorge_task/phorge_task_bundle_dto.dart';
import 'package:dab_api/src/domain/dtos/phorge/phorge_task/phorge_task_dto.dart';
import 'package:dab_api/src/domain/dtos/phorge/phorge_task/phorge_task_wire_fields_dto.dart';
import 'package:dab_api/src/domain/dtos/phorge/phorge_transaction/phorge_transaction_dto.dart';
import 'package:test/test.dart';

void main() {
  test('PhorgeTaskBundleDtoMapper round-trips task and transactions', () {
    final task = const PhorgeTaskDto(
      id: 99,
      phid: 'PHID-TASK-x',
      fields: PhorgeTaskWireFieldsDto(title: 'Fix bug', uri: '/T99'),
    );
    final tx = PhorgeTransactionDto(
      id: 1,
      phid: 'PHID-TX-x',
      objectPHID: 'PHID-TASK-x',
      authorPHID: 'PHID-USER-x',
      type: 'comment',
      dateCreated: DateTime.utc(2026, 5, 10),
    );
    final original = PhorgeTaskBundleDto(
      task: task,
      transactions: [tx],
      sprintTag: 'DS2026-10',
    );

    final decoded = PhorgeTaskBundleDtoMapper.fromMap(original.toMap());

    expect(decoded, original);
    expect(decoded.sprintTag, 'DS2026-10');
    expect(decoded.task.id, 99);
    expect(decoded.transactions.single.id, 1);
  });
}
