import 'package:dio/dio.dart';

import 'vegas_interceptor.dart';

class RestApiClient {
  final Dio dio;
  final String baseUrl;

  RestApiClient({required this.baseUrl, Dio? dio})
    : dio =
          dio ??
          Dio(
            BaseOptions(
              baseUrl: baseUrl,
              validateStatus: (status) =>
                  status != null &&
                  ((status >= 200 && status < 300) || status == 304),
            ),
          ) {
    this.dio.interceptors.add(VegasInterceptor());
  }

  void addInterceptor(Interceptor interceptor) {
    dio.interceptors.add(interceptor);
  }

  Future<Response> get(String path, {Map<String, dynamic>? queryParameters}) {
    return dio.get(path, queryParameters: queryParameters);
  }

  Future<Response> post(String path, {dynamic data}) {
    return dio.post(path, data: data);
  }
}
