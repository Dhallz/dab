import 'package:relic/relic.dart';

export 'test_factories.dart';

/// A utility to create real Request objects for testing since the constructor is private.
class TestRequest {
  static Request create({
    Method method = Method.get,
    required Uri url,
    Map<String, List<String>>? headers,
    Body? body,
    Object? token,
  }) {
    return RequestInternal.create(
      method,
      url,
      token ?? Object(),
      headers: Headers.fromMap(headers),
      body: body ?? Body.empty(),
    );
  }
}
