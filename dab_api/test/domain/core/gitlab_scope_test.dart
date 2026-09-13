import 'package:dab_api/src/domain/core/gitlab_scope.dart';
import 'package:test/test.dart';

void main() {
  test('unwraps Dart List.toString wrappers from Admin projects', () {
    expect(
      ({
        'projects': ['[[team-dhallz-io/gitlab.dhallz.io]]'],
      }).gitLabProjects(),
      ['team-dhallz-io/gitlab.dhallz.io'],
    );
    expect(
      ({
        'projects': [
          ['team-dhallz-io/gitlab.dhallz.io'],
        ],
      }).gitLabProjects(),
      ['team-dhallz-io/gitlab.dhallz.io'],
    );
    expect(
      ('[team-dhallz-io/gitlab.dhallz.io]').normalizeGitLabProject(),
      'team-dhallz-io/gitlab.dhallz.io',
    );
  });

  test('parses GitLab project URLs and numeric ids', () {
    expect(
      ('https://gitlab.com/team-dhallz-io/gitlab.dhallz.io/-/tree/develop').normalizeGitLabProject(),
      'team-dhallz-io/gitlab.dhallz.io',
    );
    expect(('123456').normalizeGitLabProject(), '123456');
    expect(('not-a-project').normalizeGitLabProject(), isNull);
  });
}
