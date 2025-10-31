

import 'package:flutter_riverpod/flutter_riverpod.dart';

final commentProvider = StateNotifierProvider<CommentNotifier, Map<int, List<Map<String, dynamic>>>>((ref) {
  return CommentNotifier();
});

class CommentNotifier extends StateNotifier<Map<int, List<Map<String, dynamic>>>> {
  CommentNotifier() : super({});

  void addComment(int postId, Map<String, dynamic> comment) {
    final current = List<Map<String, dynamic>>.from(state[postId] ?? []);
    current.add(comment);
    state = {...state, postId: current};
  }

  void deleteComment(int postId, int commentId) {
    final current = List<Map<String, dynamic>>.from(state[postId] ?? []);
    current.removeWhere((c) => c['id'] == commentId);
    state = {...state, postId: current};
  }

  int count(int postId) => state[postId]?.length ?? 0;

  List<Map<String, dynamic>> getComments(int postId) => state[postId] ?? [];
}