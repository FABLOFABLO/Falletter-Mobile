import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:falletter/core/constants/api_endpoints.dart';
import 'package:falletter/services/dio.dart';

class CommentService {
  final String accessToken;
  final Dio _dio = DioClient().dio;

  CommentService(this.accessToken);

  Future<bool> createComment(int postId, String text) async {
    try {
      final response = await _dio.post(
        "${ApiEndPoints.comment}/$postId",
        options: Options(
            headers: {
              'Authorization': 'Bearer $accessToken',
            },
        ),
        data: jsonEncode({'comment': text}),
      );
      print('=== createComment response.statusCode: ${response.statusCode}');
      return response.statusCode == 201;
    } catch (e) {
      print('=== createComment error: $e');
      return false;
    }
  }

  Future<bool> deleteComment(int commentId) async {
    try {
      final response = await _dio.delete(
        "${ApiEndPoints.comment}/$commentId",
        options: Options(
            headers: {
              'Authorization': 'Bearer $accessToken',
            },
        ),
      );
      print('=== deleteComment response.statusCode: ${response.statusCode}');
      return response.statusCode == 204;
    } catch (e) {
      print('=== deleteComment error: $e');
      return false;
    }
  }
}