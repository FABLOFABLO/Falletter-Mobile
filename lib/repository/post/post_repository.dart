import 'package:falletter/core/providers/auth_token_provider.dart';
import 'package:falletter/models/post_model.dart';
import 'package:falletter/services/post_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PostRepository {
  final PostService _service;
  PostRepository(this._service);

  Future<List<PostModel>> getAllPosts() => _service.getAllPosts();
}

final postRepositoryProvider = Provider<PostRepository>((ref) {
  final token = ref.watch(accessTokenProvider);
  if (token == null) throw Exception('토큰 없음');
  return PostRepository(PostService(token));
});