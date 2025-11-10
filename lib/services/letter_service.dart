import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:falletter/core/constants/api_endpoints.dart';
import 'package:falletter/models/letter_model.dart';
import 'package:falletter/services/dio.dart';

class LetterService {
  final String accessToken;
  final Dio _dio = DioClient().dio;

  LetterService(this.accessToken);

  Future<String> sendLetter(LetterModel letter) async {
    try {
      final response = await _dio.post(
        ApiEndPoints.letterSent,
        data: letter.toJson(),
        options: Options(
          headers: {
            'Authorization': 'Bearer $accessToken',
            'Content-Type': 'application/json',
          },
        ),
      );
      switch (response.statusCode) {
        case 201:
          return 'Created';
        case 400:
          throw Exception('Bad Request - 잘못된 요청');
        case 401:
          throw Exception('Unauthorized - 인증 실패');
        case 403:
          throw Exception('Forbidden - 권한 없음');
        case 404:
          throw Exception('Not Found - 사용자를 찾을 수 없음');
        case 500:
          throw Exception('레터 개수가 부족합니다');
        default:
          throw Exception('알 수 없는 오류 (${response.statusCode})');
      }
    } on DioException catch (e) {
      print('❌ DioException: ${e.response?.statusCode} - ${e.message}');
      if (e.response != null) {
        switch (e.response!.statusCode) {
          case 400:
            throw Exception('잘못된 요청');
          case 401:
            throw Exception('인증 실패');
          case 403:
            throw Exception('권한 없음');
          case 404:
            throw Exception('사용자를 찾을 수 없음');
          case 500:
            throw Exception('레터 개수가 부족합니다');
          default:
            throw Exception('서버 오류 (${e.response!.statusCode})');
        }
      }
      throw Exception('네트워크 오류: ${e.message}');
    } catch (e) {
      throw Exception('서버 통신 오류: $e');
    }
  }
}