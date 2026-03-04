import 'package:relic/relic.dart';

import '../../infrastructure/database/redis/redis_service.dart';
import '../../service_locator.dart';

class VegasMiddleware {
  static Handler checkStaleness(Handler inner) {
    return (Request request) async {
      final redis = sl<RedisService>();
      final clientToken = request.headers['X-Sync-Token'];

      if (clientToken != null) {
        final serverToken = await redis.getCurrentVersion();

        if (clientToken == serverToken.toString()) {
          return Response(304, body: Body.empty());
        }
      }

      return await inner(request);
    };
  }
}
