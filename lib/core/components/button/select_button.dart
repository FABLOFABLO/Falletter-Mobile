import 'package:flutter/material.dart';
import 'package:falletter/core/constants/color.dart';
import 'package:falletter/core/constants/text_style.dart';

class SelectButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final double? height;
  final double? width;
  final Widget child;
  final bool showOutline;

  const SelectButton({
    super.key,
    this.onPressed,
    this.height,
    this.width,
    required this.child,
    this.showOutline = false,
  });

  @override
  Widget build(BuildContext context) {
    final outlineDecoration = showOutline
        ? BoxDecoration(
      gradient: const LinearGradient(
        colors: FalletterColor.blueGradient,
      ),
      borderRadius: BorderRadius.circular(8),
    )
        : null;

    return Container(
      width: width,
      height: height,
      decoration: outlineDecoration,
      padding: showOutline ? const EdgeInsets.all(2) : null,
      child: Container(
        decoration: BoxDecoration(
          color: FalletterColor.middleBlack,
          borderRadius: BorderRadius.circular(8),
        ),
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            surfaceTintColor: Colors.transparent,
            elevation: 0,
            padding: const EdgeInsets.all(20),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: DefaultTextStyle(
            style: FalletterTextStyle.title3.copyWith(
              color: FalletterColor.white,
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}