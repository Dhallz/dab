import 'package:dab_api/src/domain/dtos/phorge/phorge_project/phorge_project_dto.dart';
import 'package:test/test.dart';

void main() {
  test('PhorgeProjectDtoMapper decodes full project.search datum', () {
    final raw = <String, dynamic>{
      'id': 42,
      'phid': 'PHID-PROJ-test',
      'fields': <String, dynamic>{
        'name': 'Sprint Backend',
        'slug': 'sprint-backend',
        'subtype': 'default',
        'milestone': 3,
        'parent': <String, dynamic>{
          'id': 1,
          'name': 'Root',
          'phid': 'PHID-PROJ-parent',
        },
        'depth': 2,
        'icon': <String, dynamic>{'key': 'bugs', 'name': 'Bugs'},
        'color': 'blue',
        'spacePHID': 'PHID-SPC-x',
        'dateCreated': 1000,
        'dateModified': 2000,
        'policy': <String, dynamic>{
          'view': {'default': 'all'},
        },
        'description': '## Notes\n',
      },
      'attachments': <String, dynamic>{
        'members': <String, dynamic>{
          'memberPHIDs': <String>['PHID-USER-1'],
        },
      },
    };

    final dto = PhorgeProjectDtoMapper.fromMap(raw);

    expect(dto.id, 42);
    expect(dto.phid, 'PHID-PROJ-test');
    expect(dto.fields.name, 'Sprint Backend');
    expect(dto.fields.slug, 'sprint-backend');
    expect(dto.fields.subtype, 'default');
    expect(dto.fields.milestone, 3);
    expect(dto.fields.parent?['phid'], 'PHID-PROJ-parent');
    expect(dto.fields.depth, 2);
    expect(dto.color, 'blue');
    expect(dto.icon, 'bugs');
    expect(dto.fields.spacePHID, 'PHID-SPC-x');
    expect(dto.fields.dateCreated, 1000);
    expect(dto.fields.dateModified, 2000);
    expect(dto.fields.policy?['view'], isA<Map>());
    expect(dto.fields.description, '## Notes\n');
    expect(
      dto.attachments?['members'],
      <String, dynamic>{'memberPHIDs': <String>['PHID-USER-1']},
    );
  });

  test('PhorgeProjectDtoMapper decodes sparse fields without placeholders', () {
    final raw = <String, dynamic>{
      'id': 1,
      'phid': 'PHID-PROJ-empty',
      'fields': <String, dynamic>{
        // name absent on wire ⇒ null [PhorgeProjectWireFieldsDto.name]
      },
    };

    final dto = PhorgeProjectDtoMapper.fromMap(raw);

    expect(dto.fields.name, isNull);
    expect(dto.fields.depth, isNull);
    expect(dto.name, 'Unknown');
    expect(dto.attachments, isNull);
  });
}
