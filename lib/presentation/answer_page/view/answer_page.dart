import 'dart:async';
import 'package:falletter/presentation/answer_page/view/question_view.dart';
import 'package:falletter/presentation/answer_page/view/timer_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:falletter/core/providers/question_providers.dart';

class AnswerPage extends ConsumerStatefulWidget {
  const AnswerPage({super.key});

  @override
  ConsumerState<AnswerPage> createState() => _AnswerPageState();
}

class _AnswerPageState extends ConsumerState<AnswerPage> {
  Duration countdown = const Duration(hours: 4);
  Duration initialCountdown = const Duration(hours: 4);
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(allQuestionsProvider);
      ref.read(allStudentsProvider);

      if (ref.read(answerStateProvider) == AnswerState.waiting) {
        startCountdown();
      }
    });
  }

  void goToNextQuestion() {
    final current = ref.read(currentQuestionIndexProvider);
    final total = ref.read(totalQuestionsProvider);

    if (current + 1 < total) {
      ref.read(currentQuestionIndexProvider.notifier).state++;
      ref.read(selectedIndexProvider.notifier).state = null;
    } else {
      ref.read(answerStateProvider.notifier).state = AnswerState.waiting;
      ref.read(currentQuestionIndexProvider.notifier).state = 0;
      ref.read(selectedIndexProvider.notifier).state = null;
      startCountdown();
    }
  }

  void startCountdown() {
    _timer?.cancel();
    initialCountdown = countdown;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (countdown.inSeconds > 0) {
        setState(() => countdown -= const Duration(seconds: 1));
      } else {
        timer.cancel();
        ref.invalidate(allQuestionsProvider);
        ref.invalidate(allStudentsProvider);
        ref.read(currentQuestionIndexProvider.notifier).state = 0;
        ref.read(answerStateProvider.notifier).state = AnswerState.answering;
        ref.read(selectedIndexProvider.notifier).state = null;
        setState(() => countdown = initialCountdown);
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final answerState = ref.watch(answerStateProvider);

    return Scaffold(
      body: SafeArea(
        child: answerState == AnswerState.waiting
            ? TimerView(
          countdown: countdown,
          initialCountdown: initialCountdown,
        )
            : QuestionView(onNext: goToNextQuestion),
      ),
    );
  }
}