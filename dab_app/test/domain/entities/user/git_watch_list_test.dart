import 'package:dab_app/domain/entities/user/git_watch_list.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('parses available repos, selected keys, and branches', () {
    final watch = GitWatchList.fromMap({
      'available': [
        {'key': 'acme/api', 'name': 'acme/api'},
        {'key': 'acme/app', 'name': 'acme/app'},
      ],
      'selected': ['acme/api'],
      'branches': ['main'],
    });
    expect(watch.available.map((p) => p.key), ['acme/api', 'acme/app']);
    expect(watch.selected, ['acme/api']);
    expect(watch.branches, ['main']);
  });
}
