import 'package:dab_api/src/infrastructure/core/security/shared_secret_verifier.dart';
import 'package:test/test.dart';

void main() {
  final verifier = SharedSecretVerifier();

  test('accepts matching secrets', () {
    expect(verifier.isValid(provided: 'abc123', expected: 'abc123'), isTrue);
  });

  test('trims surrounding whitespace before comparing', () {
    expect(verifier.isValid(provided: ' abc123 ', expected: 'abc123'), isTrue);
  });

  test('rejects mismatched secrets', () {
    expect(verifier.isValid(provided: 'abc124', expected: 'abc123'), isFalse);
  });

  test('rejects different-length secrets', () {
    expect(verifier.isValid(provided: 'abc', expected: 'abc123'), isFalse);
  });

  test('rejects when either side is empty', () {
    expect(verifier.isValid(provided: '', expected: 'abc123'), isFalse);
    expect(verifier.isValid(provided: 'abc123', expected: ''), isFalse);
    expect(verifier.isValid(provided: '', expected: ''), isFalse);
  });
}
