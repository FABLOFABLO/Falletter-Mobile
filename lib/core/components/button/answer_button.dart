import 'package:falletter/core/components/button/elevated_button.dart';
import 'package:falletter/core/constants/color.dart';
import 'package:falletter/core/constants/text_style.dart';
import 'package:falletter/core/providers/theme_provider.dart';
import 'package:falletter/core/theme/theme_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AnswerButton extends ConsumerWidget {
  final String label;
  final bool isSelected;
  final void Function() onPressed;
  final bool showBorder;
  final Gradient? borderGradient;

  const AnswerButton({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onPressed,
    this.showBorder = false,
    this.borderGradient,
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
    final hasBorder = showBorder && isSelected;
    final textColor = isSelected ? FalletterColor.black : FalletterColor.white;

    return Container(
      height: 80,
      decoration: BoxDecoration(
        gradient: hasBorder ? borderGradient : null,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: hasBorder ? const EdgeInsets.all(2) : EdgeInsets.zero,
      child: CustomElevatedButton(
        onPressed: onPressed,
        gradient: gradient,
        textColor: textColor,
        child: Text(
          label,
          style: FalletterTextStyle.title3.copyWith(
            color: textColor,
          ),
        ),
      ),
    );
  }
}
