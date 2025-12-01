import 'package:falletter/core/constants/color.dart';
import 'package:falletter/core/constants/text_style.dart';
import 'package:falletter/core/providers/theme_provider.dart';
import 'package:falletter/core/theme/theme_colors.dart';
import 'package:falletter/presentation/my_page/components/reusable_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class BrickHistoryBox extends ConsumerWidget {
  final String title;
  final String? question;
  final DateTime createdAt;
  final int amount;

  const BrickHistoryBox({
    super.key,
    required this.title,
    required this.question,
    required this.createdAt,
    required this.amount,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedTheme = ref.watch(themeProvider);
    final themeColors = appThemeColors[selectedTheme]!;

    final Gradient textGradient = themeColors.text;
    final Color amountColor = FalletterColor.error;

    final double boxHeight = question != null ? 93 : 80;

    return ReusableLetterBox(
      height: boxHeight,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title, style: FalletterTextStyle.subTitle2),
            amount >= 0
                ? ShaderMask(
              shaderCallback: (bounds) {
                return textGradient.createShader(
                  Rect.fromLTWH(0, 0, bounds.width, bounds.height),
                );
              },
              child: Text(
                '+$amount',
                style: FalletterTextStyle.subTitle2.copyWith(
                  color: Colors.white,
                ),
              ),
            )
                : Text(
              '$amount',
              style: FalletterTextStyle.subTitle2.copyWith(
                color: amountColor,
              ),
            ),
          ],
        ),
        if (question != null)
          Padding(
            padding: const EdgeInsets.only(top: 6),
            child: Text(
              question!,
              style: FalletterTextStyle.body4.copyWith(
                color: FalletterColor.gray400,
              ),
            ),
          ),
        const SizedBox(height: 4),
        Text(
          DateFormat('yyyy-MM-dd HH:mm').format(createdAt),
          style: FalletterTextStyle.body4.copyWith(
            color: FalletterColor.gray400,
          ),
        ),
      ],
    );
  }
}