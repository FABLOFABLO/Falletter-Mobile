import 'package:falletter/core/components/button/elevated_button.dart';
import 'package:falletter/core/constants/color.dart';
import 'package:falletter/core/constants/text_style.dart';
import 'package:flutter/material.dart';

class DefaultModal extends StatelessWidget {
  final String title;
  final String description;
  final String leftText;
  final String rightText;
  final VoidCallback onLeftPressed;
  final VoidCallback onRightPressed;

  const DefaultModal({
    super.key,
    required this.title,
    required this.description,
    required this.leftText,
    required this.rightText,
    required this.onLeftPressed,
    required this.onRightPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: FalletterColor.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      insetPadding: const EdgeInsets.all(20),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: FalletterTextStyle.subTitle2.copyWith(
                color: FalletterColor.gray900,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              description,
              style: FalletterTextStyle.body3.copyWith(
                color: FalletterColor.gray800,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: CustomElevatedButton(
                    onPressed: onLeftPressed,
                    gradient: const LinearGradient(
                      colors: [FalletterColor.gray200, FalletterColor.gray200],
                    ),
                    child: Text(leftText),
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: CustomElevatedButton(
                    onPressed: onRightPressed,
                    gradient: const LinearGradient(
                      colors: [FalletterColor.error, FalletterColor.error],
                    ),
                    child: Text(rightText),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}