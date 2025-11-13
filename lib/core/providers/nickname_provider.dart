import 'dart:math';
import 'package:falletter/core/providers/user_provider.dart';
import 'package:falletter/models/post_comment_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:falletter/core/constants/nonymous_nicknames.dart';

final nicknameProvider = StateNotifierProvider<NicknameNotifier, Map<int, Map<String, String>>>(
      (ref) => NicknameNotifier(),
);

class NicknameNotifier extends StateNotifier<Map<int, Map<String, String>>> {
  NicknameNotifier() : super({});
  final _random = Random();

  String getOrCreateNickname(int postId, String username) {
    final postNickMap = state[postId] ?? <String, String>{};
    if (postNickMap.containsKey(username)) return postNickMap[username]!;

    final nickname = anonymousNicknames[_random.nextInt(anonymousNicknames.length)];
    state = {
      ...state,
      postId: {
        ...postNickMap,
        username: nickname,
      },
    };
    return nickname;
  }

  void clearPostNicknames(int postId) {
    final newState = Map<int, Map<String, String>>.from(state);
    newState.remove(postId);
    state = newState;
  }
}

String getPostNickname(WidgetRef ref, PostModel post) {
  final currentUser = ref.watch(currentUserInfoProvider);

  if (currentUser != null && currentUser.name == post.authorName) {
    return currentUser.name;
  }

  final nicknameNotifier = ref.read(nicknameProvider.notifier);
  return nicknameNotifier.getOrCreateNickname(post.id, post.authorName);
}