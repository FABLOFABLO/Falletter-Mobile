import 'package:dio/dio.dart';
import 'package:falletter/core/constants/api_endpoints.dart';
import 'package:falletter/models/question_model.dart';
import 'package:falletter/models/received_letter_model.dart';
import 'package:falletter/services/dio.dart';

class QuestionService {
  final String accessToken;
  final Dio _dio = DioClient().dio;

  QuestionService(this.accessToken);

  Future<List<QuestionModel>> fetchQuestions() async {
    final response = await _dio.get(
      ApiEndPoints.questions,
      options: Options(
        headers:
        {
          'Authorization': 'Bearer $accessToken',
        },
      ),
    );
    switch (response.statusCode) {
      case 200:
        final data = response.data as List;
        return data.map((e) => QuestionModel.fromJson(e)).toList();
      case 400:
        throw Exception('Bad Request 잘못된 요청');
      case 401:
        throw Exception('Unauthorized 인증 실패');
      case 404:
        throw Exception('Not Found 질문을 찾을 수 없음');
      case 500:
        throw Exception('Internal Server Error');
      default:
        throw Exception('알 수 없는 오류 (${response.statusCode})');
    }
  }

  Future<void> submitSelectedStudent({
    required int questionId,
    required int targetUserId,
  }) async {
    final response = await _dio.post(
      ApiEndPoints.brickUsed,
      data: {
        'question_id': questionId,
        'target_user': targetUserId,
      },
      options: Options(headers: {
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json',
      }),
    );
    switch (response.statusCode) {
      case 201:
        return;
      case 401:
        throw Exception('Unauthorized 인증 실패');
      case 404:
        throw Exception('Not Found 브릭 사용 내역을 찾을 수 없음');
      case 500:
        throw Exception('Internal Server Error');
      default:
        throw Exception('알 수 없는 오류 (${response.statusCode})');
    }
  }
}
