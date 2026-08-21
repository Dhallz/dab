import 'package:dab_api/src/domain/core/figma_scope.dart';
import 'package:test/test.dart';

void main() {
  test('parses file keys and treats empty as no filter', () {
    expect(('Abc12345\nOther_key-1' as Object?).parseFigmaFileKeys(), [
      'Abc12345',
      'Other_key-1',
    ]);
    expect(('Abc12345').figmaFileKeyAllowed(const []), isTrue);
    expect(('Abc12345').figmaFileKeyAllowed(['Abc12345']), isTrue);
    expect(('nope').figmaFileKeyAllowed(['Abc12345']), isFalse);
  });

  test('extracts file keys from Figma design and file URLs', () {
    expect(
      ('https://www.figma.com/design/Abc12345Key/Onboarding?node-id=0-1').extractFigmaFileKey(),
      'Abc12345Key',
    );
    expect(
      ('https://www.figma.com/file/Other_key-1/Drafts').extractFigmaFileKey(),
      'Other_key-1',
    );
    expect(('Abc12345Key').extractFigmaFileKey(), 'Abc12345Key');
    expect(
      ('https://www.figma.com/design/Abc12345Key/Onboarding\nOther_key-1' as Object?).parseFigmaFileKeys(),
      ['Abc12345Key', 'Other_key-1'],
    );
    expect(
      ('https://www.figma.com/files/team/948500929586421302/project/1').extractFigmaFileKey(),
      isNull,
    );
  });

  test('team allow-list skips unknown ids but allows missing team_id', () {
    expect(('1234567, 8901234' as Object?).parseFigmaTeamIds(), ['1234567', '8901234']);
    expect(null.figmaTeamIdAllowed(['1234567']), isTrue);
    expect(('1234567').figmaTeamIdAllowed(['1234567']), isTrue);
    expect(('0000000').figmaTeamIdAllowed(['1234567']), isFalse);
  });

  test('builds the public file URL', () {
    expect(('Abc123File').figmaFileUrl(), 'https://www.figma.com/file/Abc123File');
  });

  test('reads nested file meta and titles [folder_name] name', () {
    final fields = ({
      'file': {
        'name': 'DAB',
        'folder_name': 'dajo. Plugin',
        'last_touched_at': '2026-02-27T20:41:46.360Z',
      },
    }).figmaFileMetaFields();
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
    expect(('figd_pat-token').figmaAuthHeaders()['X-Figma-Token'], 'figd_pat-token');
    expect(('figd_pat-token').figmaAuthHeaders().containsKey('Authorization'), isFalse);
    expect(
      ('oauth-access').figmaAuthHeaders()['Authorization'],
      'Bearer oauth-access',
    );
    expect(('oauth-access').figmaAuthHeaders().containsKey('X-Figma-Token'), isFalse);
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
      ({
        'id': '948500924847399940',
        'handle': '948500924847399940',
        'name': 'Ada',
      } as Object?).figmaAuthorLabelFromUser(),
      'Ada',
    );
  });
}
