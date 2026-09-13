import 'package:dab_app/domain/entities/user/jira_project_watch_list.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('parses available projects and selected keys', () {
    final watch = JiraProjectWatchList.fromMap({
      'available': [
        {'key': 'DAB', 'name': 'DAB board'},
        {'key': 'OPS', 'name': 'Ops'},
      ],
      'selected': ['DAB'],
    });
    expect(watch.available.map((p) => p.key), ['DAB', 'OPS']);
    expect(watch.selected, ['DAB']);
    expect(watch.available.first.name, 'DAB board');
  });
}
