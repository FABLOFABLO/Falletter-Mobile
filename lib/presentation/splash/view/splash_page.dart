import 'package:falletter/core/components/button/elevated_button.dart';
import 'package:falletter/core/components/text/gradient_text.dart';
import 'package:falletter/core/constants/color.dart';
import 'package:falletter/core/constants/text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(child: SvgPicture.asset('assets/icon/onBoarding.svg')),
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
                    onTap: () {},
                    child: Text('회원가입', style: FalletterTextStyle.body3),
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
                gradient: FalletterGradient.horizontal(
                  FalletterColor.blueGradient,
                ),
              ),
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}
