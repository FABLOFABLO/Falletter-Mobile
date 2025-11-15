import 'package:falletter/core/providers/post_comment_provider.dart';
import 'package:falletter/core/providers/theme_provider.dart';
import 'package:falletter/core/providers/nickname_provider.dart';
import 'package:falletter/core/theme/theme_colors.dart';
import 'package:falletter/presentation/main_page/view/post_detail_page.dart';
import 'package:falletter/presentation/main_page/view/post_page.dart';
import 'package:flutter/material.dart';
import 'package:falletter/core/constants/color.dart';
import 'package:falletter/core/constants/text_style.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timeago/timeago.dart' as timeago;

class MainPage extends ConsumerStatefulWidget {
  const MainPage({super.key});

  @override
  ConsumerState<MainPage> createState() => _MainPageState();
}

class _MainPageState extends ConsumerState<MainPage> {
  @override
  void initState() {
    super.initState();
    timeago.setLocaleMessages('ko', timeago.KoMessages());

    Future.microtask(() async {
      await ref.read(postsProvider.notifier).fetchPosts();

      final posts = ref.read(postsProvider);
      final nicknameNotifier = ref.read(nicknameProvider.notifier);

      for (var post in posts) {
        nicknameNotifier.getOrCreateNickname(post.id, post.authorName);
        for (var comment in post.comments) {
          nicknameNotifier.getOrCreateNickname(post.id, comment.username);
        }
      }
      setState(() {});
    });
  }

  Future<void> _refresh() async {
    await ref.read(postsProvider.notifier).fetchPosts();

    final posts = ref.read(postsProvider);
    final nicknameNotifier = ref.read(nicknameProvider.notifier);
    for (var post in posts) {
      nicknameNotifier.getOrCreateNickname(post.id, post.authorName);
      for (var comment in post.comments) {
        nicknameNotifier.getOrCreateNickname(post.id, comment.username);
      }
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final posts = ref.watch(postsProvider);
    final theme = ref.watch(themeProvider);
    final themeColors = appThemeColors[theme]!;
    final nicknameNotifier = ref.read(nicknameProvider.notifier);
    final screenWidth = MediaQuery.of(context).size.width;
    final fabSize = screenWidth * 0.2;

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _refresh,
        color: FalletterColor.white,
        backgroundColor: FalletterColor.middleBlack,
        child: ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 68),
          itemCount: posts.length,
          itemBuilder: (context, index) {
            final post = posts[index];
            final authorNickname =
                nicknameNotifier.state[post.id]?[post.authorName] ?? '';

            return Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: GestureDetector(
                onTap: () async {
                  final result = await Navigator.of(
                    context,
                    rootNavigator: true,
                  ).push(
                    MaterialPageRoute(
                      builder:
                          (_) => PostDetailPage(
                            postId: post.id,
                            title: post.title,
                            content: post.content,
                            nickname: authorNickname,
                            time: post.createdAt,
                          ),
                    ),
                  );

                  if (result != null) {
                    if (result is Map<String, bool> &&
                        (result['deleted'] == true ||
                            result['modified'] == true)) {
                      await _refresh();
                    }
                  }
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: FalletterColor.middleBlack,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        post.title,
                        overflow: TextOverflow.ellipsis,
                        style: FalletterTextStyle.subTitle2.copyWith(
                          color: FalletterColor.white,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        post.content,
                        overflow: TextOverflow.ellipsis,
                        style: FalletterTextStyle.body4.copyWith(
                          color: FalletterColor.gray400,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Text(
                            authorNickname,
                            style: FalletterTextStyle.body4.copyWith(
                              color: FalletterColor.gray500,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            timeago.format(post.createdAt, locale: 'ko'),
                            style: FalletterTextStyle.body4.copyWith(
                              color: FalletterColor.gray500,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '댓글 ${post.comments.length}개',
                            style: FalletterTextStyle.body4.copyWith(
                              color: FalletterColor.white,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.of(
            context,
            rootNavigator: true,
          ).push(
            MaterialPageRoute(
              builder: (_) => const PostPage(),
            ),
          );

          if (result != null) {
            if (result is Map<String, bool> && result['deleted'] == true) {
              await _refresh();
            } else if (result is Map<String, dynamic> &&
                result['modified'] == true) {
              await _refresh();
            }
          }
        },
        backgroundColor: Colors.transparent,
        elevation: 0,
        child: Container(
          width: fabSize,
          height: fabSize,
          decoration: BoxDecoration(
            gradient: themeColors.button,
            shape: BoxShape.circle,
          ),
          child: const Icon(Symbols.add, fill: 1, color: FalletterColor.black),
        ),
      ),
    );
  }
}
