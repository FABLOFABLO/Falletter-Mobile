import 'package:falletter/core/components/button/elevated_button.dart';
import 'package:falletter/core/constants/text_style.dart';
import 'package:falletter/presentation/sign_up/view/grade_page.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:falletter/core/constants/color.dart';
import 'package:falletter/core/components/header/header.dart';
import 'package:falletter/core/components/button/gender_button.dart';
import 'package:falletter/core/components/header/sign_up_indicator.dart';

class GenderPage extends StatefulWidget {
  const GenderPage({super.key});

  @override
  State<GenderPage> createState() => _GenderPageState();
}

class _GenderPageState extends State<GenderPage> {
  String? selected;

  void _goToNextStep() {
    SignUpFlow.nextStep();
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const GradePage()),
    );
  }

  @override
  void initState() {
    super.initState();
    SignUpFlow.currentStep = 1;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const SafeArea(
            child: Header(
              showBackButton: true,
              rightWidget: SignUpIndicator(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text('성별을 선택해주세요.', style: FalletterTextStyle.title2),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: GenderButton(
                          label: '남성',
                          icon: Symbols.man,
                          iconColor: FalletterColor.blueGradient[0],
                          isSelected: selected == '남성',
                          onTap: () => setState(() => selected = '남성'),
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: GenderButton(
                          label: '여성',
                          icon: Symbols.woman,
                          iconColor: FalletterColor.pinkGradient[0],
                          isSelected: selected == '여성',
                          onTap: () => setState(() => selected = '여성'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: GenderButton(
                          label: '기타',
                          iconColor: FalletterColor.gray100,
                          isSelected: selected == '기타',
                          onTap: () => setState(() => selected = '기타'),
                          iconWidget: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Symbols.man, color: FalletterColor.gray100, size: 50),
                              Icon(Symbols.woman, color: FalletterColor.gray100, size: 50),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 20),
                      const Expanded(child: SizedBox()),
                    ],
                  ),
                  const Spacer(),
                  const SizedBox(height: 40),
                  CustomElevatedButton(
                    width: double.infinity,
                    onPressed: selected != null ? _goToNextStep : null,
                    child: const Text('다음'),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}