import 'package:dio/dio.dart';
import 'package:falletter/core/constants/api_endpoints.dart';
import 'package:falletter/models/student_model.dart';
import 'package:falletter/services/dio.dart';

class StudentService {
  final String accessToken;
  final Dio _dio = DioClient().dio;

  StudentService(this.accessToken);

  Future<List<StudentModel>> fetchStudents({String? currentUserSchoolNumber, String? currentUserName}) async {
    try {
      final response = await _dio.get(
        ApiEndPoints.students,
        options: Options(
          headers: {
            'Authorization': 'Bearer $accessToken',
          },
          validateStatus: (status) => status != null && status < 500,
        ),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        final students = data.map((e) => StudentModel.fromJson(e)).toList();

        if (currentUserSchoolNumber != null && currentUserName != null) {
          return students.where((s) =>
          !(s.schoolNumber == currentUserSchoolNumber && s.name == currentUserName)
          ).toList();
        }
        return students;
      }
      switch (response.statusCode) {
        case 401:
          throw Exception('Unauthorized (인증 실패)');
        case 403:
          throw Exception('Forbidden (권한 없음)');
        case 404:
          throw Exception('Not Found (API 경로 오류)');
        default:
          throw Exception('Unknown Error: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception('네트워크 오류: ${e.message}');
    }
  }
}