import 'package:dio/dio.dart';

class ApiClient {
  final Dio _dio = Dio();

  ApiClient() {
    _dio.options.baseUrl = 'https://675bdbf19ce247eb1937a435.mockapi.io/';
  }

  Future<Response> get(String path) async {
    return await _dio.get(path);
  }

  Future<Response> post(String path, {dynamic data}) async {
    return await _dio.post(path, data: data);
  }
}
