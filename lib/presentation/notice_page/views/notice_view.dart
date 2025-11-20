import 'package:falletter/core/constants/color.dart';
import 'package:falletter/core/constants/text_style.dart';
import 'package:falletter/core/providers/item_count_provider.dart';
import 'package:falletter/core/providers/question_providers.dart';
import 'package:falletter/core/providers/theme_provider.dart';
import 'package:falletter/core/theme/theme_colors.dart';
import 'package:falletter/core/utils/gender_format_utils.dart';
import 'package:falletter/core/utils/time_utils.dart';
import 'package:falletter/presentation/notice_page/widget/notice_box.dart';
import 'package:falletter/presentation/notice_page/views/notice_detail_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

class NoticePage extends ConsumerStatefulWidget {
  const NoticePage({super.key});

  @override
  ConsumerState<NoticePage> createState() => _NoticePageState();
}

class _NoticePageState extends ConsumerState<NoticePage> {
  final Set<int> clickedIndexes = {};

  @override
  Widget build(BuildContext context) {
    final theme = ref.watch(themeProvider);
    final themeColors = appThemeColors[theme]!;

    final itemCounts = ref.watch(itemCountProvider);
    final brickCount = itemCounts['brick'] ?? 0;

    final answersAsync = ref.watch(chosenAnswersProvider);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    SvgPicture.asset(
                      themeColors.brickSvg,
                      width: 38,
                      height: 26,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      '$brickCount개',
                      style: FalletterTextStyle.body1,
                    ),
                  ],
                ),
              ),

              Expanded(
                child: answersAsync.when(
                  data: (answers) {
                    if (answers.isEmpty) {
                      return const Center(
                        child: Text(
                          "아직 받은 질문이 없습니다.",
                          style: TextStyle(color: FalletterColor.white),
                        ),
                      );
                    }

                    return ListView.separated(
                      padding: EdgeInsets.zero,
                      itemCount: answers.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final item = answers[index];
                        final isClicked = clickedIndexes.contains(index);

                        final localTime = item.createdAt.toLocal();

                        return NoticeBox(
                          title: genderFormat(item.schoolNumber, item.gender),
                          subtitle: item.question,
                          time: formatTime(localTime),
                          isClicked: isClicked,
                          onTap: () {
                            setState(() => clickedIndexes.add(index));

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => NoticeDetailView(
                                  title: item.question,
                                  emoji: item.emoji,
                                  targetUserId: item.targetUserId,
                                  name: item.name,
                                  /*schoolNumber: item.schoolNumber,
                                  gender: item.gender,
                                  createdAt: localTime,
                                  */
                                  /*questionText: item.question,
                                  writerUserId: item.writerUserId,
                                  questionId: item.questionId,*/
                                ),
                              ),
                            );
                          },
                        );
                      },
                    );
                  },
                  loading: () {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: Colors.white,
                      ),
                    );
                  },
                  error: (error, stackTrace) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "알림을 불러오지 못했습니다.",
                            style: TextStyle(color: Colors.white),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            error.toString(),
                            style: const TextStyle(
                              color: Colors.red,
                              fontSize: 12,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () {
                              ref.invalidate(chosenAnswersProvider);
                            },
                            child: const Text('다시 시도'),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}