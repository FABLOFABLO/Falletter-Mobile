import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:falletter/models/post_comment_model.dart';
import 'package:falletter/services/comment_service.dart';
import 'package:falletter/core/constants/api_endpoints.dart';
import 'package:falletter/services/dio.dart';

class PostService {
  final String accessToken;
  final Dio _dio = DioClient().dio;

  late final CommentService commentService = CommentService(accessToken);

  PostService(this.accessToken);

  Future<bool> createPost(String title, String content) async {
    try {
      final response = await _dio.post(
        ApiEndPoints.post,
        options: Options(headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        }),
        data: jsonEncode({'title': title, 'content': content}),
      );
      print('=== createPost response.statusCode: ${response.statusCode}');
      return response.statusCode == 201;
    } catch (e) {
      print('=== createPost error: $e');
      return false;
    }
  }

  Future<List<PostModel>> getAllPosts() async {
    try {
      final response = await _dio.get(
        ApiEndPoints.post,
        options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
      );
      print('=== getAllPosts response.statusCode: ${response.statusCode}');
      print('=== getAllPosts response.data: ${response.data}');
      if (response.statusCode == 200 && response.data is List) {
        return (response.data as List).map((e) => PostModel.fromJson(e)).toList();
      }
      throw Exception('게시글 조회 실패, statusCode=${response.statusCode}');
    } on DioException catch (e) {
      throw Exception('게시글 조회 실패: ${e.response?.statusCode}');
    }
  }

  Future<bool> updatePost(int postId, String title, String content) async {
    try {
      final response = await _dio.patch(
        "${ApiEndPoints.post}/$postId",
        options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
        data: jsonEncode({'title': title, 'content': content}),
      );
      print('=== updatePost response.statusCode: ${response.statusCode}');
      return response.statusCode == 200;
    } catch (e) {
      print('=== updatePost error: $e');
      return false;
    }
  }

  Future<bool> deletePost(int postId) async {
    try {
      final response = await _dio.delete(
        "${ApiEndPoints.post}/$postId",
        options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
      );
      print('=== deletePost response.statusCode: ${response.statusCode}');
      return response.statusCode == 204;
    } catch (e) {
      print('=== deletePost error: $e');
      return false;
    }
  }

  Future<PostModel> getPostDetail(int postId) async {
    final response = await _dio.get(
      "${ApiEndPoints.post}/$postId",
      options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
    );
    if (response.statusCode == 200) return PostModel.fromJson(response.data);
    throw Exception('게시글 상세 조회 실패: ${response.statusCode}');
  }
}