import 'package:dab_api/src/infrastructure/core/security/settings_cipher.dart';
import 'package:test/test.dart';

void main() {
  test('round-trips a settings map', () {
    final cipher = SettingsCipher('test-credentials-key');
    const original = {'api.token': 'ghp_secret', 'email': 'a@b.c'};
    final encrypted = cipher.encryptMap(original);
    expect(encrypted.contains('ghp_secret'), isFalse);
    expect(encrypted.split(':').length, greaterThanOrEqualTo(2));
    expect(cipher.decryptMap(encrypted), original);
  });

  test('distinct IVs produce different ciphertext for the same payload', () {
    final cipher = SettingsCipher('test-credentials-key');
    const original = {'api.token': 'ghp_secret'};
    final a = cipher.encryptMap(original);
    final b = cipher.encryptMap(original);
    expect(a, isNot(b));
    expect(cipher.decryptMap(a), original);
    expect(cipher.decryptMap(b), original);
  });
}
