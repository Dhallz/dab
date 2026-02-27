import 'package:dio/dio.dart';

class RestApiClient {
  final Dio dio;
  final String baseUrl;

  RestApiClient({required this.baseUrl, Dio? dio})
    : dio = dio ?? Dio(BaseOptions(baseUrl: baseUrl));

  Future<Response> get(String path, {Map<String, dynamic>? queryParameters}) {
    return dio.get(path, queryParameters: queryParameters);
  }

  Future<Response> post(String path, {dynamic data}) {
    return dio.post(path, data: data);
  }
}
