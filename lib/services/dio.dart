import 'package:dio/dio.dart';
import 'package:falletter/core/constants/api_endpoints.dart';

class DioClient {
  static final DioClient _instance = DioClient._internal();
  late Dio dio;

  factory DioClient() {
    return _instance;
  }

  DioClient._internal() {
    dio = Dio(
      BaseOptions(
        baseUrl: ApiEndPoints.baseUrl,
        contentType: Headers.jsonContentType,
        responseType: ResponseType.json,
      ),
    );
  }
}
