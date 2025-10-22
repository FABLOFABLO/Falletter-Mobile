import 'package:falletter/core/components/button/answer_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:falletter/core/constants/color.dart';
import 'package:falletter/core/constants/text_style.dart';
import 'package:falletter/core/components/header/progress_indicator.dart';
import 'package:falletter/core/providers/question_providers.dart';

class QuestionView extends ConsumerWidget {
  final VoidCallback onNext;

  const QuestionView({
    super.key,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(currentQuestionIndexProvider);
    final total = ref.watch(totalQuestionsProvider);
    final selectedIndex = ref.watch(selectedIndexProvider);
    final questions = ref.watch(questionsProvider);
    final options = ref.watch(optionsProvider);
    final question = questions[currentIndex];
    final emojis = ref.watch(questionEmojisProvider);
    final emoji = emojis[currentIndex];

    void handleAnswer(int index) {
      ref.read(selectedIndexProvider.notifier).state = index;
      Future.delayed(const Duration(milliseconds: 200), onNext);
    }

    return Column(
      children: [
        ProgressHeader(currentIndex: currentIndex + 1, totalCount: total),
        const SizedBox(height: 40),
        Container(
          width: 160,
          height: 160,
          decoration: const BoxDecoration(
            color: FalletterColor.middleBlack,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(emoji, style: const TextStyle(fontSize: 100)),
          ),
        ),
        const SizedBox(height: 32),
        Text(question, style: FalletterTextStyle.title2),
        const SizedBox(height: 32),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              for (int i = 0; i < 2; i++)
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(right: 12),
                          child: AnswerButton(
                            label: options[i * 2],
                            isSelected: selectedIndex == i * 2,
                            onPressed: () => handleAnswer(i * 2),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 12),
                          child: AnswerButton(
                            label: options[i * 2 + 1],
                            isSelected: selectedIndex == i * 2 + 1,
                            onPressed: () => handleAnswer(i * 2 + 1),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 32),
        TextButton(
          onPressed: onNext,
          child: Text(
            '건너뛰기',
            style: FalletterTextStyle.body3.copyWith(
              color: FalletterColor.gray300,
            ),
          ),
        ),
      ],
    );
  }
}
