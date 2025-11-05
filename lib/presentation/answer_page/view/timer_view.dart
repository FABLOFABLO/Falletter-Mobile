import 'package:falletter/core/providers/theme_provider.dart';
import 'package:falletter/core/theme/theme_colors.dart';
import 'package:falletter/presentation/answer_page/components/circle_progress.dart';
import 'package:flutter/material.dart';
import 'package:falletter/core/constants/color.dart';
import 'package:falletter/core/constants/text_style.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TimerView extends ConsumerWidget {
  final Duration countdown;
  final Duration initialCountdown;

  const TimerView({
    super.key,
    required this.countdown,
    required this.initialCountdown,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedTheme = ref.watch(themeProvider);
    final themeColors = appThemeColors[selectedTheme]!;
    final minutes = countdown.inMinutes.remainder(60).toString().padLeft(2, '0');
    final hours = countdown.inHours.toString().padLeft(2, '0');
    final progress = initialCountdown.inSeconds > 0
        ? countdown.inSeconds / initialCountdown.inSeconds
        : 0.0;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('다음 질문까지 남은 시간',
              style: FalletterTextStyle.button.copyWith(
                color: FalletterColor.gray200,
              )),
          const SizedBox(height: 20),
          Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: 200,
                height: 200,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: FalletterColor.middleBlack,
                ),
              ),
              CustomPaint(
                size: const Size(200, 200),
                painter: CircleProgress(
                  progress: progress,
                  strokeWidth: 10,
                  gradient: themeColors.timer,
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
                  style: FalletterTextStyle.title1.copyWith(
                    color: FalletterColor.gray50,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}