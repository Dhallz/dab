import 'package:dab_api/src/infrastructure/protocols/rest/json_rest_protocol.dart';
import 'package:dab_api/src/infrastructure/sources/github/github_branch_catalog.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class _MockJsonRest extends Mock implements JsonRestProtocol {}

void main() {
  late _MockJsonRest jsonRest;
  late GitHubBranchCatalog catalog;

  setUpAll(() {
    registerFallbackValue(Uri.parse('https://example.com'));
    registerFallbackValue(<String, String>{});
  });

  setUp(() {
    jsonRest = _MockJsonRest();
    catalog = GitHubBranchCatalog(jsonRest);
  });

  test('unions GitHub branch names and pins main first', () async {
    when(
      () => jsonRest.getJsonList(any(), headers: any(named: 'headers')),
    ).thenAnswer(
      (_) async => [
        {'name': 'feature/x'},
        {'name': 'main'},
      ],
    );

    final out = await catalog.listBranches(
      settings: const {'api.token': 'tok'},
      repos: const ['acme/app'],
    );
    final list = out.getOrElse((_) => throw StateError('left'));
    expect(list.available.first, 'main');
    expect(list.available, containsAll(['main', 'feature/x']));
    expect(list.truncated, isFalse);
  });
}
