/*
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
        data: jsonEncode({'comment': text}),
        options: Options(
            headers: {
              'Authorization': 'Bearer $accessToken',
            },
        ),
      );
      switch (response.statusCode) {
        case 201:
          return true;
        case 400:
          throw Exception('Bad Request 잘못된 요청');
        case 401:
          throw Exception('Unauthorized 인증 실패');
        case 404:
          throw Exception('Not Found 게시물을 찾을 수 없음');
        case 500:
          throw Exception('Internal Server Error');
        default:
          throw Exception('서버 오류 (${response.statusCode})');
      }
    } on DioException catch (e) {
      throw Exception('댓글 작성 실패: ${e.response?.statusCode}');
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
      switch (response.statusCode) {
        case 201:
          return true;
        case 401:
          throw Exception('Unauthorized 인증 실패');
        case 404:
          throw Exception('Not Found 게시글을 찾을 수 없음');
        case 409:
          throw Exception('Conflict 이미 삭제된 게시글');
        case 500:
          throw Exception('Internal Server Error');
        default:
          throw Exception('서버 오류 (${response.statusCode})');
      }
    } on DioException catch (e) {
      throw Exception('댓글 삭제 실패: ${e.response?.statusCode}');
    }
  }
}
*/

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
        options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
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
        options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
      );
      print('=== deleteComment response.statusCode: ${response.statusCode}');
      return response.statusCode == 204;
    } catch (e) {
      print('=== deleteComment error: $e');
      return false;
    }
  }
}