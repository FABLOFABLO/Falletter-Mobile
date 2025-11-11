import 'package:dio/dio.dart';
import 'package:falletter/core/constants/api_endpoints.dart';
import 'package:falletter/services/dio.dart';
import 'package:falletter/models/sent_letter_model.dart';

class SentLetterService {
  final String accessToken;
  final Dio _dio = DioClient().dio;

  SentLetterService(this.accessToken);

  Future<List<SentLetterModel>> fetchSentLetters() async {
    try {
      final response = await _dio.get(
        ApiEndPoints.letterSentAll,
        options: Options(
          headers: {
            'Authorization': 'Bearer $accessToken',
          },
        ),
      );
      switch (response.statusCode) {
        case 200:
          final data = response.data;
          if (data is! List) {
            throw Exception('응답 형식이 올바르지 않습니다');
          }
          return data.map((e) => SentLetterModel.fromJson(e)).toList();
        case 401:
          throw Exception('Unauthorized 인증 실패');
        case 404:
          return [];
        case 500:
          throw Exception('Internal Server Error');
        default:
          throw Exception('서버 오류 (${response.statusCode})');
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        return [];
      }
      throw Exception('보낸 레터 조회 실패: ${e.response?.statusCode}');
    } catch (e) {
      rethrow;
    }
  }

  Future<SentLetterModel> fetchSentLetterDetail(int id) async {
    try {
      final response = await _dio.get(
        '${ApiEndPoints.letterSent}/$id',
        options: Options(
          headers: {
            'Authorization': 'Bearer $accessToken',
          },
        ),
      );
      switch (response.statusCode) {
        case 200:
          return SentLetterModel.fromJson(response.data);
        case 401:
          throw Exception('Unauthorized 인증 실패');
        case 404:
          throw Exception('Not Found 유저 / 레터를 찾을 수 없음');
        case 500:
          throw Exception('Internal Server Error');
        default:
          throw Exception('서버 오류 (${response.statusCode})');
      }
    } on DioException catch (e) {
      throw Exception('보낸 레터 조회 실패: ${e.response?.statusCode}');
    } catch (e) {
      rethrow;
    }
  }
}