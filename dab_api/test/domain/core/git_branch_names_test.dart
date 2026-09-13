import 'package:dab_api/src/domain/core/git_branch_names.dart';
import 'package:test/test.dart';

void main() {
  test('pins main ahead of other names', () {
    final list = [
      'feature/x',
      'main',
      'develop',
    ].gitBranchListFromNames(truncated: false);
    expect(list.available, ['main', 'develop', 'feature/x']);
    expect(list.truncated, isFalse);
  });
}
