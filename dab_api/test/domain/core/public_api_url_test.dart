import 'package:dab_api/src/domain/core/public_api_url.dart';
import 'package:test/test.dart';

void main() {
  test('upgrades public http origins to https', () {
    expect(
      canonicalizePublicApiBase('http://discourse-huddle-bagful.ngrok-free.dev'),
      'https://discourse-huddle-bagful.ngrok-free.dev',
    );
  });

  test('keeps localhost http', () {
    expect(
      canonicalizePublicApiBase('http://localhost:9080/'),
      'http://localhost:9080',
    );
  });

  test('leaves https unchanged', () {
    expect(
      canonicalizePublicApiBase('https://dab.example/'),
      'https://dab.example',
    );
  });
}
