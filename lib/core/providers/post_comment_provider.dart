import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:falletter/models/post_comment_model.dart';
import 'package:falletter/services/post_service.dart';
import 'package:falletter/services/comment_service.dart';
import 'package:falletter/core/providers/auth_token_provider.dart';

final postServiceProvider = Provider<PostService>((ref) {
  final token = ref.watch(accessTokenProvider);
  if (token == null) throw Exception('토큰 없음');
  return PostService(token);
});

final commentServiceProvider = Provider<CommentService>((ref) {
  final token = ref.watch(accessTokenProvider);
  if (token == null) throw Exception('토큰 없음');
  return CommentService(token);
});

final postsProvider = StateNotifierProvider<PostsNotifier, List<PostModel>>((
  ref,
) {
  final service = ref.watch(postServiceProvider);
  return PostsNotifier(service);
});

class PostsNotifier extends StateNotifier<List<PostModel>> {
  final PostService _service;
  late final CommentService _commentService;

  PostsNotifier(this._service) : super([]) {
    _commentService = _service.commentService;
  }

  Future<void> fetchPosts() async {
    try {
      final posts = await _service.getAllPosts();
      state = posts;
      for (var post in posts) {
        await fetchPostById(post.id);
      }
    } catch (e) {
      print('=== fetchPosts error: $e');
    }
  }

  Future<void> fetchPostById(int postId) async {
    try {
      final post = await _service.getPostDetail(postId);

      final updated = [...state];
      final index = updated.indexWhere((p) => p.id == postId);

      if (index != -1) {
        updated[index] = post;
      } else {
        updated.add(post);
      }

      state = updated;
    } catch (e) {
      print('=== fetchPostById error: $e');
    }
  }

  Future<void> addPost(String title, String content) async {
    try {
      final success = await _service.createPost(title, content);
      if (success) await fetchPosts();
    } catch (e) {
      print('=== addPost error: $e');
    }
  }

  Future<void> updatePost(int postId, String title, String content) async {
    try {
      final success = await _service.updatePost(postId, title, content);
      if (success) await fetchPostById(postId);
    } catch (e) {
      print('=== updatePost error: $e');
    }
  }

  Future<bool> deletePost(int postId) async {
    try {
      final success = await _service.deletePost(postId);
      if (success) {
        state = state.where((p) => p.id != postId).toList();
      }
      return success;
    } catch (e) {
      print('=== deletePost error: $e');
      return false;
    }
  }

  Future<bool> addComment(int postId, String text) async {
    try {
      final success = await _commentService.createComment(postId, text);
      if (success) {
        await fetchPostById(postId);
      }
      return success;
    } catch (e) {
      print('=== addComment error: $e');
      return false;
    }
  }

  Future<bool> deleteComment(int postId, int commentId) async {
    try {
      final success = await _commentService.deleteComment(commentId);
      print("deleteComment success: $success");
      if (success) {
        await fetchPostById(postId);
      }
      return success;
    } catch (e) {
      print('=== deleteComment error: $e');
      return false;
    }
  }
}
