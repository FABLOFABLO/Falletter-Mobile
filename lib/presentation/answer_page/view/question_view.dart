import 'package:falletter/core/components/button/answer_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:falletter/core/constants/color.dart';
import 'package:falletter/core/constants/text_style.dart';
import 'package:falletter/core/components/header/progress_indicator.dart';
import 'package:falletter/core/providers/question_providers.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';

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
    final selectedQuestions = ref.watch(selectedQuestionsProvider);
    final options = ref.watch(currentQuestionOptionsProvider);

    if (selectedQuestions.isEmpty || currentIndex >= selectedQuestions.length) {
      return const Center(
        child: CircularProgressIndicator(
          color: FalletterColor.white,
        ),
      );
    }

    final question = selectedQuestions[currentIndex];

    void handleAnswer(int index) async {
      if (index >= options.length) return;

      final selectedStudent = options[index];
      ref.read(selectedIndexProvider.notifier).state = index;

      if (selectedStudent.id > 0) {
        await ref
            .read(submitAnswerProvider.notifier)
            .submitAnswer(
              question.id,
              selectedStudent.id,
            );
      }

      await Future.delayed(const Duration(milliseconds: 200));
      ref.read(selectedIndexProvider.notifier).state = null;
      onNext();
    }

    void handleSkip() {
      ref.read(selectedIndexProvider.notifier).state = null;
      onNext();
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
            child: Text(
              question.emoji,
              style: const TextStyle(fontSize: 100),
            ),
          ),
        ),
        const SizedBox(height: 32),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Text(
            question.question,
            style: FalletterTextStyle.title2,
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: 32),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child:
              options.isEmpty
                  ? const Center(
                    child: CircularProgressIndicator(
                      color: FalletterColor.white,
                    ),
                  )
                  : Column(
                    children: [
                      for (int i = 0; i < 2; i++)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: Row(
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 6),
                                  child: AnswerButton(
                                    label: options[i * 2].name,
                                    isSelected: selectedIndex == i * 2,
                                    onPressed: () => handleAnswer(i * 2),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 6),
                                  child: AnswerButton(
                                    label: options[i * 2 + 1].name,
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
          onPressed: handleSkip,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '건너뛰기',
                style: FalletterTextStyle.body3.copyWith(
                  color: FalletterColor.gray300,
                ),
              ),
              const Icon(
                Symbols.keyboard_double_arrow_right,
                color: FalletterColor.gray300,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
