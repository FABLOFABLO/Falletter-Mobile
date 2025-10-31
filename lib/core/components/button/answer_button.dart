import 'package:falletter/core/components/button/elevated_button.dart';
import 'package:falletter/core/constants/color.dart';
import 'package:falletter/core/providers/theme_provider.dart';
import 'package:falletter/core/theme/theme_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AnswerButton extends ConsumerWidget {
  final String label;
  final bool isSelected;
  final void Function() onPressed;

  const AnswerButton({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedTheme = ref.watch(themeProvider);
    final themeColors = appThemeColors[selectedTheme]!;
    final gradient =
        isSelected
            ? themeColors.answerButton
            : FalletterGradient.horizontal([
              FalletterColor.middleBlack,
              FalletterColor.middleBlack,
            ]);
    return CustomElevatedButton(
      onPressed: onPressed,
      gradient: gradient,
      textColor: isSelected ? null : FalletterColor.white,
      child: Text(label),
    );
  }
}
