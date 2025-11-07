import 'package:dio/dio.dart';
import 'package:falletter/core/constants/api_endpoints.dart';
import 'package:falletter/services/dio.dart';

class UserService {
  final Dio _dio = DioClient().dio;

  Future<Map<String, dynamic>> getUserInfo(String accessToken) async {
    try {
      final response = await _dio.get(
        ApiEndPoints.users,
        options: Options(
          headers: {
            'Authorization': 'Bearer $accessToken',
          },
        ),
      );

      if (response.statusCode == 200 && response.data != null) {
        final data = response.data as Map<String, dynamic>;
        return {
          'email': data['email'],
          'schoolNumber': data['school_number'],
          'name': data['name'],
          'gender': data['gender'],
          'profileImage': data['profile_image'],
        };
      } else {
        throw Exception('유저 정보를 불러올 수 없습니다. 상태코드: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception('유저 정보 조회 실패: ${e.response?.statusCode}');
    }
  }

  Future<void> logout() async {
    return;
  }

  Future<int> getLetterCount(String accessToken) async {
    try {
      final response = await _dio.get(
        ApiEndPoints.letterCount,
        options: Options(
          headers: {
            'Authorization': 'Bearer $accessToken',
          },
        ),
      );

      if (response.statusCode == 200) {
        return (response.data['letter_count'] ?? 0).toInt();
      } else {
        throw Exception('레터 개수를 불러올 수 없습니다.');
      }
    } on DioException catch (e) {
      throw Exception('레터 개수 조회 실패: ${e.message}');
    }
  }

  Future<int> getBrickCount(String accessToken) async {
    try {
      final response = await _dio.get(
        ApiEndPoints.brickCount,
        options: Options(
          headers: {
            'Authorization': 'Bearer $accessToken',
          },
        ),
      );

      if (response.statusCode == 200) {
        return (response.data['brick_count'] ?? 0).toInt();
      } else {
        throw Exception('브릭 개수를 불러올 수 없습니다.');
      }
    } on DioException catch (e) {
      throw Exception('브릭 개수 조회 실패: ${e.message}');
    }
  }
}