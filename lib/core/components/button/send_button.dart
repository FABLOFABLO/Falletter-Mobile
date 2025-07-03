import 'package:falletter/core/constants/color.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';

class SendButton extends StatelessWidget {
  final bool isEnabled;
  final VoidCallback? onPressed;

  const SendButton({
    super.key,
    required this.isEnabled,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isEnabled ? onPressed : null,
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: isEnabled ? null : FalletterColor.middleBlack,
          gradient: isEnabled
              ? FalletterGradient.horizontal(FalletterColor.blueGradient)
              : null,
        ),
        child: Icon(
          Symbols.send,
          fill: 1,
          color: isEnabled ? FalletterColor.middleBlack : FalletterColor.gray800,
        ),
      ),
    );
  }
}