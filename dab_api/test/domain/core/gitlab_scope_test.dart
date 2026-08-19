import 'package:dab_api/src/domain/core/gitlab_scope.dart';
import 'package:test/test.dart';

void main() {
  test('unwraps Dart List.toString wrappers from Admin projects', () {
    expect(
      gitLabProjects({
        'projects': ['[[team-dhallz-io/gitlab.dhallz.io]]'],
      }),
      ['team-dhallz-io/gitlab.dhallz.io'],
    );
    expect(
      gitLabProjects({
        'projects': [
          ['team-dhallz-io/gitlab.dhallz.io'],
        ],
      }),
      ['team-dhallz-io/gitlab.dhallz.io'],
    );
    expect(
      normalizeGitLabProject('[team-dhallz-io/gitlab.dhallz.io]'),
      'team-dhallz-io/gitlab.dhallz.io',
    );
  });

  test('parses GitLab project URLs and numeric ids', () {
    expect(
      normalizeGitLabProject(
        'https://gitlab.com/team-dhallz-io/gitlab.dhallz.io/-/tree/develop',
      ),
      'team-dhallz-io/gitlab.dhallz.io',
    );
    expect(normalizeGitLabProject('123456'), '123456');
    expect(normalizeGitLabProject('not-a-project'), isNull);
  });
}
