import 'package:dio/dio.dart';

import '../../../services/service_locator.dart';

class VegasInterceptor extends Interceptor {
  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // Only apply sync token to the main activities list, not searches or other endpoints
    if (options.path == '/activities') {
      final settingsResult = await sl.systemRepository.getSettings();
      final settings = settingsResult.fold((l) => null, (r) => r);
      final token = settings?.syncToken;

      if (token != null) {
        options.headers['X-Sync-Token'] = token;
      }
    }
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) async {
    // 304 Not Modified is inherently successful, passing the delta logic back to the UI/Repo
    if (response.statusCode == 304) {
      return super.onResponse(response, handler);
    }

    // Extract syncToken from standard envelope and save it
    if (response.data is Map<String, dynamic>) {
      final meta = response.data['meta'];
      if (meta != null && meta['syncToken'] != null) {
        final settingsResult = await sl.systemRepository.getSettings();
        final settings = settingsResult.fold((l) => null, (r) => r);
        if (settings != null) {
          final updatedSettings = settings.copyWith(
            syncToken: meta['syncToken'].toString(),
          );
          await sl.systemRepository.saveSettings(updatedSettings);
        }
      }
    }
    super.onResponse(response, handler);
  }
}
