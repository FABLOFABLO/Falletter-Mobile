import 'package:falletter/core/components/button/elevated_button.dart';
import 'package:falletter/core/components/text/gradient_text.dart';
import 'package:falletter/core/constants/color.dart';
import 'package:falletter/core/constants/text_style.dart';
import 'package:falletter/core/providers/theme_provider.dart';
import 'package:falletter/core/theme/theme_colors.dart';
import 'package:falletter/presentation/login_page/view/login_page.dart';
import 'package:falletter/presentation/sign_up_page/view/gender_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SplashPage extends ConsumerWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedTheme = ref.watch(themeProvider);
    final themeColors = appThemeColors[selectedTheme]!;

    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: SvgPicture.asset(themeColors.logoSvg),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '아직 계정이 없으신가요? ',
                    style: FalletterTextStyle.body3.copyWith(
                      color: FalletterColor.gray400,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const GenderPage()),
                      );
                    },
                    child: Text(
                      '회원가입',
                      style: FalletterTextStyle.body3,
                    ),
                  ),
                ],
              ),
            ),
            CustomElevatedButton(
              width: MediaQuery.of(context).size.width * 0.86,
              gradient: FalletterGradient.horizontal([
                FalletterColor.middleBlack,
                FalletterColor.middleBlack,
              ]),
              child: GradientText(
                '로그인하기',
                style: FalletterTextStyle.button,
                gradient: themeColors.text,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginPage()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
