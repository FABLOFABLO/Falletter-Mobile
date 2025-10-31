import 'package:falletter/core/constants/color.dart';
import 'package:falletter/core/constants/text_style.dart';
import 'package:falletter/core/providers/theme_provider.dart';
import 'package:falletter/core/theme/theme_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CustomElevatedButton extends ConsumerWidget {
  final VoidCallback? onPressed;
  final double? height;
  final double? width;
  final Gradient? gradient;
  final Color? textColor;
  final Widget child;

  const CustomElevatedButton({
    super.key,
    this.onPressed,
    this.height,
    this.width,
    this.gradient,
    this.textColor,
    required this.child,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bool isEnabled = onPressed != null;
    final selectedTheme = ref.watch(themeProvider);
    final themeColors = appThemeColors[selectedTheme]!;

    return Container(
      width: width,
      height: height ?? 52,
      decoration: BoxDecoration(
        gradient:
            isEnabled
                ? (gradient ??
                    themeColors.button)
                : FalletterGradient.horizontal([
                  FalletterColor.gray900,
                  FalletterColor.gray900,
                ]),
        borderRadius: BorderRadius.circular(8),
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          surfaceTintColor: Colors.transparent,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        ),
        child: DefaultTextStyle(
          style: FalletterTextStyle.button.copyWith(
            color:
                isEnabled
                    ? (textColor ?? FalletterColor.middleBlack)
                    : FalletterColor.gray500,
          ),
          textAlign: TextAlign.center,
          child: child,
        ),
      ),
    );
  }
}
