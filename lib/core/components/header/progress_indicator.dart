import 'package:falletter/core/constants/color.dart';
import 'package:falletter/core/constants/text_style.dart';
import 'package:falletter/core/providers/theme_provider.dart';
import 'package:falletter/core/theme/theme_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProgressHeader extends ConsumerWidget {
  final int currentIndex;
  final int totalCount;

  const ProgressHeader({
    super.key,
    required this.currentIndex,
    required this.totalCount,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final progress = currentIndex / totalCount;
    final selectedTheme = ref.watch(themeProvider);
    final themeColors = appThemeColors[selectedTheme]!;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 27),
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
                      gradient: themeColors.progressIndicator,
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