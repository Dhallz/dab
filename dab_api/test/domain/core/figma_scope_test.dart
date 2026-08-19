import 'package:dab_api/src/domain/core/figma_scope.dart';
import 'package:test/test.dart';

void main() {
  test('parses file keys and treats empty as no filter', () {
    expect(parseFigmaFileKeys('Abc12345\nOther_key-1'), [
      'Abc12345',
      'Other_key-1',
    ]);
    expect(figmaFileKeyAllowed('Abc12345', const []), isTrue);
    expect(figmaFileKeyAllowed('Abc12345', ['Abc12345']), isTrue);
    expect(figmaFileKeyAllowed('nope', ['Abc12345']), isFalse);
  });

  test('extracts file keys from Figma design and file URLs', () {
    expect(
      extractFigmaFileKey(
        'https://www.figma.com/design/Abc12345Key/Onboarding?node-id=0-1',
      ),
      'Abc12345Key',
    );
    expect(
      extractFigmaFileKey('https://www.figma.com/file/Other_key-1/Drafts'),
      'Other_key-1',
    );
    expect(extractFigmaFileKey('Abc12345Key'), 'Abc12345Key');
    expect(
      parseFigmaFileKeys(
        'https://www.figma.com/design/Abc12345Key/Onboarding\nOther_key-1',
      ),
      ['Abc12345Key', 'Other_key-1'],
    );
    expect(
      extractFigmaFileKey(
        'https://www.figma.com/files/team/948500929586421302/project/1',
      ),
      isNull,
    );
  });

  test('team allow-list skips unknown ids but allows missing team_id', () {
    expect(parseFigmaTeamIds('1234567, 8901234'), ['1234567', '8901234']);
    expect(figmaTeamIdAllowed(null, ['1234567']), isTrue);
    expect(figmaTeamIdAllowed('1234567', ['1234567']), isTrue);
    expect(figmaTeamIdAllowed('0000000', ['1234567']), isFalse);
  });

  test('builds the public file URL', () {
    expect(figmaFileUrl('Abc123File'), 'https://www.figma.com/file/Abc123File');
  });

  test('reads nested file meta and titles [folder_name] name', () {
    final fields = figmaFileMetaFields({
      'file': {
        'name': 'DAB',
        'folder_name': 'dajo. Plugin',
        'last_touched_at': '2026-02-27T20:41:46.360Z',
      },
    });
    expect(fields['name'], 'DAB');
    expect(fields['folder_name'], 'dajo. Plugin');
    expect(
      figmaFileTitle(
        name: 'DAB',
        folderName: 'dajo. Plugin',
        fileKey: 'dACiHlCd2hD4q1az9UJPpW',
      ),
      '[dajo. Plugin] DAB',
    );
    expect(figmaFileTitle(name: 'Onboarding', fileKey: 'Abc123File'), 'Onboarding');
    expect(figmaFileTitle(fileKey: 'Abc123File'), 'Abc123File');
  });

  test('sends PAT and OAuth on separate Figma auth headers', () {
    expect(figmaAuthHeaders('figd_pat-token')['X-Figma-Token'], 'figd_pat-token');
    expect(figmaAuthHeaders('figd_pat-token').containsKey('Authorization'), isFalse);
    expect(
      figmaAuthHeaders('oauth-access')['Authorization'],
      'Bearer oauth-access',
    );
    expect(figmaAuthHeaders('oauth-access').containsKey('X-Figma-Token'), isFalse);
  });

  test('figmaAuthorLabel skips numeric user ids', () {
    expect(
      figmaAuthorLabel(
        handle: '948500924847399940',
        name: 'dhallz',
        authorId: '948500924847399940',
      ),
      'dhallz',
    );
    expect(
      figmaAuthorLabelFromUser({
        'id': '948500924847399940',
        'handle': '948500924847399940',
        'name': 'Ada',
      }),
      'Ada',
    );
  });
}
