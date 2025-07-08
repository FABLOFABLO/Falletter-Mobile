import 'package:falletter/presentation/main_page/view/post_detail_page.dart';
import 'package:falletter/presentation/main_page/view/post_page.dart';
import 'package:flutter/material.dart';
import 'package:falletter/core/constants/color.dart';
import 'package:falletter/core/constants/text_style.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int currentIndex = 0;
  List<Map<String, String>> posts = [];

  void onTap(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final fabSize = screenWidth * 0.2;

    return Scaffold(
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 68),
        itemCount: posts.length,
        itemBuilder: (context, index) {
          final post = posts[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: GestureDetector(
              onTap: () async {
                final result = await Navigator.of(context, rootNavigator: true).push<Map<String, dynamic>>(
                  MaterialPageRoute(
                    builder: (_) => PostDetailPage(
                      title: post['title'] ?? '',
                      content: post['content'] ?? '',
                      nickname: 'Nickname',
                      time: 'Time',
                    ),
                  ),
                );

                if (result != null) {
                  setState(() {
                    if (result['deleted'] == true) {
                      posts.removeAt(index);
                    }
                    else {
                      posts[index] = {
                        ...posts[index],
                        'title': result['title'] ?? posts[index]['title'] ?? '',
                        'content': result['content'] ?? posts[index]['content'] ?? '',
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
                          'Time',
                          style: FalletterTextStyle.body4.copyWith(
                            color: FalletterColor.gray500,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '댓글 0개',
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
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const PostPage()),
          );

          if (result != null && result is Map<String, String>) {
            setState(() {
              posts.insert(0, result);
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