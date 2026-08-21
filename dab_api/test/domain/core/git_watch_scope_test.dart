import 'package:dab_api/src/domain/core/git_watch_scope.dart';
import 'package:test/test.dart';

void main() {
  const instance = ['acme/api', 'acme/app'];

  test('missing watchedRepos inherits the instance allow-list', () {
    expect(
      (const {}).watchesGitRef(repo: 'acme/api', branch: 'main', instanceRepos: instance),
      isTrue,
    );
  });

  test('empty watchedRepos means no git inbox', () {
    expect(
      (const {'watchedRepos': <String>[]}).watchesGitRef(repo: 'acme/api', branch: 'main', instanceRepos: instance),
      isFalse,
    );
  });

  test(
    'explicit repo watch requires a matching branch when branches are set',
    () {
      expect(
        (const {
            'watchedRepos': ['acme/api'],
            'watchedBranches': ['develop'],
          }).watchesGitRef(repo: 'acme/api', branch: 'main', instanceRepos: instance),
        isFalse,
      );
      expect(
        (const {
            'watchedRepos': ['acme/api'],
            'watchedBranches': ['develop'],
          }).watchesGitRef(repo: 'acme/api', branch: 'develop', instanceRepos: instance),
        isTrue,
      );
    },
  );

  test('gitInboxWatchers excludes the committer', () {
    expect(
      ({
          'u-author': const {
            'watchedRepos': ['acme/api'],
          },
          'u-watcher': const {
            'watchedRepos': ['acme/api'],
          },
        }).gitInboxWatchers(repo: 'acme/api', branch: 'main', instanceRepos: instance, senderUserId: 'u-author'),
      {'u-watcher'},
    );
  });

  test('Explorer poll refs add watched branches onto the host default', () {
    expect(
      ({
          'u-1': const {
            'watchedRepos': ['acme/api'],
            'watchedBranches': ['feature/ui_rework'],
          },
        }).gitExplorerPollRefs(repo: 'acme/api', instanceRepos: instance),
      [null, 'feature/ui_rework'],
    );
  });

  test('Explorer poll refs include the instance branch and watched names', () {
    expect(
      ({
          'u-1': const {
            'watchedRepos': ['acme/api'],
            'watchedBranches': ['feature/ui_rework', 'main'],
          },
        }).gitExplorerPollRefs(repo: 'acme/api', instanceRepos: instance, configuredBranch: 'main'),
      ['main', 'feature/ui_rework'],
    );
  });

  test(
    'Explorer poll refs ignore branches for repos the user does not watch',
    () {
      expect(
        ({
            'u-1': const {
              'watchedRepos': ['acme/app'],
              'watchedBranches': ['feature/ui_rework'],
            },
          }).gitExplorerPollRefs(repo: 'acme/api', instanceRepos: instance),
        [null],
      );
    },
  );
}
