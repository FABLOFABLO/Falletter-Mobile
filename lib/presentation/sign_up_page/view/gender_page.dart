/*
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:falletter/core/providers/signup_provider.dart';
import 'package:falletter/presentation/sign_up_page/view/grade_page.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:falletter/core/constants/color.dart';
import 'package:falletter/core/constants/text_style.dart';
import 'package:falletter/core/components/button/gender_button.dart';
import 'package:falletter/core/components/button/elevated_button.dart';
import 'package:falletter/core/components/header/header.dart';
import 'package:falletter/core/components/header/sign_up_indicator.dart';

class GenderPage extends ConsumerStatefulWidget {
  const GenderPage({super.key});

  @override
  ConsumerState<GenderPage> createState() => _GenderPageState();
}

class _GenderPageState extends ConsumerState<GenderPage> {
  String? selected;

  void _goToNextStep() {
    if (selected != null) {
      late String genderValue;
      switch (selected) {
        case '남성':
          genderValue = 'MALE';
          break;
        case '여성':
          genderValue = 'FEMALE';
          break;
      }

      ref.read(signUpProvider.notifier).setGender(genderValue);
      SignUpFlow.nextStep();
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const GradePage()),
      );
    }
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
            child: Header(showBackButton: true, rightWidget: SignUpIndicator()),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      '성별을 선택해주세요.',
                      style: FalletterTextStyle.title2,
                    ),
                  ),
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
                  const Spacer(),
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
*/

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:falletter/core/constants/color.dart';
import 'package:falletter/core/constants/text_style.dart';
import 'package:falletter/core/providers/signup_provider.dart';
import 'package:falletter/core/components/button/elevated_button.dart';
import 'package:falletter/core/components/button/gender_button.dart';
import 'package:falletter/core/components/header/header.dart';
import 'package:falletter/core/components/header/sign_up_indicator.dart';
import 'package:falletter/presentation/sign_up_page/view/grade_page.dart';
import 'package:material_symbols_icons/symbols.dart';

class GenderPage extends ConsumerWidget {
  const GenderPage({super.key});

  void _selectGender(WidgetRef ref, String value) {
    ref.read(signUpProvider.notifier).setGender(value);
  }

  void _goToNextStep(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const GradePage()),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedGender = ref.watch(signUpProvider).gender;

    return Scaffold(
      body: Column(
        children: [
          const SafeArea(
            child: Header(
              showBackButton: true,
              rightWidget: SignUpIndicator(),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('성별을 선택해주세요.', style: FalletterTextStyle.title2),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: GenderButton(
                          label: '남성',
                          icon: Symbols.man,
                          iconColor: FalletterColor.blueGradient[0],
                          isSelected: selectedGender == 'MALE',
                          onTap: () => _selectGender(ref, 'MALE'),
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: GenderButton(
                          label: '여성',
                          icon: Symbols.woman,
                          iconColor: FalletterColor.pinkGradient[0],
                          isSelected: selectedGender == 'FEMALE',
                          onTap: () => _selectGender(ref, 'FEMALE'),
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  CustomElevatedButton(
                    width: double.infinity,
                    onPressed: selectedGender != null
                        ? () => _goToNextStep(context)
                        : null,
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
