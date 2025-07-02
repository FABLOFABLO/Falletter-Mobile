import 'package:falletter/core/constants/color.dart';
import 'package:falletter/core/constants/text_style.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';

class LetterModal extends StatelessWidget {
  final String dear;
  final String content;
  final String bottom;
  final VoidCallback onClose;

  const LetterModal({
    super.key,
    required this.dear,
    required this.content,
    required this.bottom,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 편지 박스
          Container(
            decoration: BoxDecoration(
              gradient: FalletterGradient.horizontal(FalletterColor.blueGradient),
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.all(2),
            child: Container(
              decoration: BoxDecoration(
                color: FalletterColor.white,
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Center(
                    child: Text(
                      dear,
                      style: FalletterTextStyle.body3.copyWith(
                        color: FalletterColor.gray800,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Divider(height: 1, color: FalletterColor.gray100),
                  const SizedBox(height: 12),
                  Text(
                    content,
                    style: FalletterTextStyle.body3.copyWith(
                      color: FalletterColor.middleBlack,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Divider(height: 1, color: FalletterColor.gray100),
                  const SizedBox(height: 12),
                  Center(
                    child: Text(
                      bottom,
                      style: FalletterTextStyle.body3.copyWith(
                        color: FalletterColor.gray800,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: GestureDetector(
              onTap: onClose,
              child: Container(
                width: screenWidth * 0.13,
                height: screenWidth * 0.13,
                decoration: const BoxDecoration(
                  color: FalletterColor.gray900,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Symbols.close, color: FalletterColor.gray100),
              ),
            ),
          ),
        ],
      ),
    );
  }
}