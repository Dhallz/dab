import 'package:dab_app/domain/entities/user/linear_team_watch_list.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('parses available teams and selected keys', () {
    final watch = LinearTeamWatchList.fromMap({
      'available': [
        {'key': 'ENG', 'name': 'Engineering'},
        {'key': 'OPS', 'name': 'Ops'},
      ],
      'selected': ['ENG'],
    });
    expect(watch.available.map((t) => t.key), ['ENG', 'OPS']);
    expect(watch.selected, ['ENG']);
    expect(watch.available.first.name, 'Engineering');
  });
}
