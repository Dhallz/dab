import 'package:dab_app/domain/entities/user/git_branch_list.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('parses available branch names and truncated flag', () {
    final list = GitBranchList.fromMap({
      'available': ['main', 'develop'],
      'truncated': true,
    });
    expect(list.available, ['main', 'develop']);
    expect(list.truncated, isTrue);
  });
}
