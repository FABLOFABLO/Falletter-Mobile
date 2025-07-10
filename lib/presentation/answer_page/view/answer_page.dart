import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:falletter/core/constants/color.dart';
import 'package:falletter/core/constants/text_style.dart';
import 'package:falletter/core/components/button/elevated_button.dart';
import 'package:falletter/core/components/header/progress_indicator.dart';
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

  void goToNextQuestion() {
    final current = ref.read(currentQuestionIndexProvider);
    final total = ref.read(totalQuestionsProvider);

    if (current + 1 < total) {
      ref.read(currentQuestionIndexProvider.notifier).state++;
      ref.read(selectedIndexProvider.notifier).state = null;
    } else {
      ref.read(answerStateProvider.notifier).state = AnswerState.waiting;
      startCountdown();
    }
  }

  void startCountdown() {
    _timer?.cancel();
    initialCountdown = countdown;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (countdown.inSeconds > 0) {
        setState(() {
          countdown -= const Duration(seconds: 1);
        });
      } else {
        timer.cancel();
        ref.read(answerStateProvider.notifier).state = AnswerState.answering;
        ref.read(selectedIndexProvider.notifier).state = null;
        setState(() {
          countdown = initialCountdown;
        });
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
    final currentIndex = ref.watch(currentQuestionIndexProvider);
    final total = ref.watch(totalQuestionsProvider);

    return Scaffold(
      body: answerState == AnswerState.waiting
          ? _buildTimerView()
          : _buildQuestionView(currentIndex, total),
    );
  }

  Widget _buildQuestionView(int currentIndex, int total) {
    final selectedIndex = ref.watch(selectedIndexProvider);
    final questions = ref.watch(questionsProvider);
    final options = ref.watch(optionsProvider);
    final question = questions[currentIndex];
    final emojis = ref.watch(questionEmojisProvider);
    final emoji = emojis[currentIndex];

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
              emoji,
              style: const TextStyle(fontSize: 100),
            ),
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
                      _buildAnswerButton(index: i * 2, label: options[i * 2], isSelected: selectedIndex == i * 2),
                      _buildAnswerButton(index: i * 2 + 1, label: options[i * 2 + 1], isSelected: selectedIndex == i * 2 + 1),
                    ],
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 32),
        TextButton(
          onPressed: goToNextQuestion,
          child: Text(
            '건너뛰기',
            style: FalletterTextStyle.body3.copyWith(color: FalletterColor.gray300),
          ),
        ),
      ],
    );
  }

  Widget _buildAnswerButton({required int index, required String label, required bool isSelected}) {
    final gradient = isSelected
        ? FalletterGradient.horizontal(FalletterColor.blueGradient)
        : FalletterGradient.horizontal([
      FalletterColor.middleBlack,
      FalletterColor.middleBlack,
    ]);

    return Expanded(
      child: Padding(
        padding: EdgeInsets.only(right: index % 2 == 0 ? 12 : 0, left: index % 2 == 1 ? 12 : 0),
        child: CustomElevatedButton(
          onPressed: () {
            ref.read(selectedIndexProvider.notifier).state = index;
            Future.delayed(const Duration(milliseconds: 200), goToNextQuestion);
          },
          gradient: gradient,
          textColor: isSelected ? null : FalletterColor.white,
          child: Text(label),
        ),
      ),
    );
  }

  Widget _buildTimerView() {
    final minutes = countdown.inMinutes.remainder(60).toString().padLeft(2, '0');
    final hours = countdown.inHours.toString().padLeft(2, '0');
    final progress = initialCountdown.inSeconds > 0
        ? countdown.inSeconds / initialCountdown.inSeconds
        : 0.0;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '다음 질문까지 남은 시간',
            style: FalletterTextStyle.button.copyWith(color: FalletterColor.gray200),
          ),
          const SizedBox(height: 40),
          Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: FalletterGradient.horizontal([
                    FalletterColor.middleBlack,
                    FalletterColor.middleBlack,
                  ]),
                ),
              ),
              CustomPaint(
                size: const Size(200, 200),
                painter: CircularProgressPainter(
                  progress: progress,
                  strokeWidth: 10,
                  gradient: FalletterGradient.vertical(FalletterColor.blueGradient),
                ),
              ),
              Container(
                width: 190,
                height: 190,
                decoration: const BoxDecoration(
                  color: FalletterColor.middleBlack,
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Text(
                  '$hours:$minutes',
                  style: FalletterTextStyle.title1.copyWith(color: FalletterColor.gray50),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class CircularProgressPainter extends CustomPainter {
  final double progress;
  final double strokeWidth;
  final Gradient gradient;

  CircularProgressPainter({
    required this.progress,
    required this.strokeWidth,
    required this.gradient,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;
    final rect = Rect.fromCircle(center: center, radius: radius);

    final paint = Paint();
      paint.shader = gradient.createShader(rect);
      paint.strokeWidth = strokeWidth;
      paint.style = PaintingStyle.stroke;
      paint.strokeCap = StrokeCap.round;

    const startAngle = -pi / 2;
    final sweepAngle = -2 * pi * progress;

    canvas.drawArc(
      rect,
      startAngle,
      sweepAngle,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return oldDelegate is CircularProgressPainter && oldDelegate.progress != progress;
  }
}