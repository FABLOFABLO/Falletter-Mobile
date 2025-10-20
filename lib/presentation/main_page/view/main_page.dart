import 'package:falletter/core/providers/comment_provider.dart';
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
  List<Map<String, dynamic>> posts = [];

  @override
  void initState() {
    super.initState();
    timeago.setLocaleMessages('ko', timeago.KoMessages());
  }

  Future<void> _refresh() async {
    setState(() {
    });
    await Future.delayed(const Duration(seconds: 1));
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final fabSize = screenWidth * 0.2;
    final commentState = ref.watch(commentProvider);

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
            final commentCount = commentState[post['id']]?.length ?? 0;
            return Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: GestureDetector(
                onTap: () async {
                  final result = await Navigator.of(
                    context,
                    rootNavigator: true,
                  ).push<Map<String, dynamic>>(
                    MaterialPageRoute(
                      builder:
                          (_) => PostDetailPage(
                            postId: post['id'],
                            title: post['title'] ?? '',
                            content: post['content'] ?? '',
                            nickname: 'Nickname',
                            time: post['time'] ?? DateTime.now(),
                          ),
                    ),
                  );

                  if (result != null) {
                    setState(() {
                      if (result['deleted'] == true) {
                        posts.removeAt(index);
                      } else {
                        posts[index] = {
                          ...posts[index],
                          'title': result['title'] ?? posts[index]['title'] ?? '',
                          'content':
                              result['content'] ?? posts[index]['content'] ?? '',
                        };
                      }
                    });
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
                        post['title'] ?? '',
                        overflow: TextOverflow.ellipsis,
                        style: FalletterTextStyle.subTitle2.copyWith(
                          color: FalletterColor.white,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        post['content'] ?? '',
                        overflow: TextOverflow.ellipsis,
                        style: FalletterTextStyle.body4.copyWith(
                          color: FalletterColor.gray400,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Text(
                            'Nickname',
                            style: FalletterTextStyle.body4.copyWith(
                              color: FalletterColor.gray500,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            timeago.format(
                              post['time'] ?? DateTime.now(),
                              locale: 'ko',
                            ),
                            style: FalletterTextStyle.body4.copyWith(
                              color: FalletterColor.gray500,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '댓글 $commentCount개',
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
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const PostPage()),
          );

          if (result != null && result is Map<String, String>) {
            setState(() {
              posts.insert(0, {
                'id': DateTime.now().millisecondsSinceEpoch,
                'title': result['title'],
                'content': result['content'],
                'time': DateTime.now(),
              });
            });
          }
        },
        backgroundColor: Colors.transparent,
        elevation: 0,
        child: Container(
          width: fabSize,
          height: fabSize,
          decoration: const BoxDecoration(
            gradient: LinearGradient(colors: FalletterColor.blueGradient),
            shape: BoxShape.circle,
          ),
          child: const Icon(Symbols.add, fill: 1, color: FalletterColor.black),
        ),
      ),
    );
  }
}
