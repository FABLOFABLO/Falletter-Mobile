import 'package:flutter/material.dart';
import 'package:falletter/core/constants/color.dart';
import 'package:falletter/core/constants/text_style.dart';

class SelectButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final double? height;
  final double? width;
  final Widget child;
  final bool isSelected;
  final bool showOutline;

  const SelectButton({
    super.key,
    this.onPressed,
    this.height,
    this.width,
    required this.child,
    this.isSelected = false,
    this.showOutline = false,
  });

  @override
  Widget build(BuildContext context) {
    final isOutline = !isSelected && showOutline;

    final textColor = isSelected ? FalletterColor.black : FalletterColor.white;

    final innerDecoration = BoxDecoration(
      borderRadius: BorderRadius.circular(8),
      color: isSelected ? null : FalletterColor.middleBlack,
      gradient:
          isSelected
              ? const LinearGradient(colors: FalletterColor.blueGradient)
              : null,
    );

    final outlineDecoration =
        isOutline
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
      padding: isOutline ? const EdgeInsets.all(2) : null,
      child: Container(
        decoration: innerDecoration,
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
            style: FalletterTextStyle.title3.copyWith(color: textColor),
            child: child,
          ),
        ),
      ),
    );
  }
}
