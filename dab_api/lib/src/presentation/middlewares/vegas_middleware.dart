import 'package:dab_api/src/infrastructure/database/redis/redis_service.dart';
import 'package:dab_api/src/service_locator.dart';
import 'package:relic/relic.dart';

/// ETag-like suppression for the canonical `GET /activities` list only.
///
/// Do not apply to `/activities/search`, `/activities/live`, or other verb paths:
/// a mistaken `X-Sync-Token` match would return `304` with an empty body and
/// break clients that expect JSON.
class VegasMiddleware {
  /// Middleware to check for staleness using X-Sync-Token.
  ///
  /// The [redisService] is optional and used for dependency injection in tests.
  static Handler checkStaleness(Handler inner, {RedisService? redisService}) {
    return (Request request) async {
      if (!_syncTokenGateApplies(request)) {
        return await inner(request);
      }

      final redis = redisService ?? sl<RedisService>();
      final clientToken = request.headers['X-Sync-Token']?.first;

      if (clientToken != null) {
        final serverToken = await redis.getCurrentVersion();

        if (clientToken == serverToken.toString()) {
          return Response(304, body: Body.empty()) as Result;
        }
      }

      return await inner(request);
    };
  }

  /// Only [`GET /activities`] carries sync semantics; narrower paths skip.
  static bool _syncTokenGateApplies(Request request) {
    if (request.method != Method.get) return false;

    var path = Uri.decodeFull(request.url.path);
    while (path.contains('//')) {
      path = path.replaceAll('//', '/');
    }
    if (path.isEmpty) path = '/';
    if (path.length > 1 && path.endsWith('/')) {
      path = path.substring(0, path.length - 1);
    }
    return path == '/activities';
  }
}
