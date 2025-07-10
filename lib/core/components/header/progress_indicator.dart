import 'package:falletter/core/constants/color.dart';
import 'package:falletter/core/constants/text_style.dart';
import 'package:flutter/material.dart';

class ProgressHeader extends StatelessWidget {
  final int currentIndex;
  final int totalCount;

  const ProgressHeader({
    super.key,
    required this.currentIndex,
    required this.totalCount,
  });

  @override
  Widget build(BuildContext context) {
    final progress = currentIndex / totalCount;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 70),
      child: Row(
        children: [
          Expanded(
            child: Stack(
              children: [
                Container(
                  height: 12,
                  decoration: BoxDecoration(
                    color: FalletterColor.middleBlack,
                    borderRadius: BorderRadius.circular(100),
                  ),
                ),
                FractionallySizedBox(
                  widthFactor: progress,
                  child: Container(
                    height: 12,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [
                          Color(0xFF86FBFF),
                          Color(0xFF93AAFF),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(100),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Text(
            '$currentIndex',
            style: FalletterTextStyle.button,
          ),
          Text(
            '/$totalCount',
            style: FalletterTextStyle.button.copyWith(
              color: FalletterColor.gray600,
            ),
          ),
        ],
      ),
    );
  }
}