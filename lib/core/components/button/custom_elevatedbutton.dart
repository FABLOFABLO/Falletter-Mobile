import 'package:falletter/core/constants/color.dart';
import 'package:falletter/core/constants/text_style.dart';
import 'package:flutter/material.dart';

class CustomElevatedButton extends StatelessWidget {
  final String? text;
  final VoidCallback? onPressed;
  final double? height;
  final double? width;
  final Gradient? gradient;
  final Color? textColor;
  final Widget? content;
  final Widget? leading;
  final Widget? trailing;

  const CustomElevatedButton({
    super.key,
    this.text,
    this.onPressed,
    this.height,
    this.width,
    this.gradient,
    this.textColor,
    this.content,
    this.leading,
    this.trailing,
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
                    : FalletterColor.gray900,
          ),
          textAlign: TextAlign.center,
          child: content ?? _defaultContent(),
        ),
      ),
    );
  }

  Widget _defaultContent() {
    if (text == null && leading == null && trailing == null) {
      return const Text("Button");
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (leading != null) ...[leading!, const SizedBox(width: 8)],
        if (text != null) Flexible(child: Text(text!)),
        if (trailing != null) ...[const SizedBox(width: 8), trailing!],
      ],
    );
  }
}
