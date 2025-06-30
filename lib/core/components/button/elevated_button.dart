import 'package:falletter/core/constants/color.dart';
import 'package:falletter/core/constants/text_style.dart';
import 'package:flutter/material.dart';

class CustomElevatedButton extends StatelessWidget {
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
  Widget build(BuildContext context) {
    final bool isEnabled = onPressed != null;

    return Container(
      width: width,
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
