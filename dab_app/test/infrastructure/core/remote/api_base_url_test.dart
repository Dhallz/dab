import 'package:dab_app/infrastructure/core/remote/api_base_url.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('local Docker default maps to ws://localhost:9080/ws', () {
    expect(
      ApiBaseUrl.webSocket('http://localhost:9080'),
      'ws://localhost:9080/ws',
    );
  });

  test('Railway HTTPS maps to wss and strips a trailing slash', () {
    expect(
      ApiBaseUrl.webSocket('https://dab.up.railway.app/'),
      'wss://dab.up.railway.app/ws',
    );
  });
}
