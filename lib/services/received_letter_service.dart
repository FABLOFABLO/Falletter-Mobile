import 'package:dio/dio.dart';
import 'package:falletter/core/constants/api_endpoints.dart';
import 'package:falletter/models/received_letter_model.dart';
import 'package:falletter/services/dio.dart';

class ReceivedLetterService {
  final Dio _dio = DioClient().dio;

  Future<List<ReceivedLetterModel>> fetchReceivedLetters(
    String accessToken,
  ) async {
    final response = await _dio.get(
      ApiEndPoints.letterReceived,
      options: Options(
        headers: {
          'Authorization': 'Bearer $accessToken',
        },
      ),
    );
    switch (response.statusCode) {
      case 200:
        final data = response.data;
        return (data as List)
            .map((e) => ReceivedLetterModel.fromJson(e as Map<String, dynamic>))
            .toList();
      case 401:
        throw Exception('Unauthorized 인증 실패');
      case 404:
        return [];
      case 500:
        throw Exception('Internal Server Error');
      default:
        throw Exception('서버 오류 (${response.statusCode})');
    }
  }
}
