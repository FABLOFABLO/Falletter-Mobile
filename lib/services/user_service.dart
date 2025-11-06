import 'package:dio/dio.dart';
import 'package:falletter/core/constants/api_endpoints.dart';
import 'package:falletter/services/dio.dart';

/// 정보조회
class UserService {
  final Dio _dio = DioClient().dio;

  Future<Map<String, dynamic>> getUserInfo() async {
    try {
      final response = await _dio.get(ApiEndPoints.users);

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
        throw Exception('유저 정보를 불러올 수 없습니다.');
      }
    } on DioException catch (e) {
      if (e.response != null) {
        switch (e.response?.statusCode) {
          case 401:
            throw Exception('Unauthorized 인증 실패');
          case 403:
            throw Exception('Forbidden 권한 없음');
          case 404:
            throw Exception('Not Found 유저를 찾을 수 없음');
          case 500:
            throw Exception('Internal Server Error');
          default:
            throw Exception('서버 오류: ${e.response?.statusCode}');
        }
      } else {
        throw Exception('네트워크 오류');
      }
    }
  }

  Future<String> logout() async {
    final response = await _dio.delete(
      ApiEndPoints.logOut, data: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer your_access_token', // 실제 토큰 적용
    },
    );
    switch (response.statusCode) {
      case 204:
        return 'OK';
      case 401:
        return 'Unauthorized 인증 실패';
      case 404:
        return 'Not Found 유저를 찾을 수 없음';
      case 500:
        return 'Internal Server Error';
      default:
        return '알 수 없는 오류 (${response.statusCode})';
    }
  }
}