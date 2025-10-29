import 'package:falletter/core/constants/color.dart';
import 'package:falletter/core/providers/theme_provider.dart';
import 'package:falletter/core/theme/theme_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';

class SendButton extends ConsumerWidget {
  final bool isEnabled;
  final VoidCallback? onPressed;

  const SendButton({
    super.key,
    required this.isEnabled,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedTheme = ref.watch(themeProvider);
    final themeColors = appThemeColors[selectedTheme]!;

    return GestureDetector(
      onTap: isEnabled ? onPressed : null,
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: isEnabled ? null : FalletterColor.middleBlack,
          gradient: isEnabled
              ? themeColors.button
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