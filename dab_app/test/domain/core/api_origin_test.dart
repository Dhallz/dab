import 'package:dab_app/domain/core/api_origin.dart';
import 'package:dab_app/domain/core/failures.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('strips trailing slashes and keeps https', () {
    final result = ApiOrigin.parse('https://dab.example.com/');
    expect(result.getOrElse((_) => ''), 'https://dab.example.com');
  });

  test('adds https for a public host without a scheme', () {
    final result = ApiOrigin.parse('dab.up.railway.app');
    expect(result.getOrElse((_) => ''), 'https://dab.up.railway.app');
  });

  test('adds http for localhost without a scheme', () {
    final result = ApiOrigin.parse('localhost:9080');
    expect(result.getOrElse((_) => ''), 'http://localhost:9080');
  });

  test('rejects empty input', () {
    final result = ApiOrigin.parse('  ');
    expect(result.fold((l) => l, (_) => null), isA<ValidationFailure>());
  });

  test('rejects non-http schemes', () {
    final result = ApiOrigin.parse('ftp://example.com');
    expect(result.fold((l) => l, (_) => null), isA<ValidationFailure>());
  });
}
