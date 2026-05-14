import 'package:dab_api/src/domain/dtos/phorge/phorge_task/phorge_task_dto.dart';
import 'package:test/test.dart';

void main() {
  group('Phorge task headline (Conduit maniphest)', () {
    test('uses fields.name when title is absent (ApplicationSearch)', () {
      final dto = PhorgeTaskDtoMapper.fromMap({
        'id': 10,
        'phid': 'PHID-TASK-10',
        'fields': {
          'name': 'Normalize cache keys',
          'uri': '/T10',
        },
      });

      expect(dto.name, 'Normalize cache keys');
    });

    test('prefers fields.title when both title and name are present', () {
      final dto = PhorgeTaskDtoMapper.fromMap({
        'id': 11,
        'phid': 'PHID-TASK-11',
        'fields': {
          'title': 'Uses title slot',
          'name': 'Ignores duplicate name',
          'uri': '/T11',
        },
      });

      expect(dto.name, 'Uses title slot');
    });

    test('still falls back to Unknown when neither headline is sent', () {
      final dto = PhorgeTaskDtoMapper.fromMap({
        'id': 12,
        'phid': 'PHID-TASK-12',
        'fields': {'uri': '/T12'},
      });

      expect(dto.name, 'Unknown');
    });
  });
}
