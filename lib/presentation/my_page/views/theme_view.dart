import 'package:falletter/core/components/button/gender_button.dart';
import 'package:falletter/core/components/header/header.dart';
import 'package:falletter/core/constants/color.dart';
import 'package:falletter/core/constants/text_style.dart';
import 'package:falletter/core/providers/theme_provider.dart';
import 'package:falletter/core/theme/theme_colors.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ThemeView extends ConsumerStatefulWidget {
  const ThemeView({super.key});

  @override
  ConsumerState<ThemeView> createState() => _ThemeViewState();
}

class _ThemeViewState extends ConsumerState<ThemeView> {
  @override
  Widget build(BuildContext context) {
    final selectedTheme = ref.watch(themeProvider);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const Header(showBackButton: true),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '테마 설정',
                    style: FalletterTextStyle.title2,
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: GenderButton(
                          label: 'BLUE',
                          gradient: FalletterGradient.horizontal(
                            FalletterColor.blueGradient,
                          ),
                          icon: Symbols.circle,
                          isSelected: selectedTheme == AppTheme.BLUE,
                          onTap: () =>
                          ref.read(themeProvider.notifier).state = AppTheme.BLUE,
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: GenderButton(
                          label: 'PINK',
                          gradient: FalletterGradient.horizontal(
                            FalletterColor.pinkGradient,
                          ),
                          icon: Symbols.circle,
                          isSelected: selectedTheme == AppTheme.PINK,
                          onTap: () =>
                          ref.read(themeProvider.notifier).state = AppTheme.PINK,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: GenderButton(
                          label: 'SILVER',
                          gradient: FalletterGradient.horizontal(
                            FalletterColor.silverGradient,
                          ),
                          icon: Symbols.circle,
                          isSelected: selectedTheme == AppTheme.SILVER,
                          onTap: () =>
                          ref.read(themeProvider.notifier).state = AppTheme.SILVER,
                        ),
                      ),
                      const Expanded(child: SizedBox()),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}