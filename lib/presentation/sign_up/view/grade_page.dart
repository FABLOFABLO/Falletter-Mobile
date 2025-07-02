import 'package:falletter/core/components/button/elevated_button.dart';
import 'package:falletter/core/components/header/header.dart';
import 'package:falletter/core/components/text_form_field/text_form_field.dart';
import 'package:falletter/core/constants/color.dart';
import 'package:falletter/core/constants/text_style.dart';
import 'package:falletter/core/components/header/sign_up_indicator.dart';
import 'package:falletter/presentation/sign_up/view/email_page.dart';
import 'package:flutter/material.dart';

class GradePage extends StatefulWidget {
  const GradePage({super.key});

  @override
  State<GradePage> createState() => _GradePageState();
}

class _GradePageState extends State<GradePage> {
  final TextEditingController _gradeController = TextEditingController();
  bool isButtonEnabled = false;

  void _goToNextStep() {
    SignUpFlow.nextStep();
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const EmailPage()),
    );
  }

  @override
  void initState() {
    super.initState();
    SignUpFlow.currentStep = 2;
    _gradeController.addListener(_onGradeChanged);
  }

  void _onGradeChanged() {
    final input = _gradeController.text.trim();
    final parts = input.split(' ');

    setState(() {
      isButtonEnabled =
          parts.length >= 2 && parts[0].isNotEmpty && parts[1].isNotEmpty;
    });
  }

  @override
  void dispose() {
    _gradeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SafeArea(
            child: Header(
              showBackButton: true,
              rightWidget: SignUpIndicator(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text('학번을 입력해주세요.', style: FalletterTextStyle.title2),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: CustomTextFormField(
              controller: _gradeController,
              decoration: InputDecoration(
                hintText: '학번을 입력해주세요.',
                hintStyle: FalletterTextStyle.placeholder.copyWith(
                  color: FalletterColor.gray700,
                ),
              ),
            ),
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
            child: CustomElevatedButton(
              width: double.infinity,
              onPressed: isButtonEnabled ? _goToNextStep : null,
              child: const Text('다음'),
            ),
          ),
        ],
      ),
    );
  }
}