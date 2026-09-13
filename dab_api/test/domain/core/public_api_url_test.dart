import 'package:dab_api/src/domain/core/public_api_url.dart';
import 'package:test/test.dart';

void main() {
  test('upgrades public http origins to https', () {
    expect(
      ('http://discourse-huddle-bagful.ngrok-free.dev').canonicalizePublicApiBase(),
      'https://discourse-huddle-bagful.ngrok-free.dev',
    );
  });

  test('keeps localhost http', () {
    expect(
      ('http://localhost:9080/').canonicalizePublicApiBase(),
      'http://localhost:9080',
    );
  });

  test('leaves https unchanged', () {
    expect(
      ('https://dab.example/').canonicalizePublicApiBase(),
      'https://dab.example',
    );
  });
}
