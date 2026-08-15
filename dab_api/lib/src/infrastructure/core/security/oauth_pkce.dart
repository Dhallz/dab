import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:uuid/uuid.dart';

import '../../../domain/ports/i_oauth_pkce.dart';

/// [ARCH: INFRASTRUCTURE]
/// ROLE: PKCE S256 verifier/challenge and OAuth state ids.
class OauthPkce implements IOauthPkce {
  OauthPkce({Random? random, Uuid? uuid})
    : _random = random ?? Random.secure(),
      _uuid = uuid ?? const Uuid();

  final Random _random;
  final Uuid _uuid;

  @override
  String generateStateId() => _uuid.v4();

  @override
  String generateVerifier() {
    final bytes = List<int>.generate(32, (_) => _random.nextInt(256));
    return base64UrlEncode(bytes).replaceAll('=', '');
  }

  @override
  String challengeS256(String verifier) {
    final digest = sha256.convert(utf8.encode(verifier));
    return base64UrlEncode(digest.bytes).replaceAll('=', '');
  }
}
