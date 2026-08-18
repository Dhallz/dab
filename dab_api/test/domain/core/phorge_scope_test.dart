import 'package:dab_api/src/domain/core/phorge_scope.dart';
import 'package:test/test.dart';

void main() {
  test('prefers instanceUrl over baseUrl and strips trailing slashes', () {
    expect(
      phorgeInstanceUrl(
        instanceUrl: 'https://phorge.internal/',
        baseUrl: 'https://phorge.example.com',
      ),
      'https://phorge.internal',
    );
    expect(
      phorgeInstanceUrl(baseUrl: 'https://phorge.internal/'),
      'https://phorge.internal',
    );
    expect(phorgeInstanceUrl(), isNull);
  });
}
