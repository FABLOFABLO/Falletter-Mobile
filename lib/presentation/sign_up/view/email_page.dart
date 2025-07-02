import 'package:falletter/core/components/button/elevated_button.dart';
import 'package:falletter/core/components/header/header.dart';
import 'package:falletter/core/components/header/sign_up_indicator.dart';
import 'package:falletter/core/components/text_form_field/text_form_field.dart';
import 'package:falletter/core/constants/color.dart';
import 'package:falletter/core/constants/text_style.dart';
import 'package:falletter/presentation/sign_up/view/verify_page.dart';
import 'package:flutter/material.dart';
import 'package:falletter/core/components/icon/field_icon.dart';

class EmailPage extends StatefulWidget {
  const EmailPage({super.key});

  @override
  State<EmailPage> createState() => _EmailPageState();
}

class _EmailPageState extends State<EmailPage> {
  final TextEditingController _emailController = TextEditingController();
  bool isButtonEnabled = false;

  void _goToNextStep() {
    SignUpFlow.nextStep();
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const VerifyPage()),
    );
  }

  @override
  void initState() {
    super.initState();
    SignUpFlow.currentStep = 3;
    _emailController.addListener(_onEmailChanged);
  }

  void _onEmailChanged() {
    final input = _emailController.text.trim();

    final isValid = RegExp(r'^[a-zA-Z0-9._]+$').hasMatch(input);

    setState(() {
      isButtonEnabled = isValid && input.isNotEmpty;
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _sendVerificationCode() {
    // UI만 구현하므로 실제 전송 로직은 제거
    _goToNextStep();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            child: Text('이메일을 입력해주세요.', style: FalletterTextStyle.title2),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: CustomTextFormField(
              controller: _emailController,
              decoration: InputDecoration(
                hintText: '이메일을 입력해주세요',
                hintStyle: FalletterTextStyle.placeholder.copyWith(
                  color: FalletterColor.gray700,
                ),
                suffixIcon: FieldIcons.emailText(),
              ),
            ),
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
            child: CustomElevatedButton(
              width: double.infinity,
              onPressed: isButtonEnabled ? _sendVerificationCode : null,
              child: const Text('인증번호 전송'),
            ),
          ),
        ],
      ),
    );
  }
}