import 'package:dab_api/src/domain/core/git_watch_scope.dart';
import 'package:test/test.dart';

void main() {
  const instance = ['acme/api', 'acme/app'];

  test('missing watchedRepos inherits the instance allow-list', () {
    expect(
      watchesGitRef(
        settings: const {},
        repo: 'acme/api',
        branch: 'main',
        instanceRepos: instance,
      ),
      isTrue,
    );
  });

  test('empty watchedRepos means no git inbox', () {
    expect(
      watchesGitRef(
        settings: const {'watchedRepos': <String>[]},
        repo: 'acme/api',
        branch: 'main',
        instanceRepos: instance,
      ),
      isFalse,
    );
  });

  test('explicit repo watch requires a matching branch when branches are set', () {
    expect(
      watchesGitRef(
        settings: const {
          'watchedRepos': ['acme/api'],
          'watchedBranches': ['develop'],
        },
        repo: 'acme/api',
        branch: 'main',
        instanceRepos: instance,
      ),
      isFalse,
    );
    expect(
      watchesGitRef(
        settings: const {
          'watchedRepos': ['acme/api'],
          'watchedBranches': ['develop'],
        },
        repo: 'acme/api',
        branch: 'develop',
        instanceRepos: instance,
      ),
      isTrue,
    );
  });

  test('gitInboxWatchers excludes the committer', () {
    expect(
      gitInboxWatchers(
        userSettingsById: {
          'u-author': const {'watchedRepos': ['acme/api']},
          'u-watcher': const {'watchedRepos': ['acme/api']},
        },
        repo: 'acme/api',
        branch: 'main',
        instanceRepos: instance,
        senderUserId: 'u-author',
      ),
      {'u-watcher'},
    );
  });
}
