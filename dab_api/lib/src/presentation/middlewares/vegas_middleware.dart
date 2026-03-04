import 'package:dab_api/src/infrastructure/database/redis/redis_service.dart';
import 'package:dab_api/src/service_locator.dart';
import 'package:relic/relic.dart';

class VegasMiddleware {
  /// Middleware to check for staleness using X-Sync-Token.
  ///
  /// The [redisService] is optional and used for dependency injection in tests.
  static Handler checkStaleness(Handler inner, {RedisService? redisService}) {
    return (Request request) async {
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
}
