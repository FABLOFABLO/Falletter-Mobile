import 'package:falletter/core/constants/color.dart';
import 'package:falletter/core/constants/text_style.dart';
import 'package:flutter/material.dart';

class CustomElevatedButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final double? height;
  final double? width;
  final Gradient? gradient;
  final Color? textColor;

  const CustomElevatedButton({
    super.key,
    required this.text,
    this.onPressed,
    this.height,
    this.width,
    this.gradient,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    final bool isEnabled = onPressed != null;

    return Container(
      width: width ?? 310,
      height: height ?? 52,
      decoration: BoxDecoration(
        gradient:
            isEnabled
                ? (gradient ??
                    FalletterGradient.horizontal(FalletterColor.blueGradient))
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
        child: Text(
          text,
          style: FalletterTextStyle.button.copyWith(
            color:
                isEnabled
                    ? (textColor ?? FalletterColor.middleBlack)
                    : FalletterColor.gray900,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
