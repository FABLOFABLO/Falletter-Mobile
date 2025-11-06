import 'package:dio/dio.dart';
import 'package:falletter/core/constants/api_endpoints.dart';
import 'package:falletter/services/dio.dart';

class AuthService {
  final Dio _dio = DioClient().dio;

  Future<String> signUp({
    required String email,
    required String password,
    required String schoolNumber,
    required String name,
    required String gender,
  }) async {
    try {
      final response = await _dio.post(
        ApiEndPoints.signUp,
        data: {
          'email': email,
          'password': password,
          'school_number': schoolNumber,
          'name': name,
          'gender': gender,
        },
      );

      switch (response.statusCode) {
        case 201:
          return 'OK';
        case 400:
          return 'Bad Request 잘못된 요청';
        case 403:
          return 'Forbidden 이메일 인증 필요';
        case 409:
          return 'Conflict 중복된 학번';
        case 500:
          return 'Internal Server Error';
        default:
          return '오류 발생 ${response.statusCode}';
      }
    } on DioException catch (e) {
      if (e.response != null) {
        return '서버 오류: ${e.response?.statusCode}';
      } else {
        return '네트워크 오류';
      }
    }
  }

  Future<String> sendVerificationCode(String email) async {
    try {
      final response = await _dio.post(
        ApiEndPoints.emailVerify,
        data: {'email': email},
      );
      switch (response.statusCode) {
        case 200:
          return 'OK';
        case 400:
          return 'Bad Request 잘못된 요청';
        case 501:
          return 'Internal Server Error';
        default:
          return '오류 발생 ${response.statusCode}';
      }
    } on DioException catch (e) {
      return e.response != null
          ? '서버 오류: ${e.response?.statusCode}'
          : '네트워크 오류';
    }
  }

  Future<String> verifyCodeMatch({
    required String email,
    required String code,
  }) async {
    try {
      final response = await _dio.post(
        ApiEndPoints.emailMatch,
        data: {
          'email': email,
          'verify_code': code,
        },
      );
      switch (response.statusCode) {
        case 200:
          return 'OK';
        case 400:
          return 'Bad Request 잘못된 요청';
        case 403:
          if (response.data is Map &&
              response.data['message'] == 'Unmatched Verify Code') {
            return 'Forbidden 인증번호 불일치';
          }
          return '인증 실패';
        default:
          return '오류 발생: ${response.statusCode}';
      }
    } on DioException catch (e) {
      if (e.response != null) {
        final statusCode = e.response?.statusCode;
        if (statusCode == 403 &&
            e.response?.data is Map &&
            e.response?.data['message'] == 'Unmatched Verify Code') {
          return '인증번호가 일치하지 않습니다.';
        }
        return '서버 오류: $statusCode';
      } else {
        return '네트워크 오류';
      }
    }
  }

  Future<dynamic> login({
    required String email,
    required String password
  }) async {
    try {
      final response = await _dio.post(
        ApiEndPoints.signIn,
        data: {
          'email': email,
          'password': password,
        },
        options: Options(headers: {
          'Content-Type': 'application/json',
        }),
      );
      switch (response.statusCode) {
        case 200:
          return response.data;
        case 400:
          return 'Bad Request 잘못된 요청';
        case 403:
          return 'Forbidden 권한 없음';
        case 404:
          return 'Not Found 유저를 찾을 수 없음';
        case 500:
          return 'Internal Server Error';
        default:
          return '서버 오류: ${response.statusCode}';
      }
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception('서버 오류: ${e.response?.statusCode}');
      } else {
        throw Exception('네트워크 오류');
      }
    }
  }
}
