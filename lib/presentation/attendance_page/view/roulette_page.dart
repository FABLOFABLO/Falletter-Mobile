import 'package:falletter/presentation/attendance_page/view/roulette_reward_page.dart';
import 'package:falletter/presentation/attendance_page/widget/roulette.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:falletter/core/components/text/gradient_text.dart';
import 'package:falletter/core/constants/text_style.dart';
import 'package:falletter/core/theme/theme_colors.dart';
import 'package:falletter/core/providers/theme_provider.dart';

class RoulettePage extends ConsumerWidget {
  const RoulettePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.watch(themeProvider);
    final themeColors = appThemeColors[theme]!;

    return Scaffold(
      backgroundColor: backgroundOverlay,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 173),
            Text('누군지 알 수 있는', style: FalletterTextStyle.title3),
            GradientText(
              '출석체크 랜덤 룰렛',
              style: FalletterTextStyle.title1,
              gradient: themeColors.text,
            ),
            const SizedBox(height: 32),
            const Center(child: RouletteWheel()),
          ],
        ),
      ),
    );
  }
}