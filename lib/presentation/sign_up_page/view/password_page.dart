import 'package:falletter/core/components/button/elevated_button.dart';
import 'package:falletter/core/components/header/header.dart';
import 'package:falletter/core/components/header/sign_up_indicator.dart';
import 'package:falletter/core/components/text_form_field/text_form_field.dart';
import 'package:falletter/core/constants/color.dart';
import 'package:falletter/core/constants/text_style.dart';
import 'package:flutter/material.dart';
import 'package:falletter/core/components/icon/field_icon.dart';

class PasswordPage extends StatefulWidget {
  const PasswordPage({super.key});

  @override
  State<PasswordPage> createState() => _PasswordPageState();
}

class _PasswordPageState extends State<PasswordPage> {
  final TextEditingController _pwController = TextEditingController();
  bool isPasswordValid = false;
  bool _obscureText = true;

  void _goToNextStep() {
    SignUpFlow.nextStep();
    print('회원가입 완료 버튼 눌림');
  }

  @override
  void initState() {
    super.initState();
    SignUpFlow.currentStep = 5;
    _pwController.addListener(_onPasswordChanged);
  }

  void _onPasswordChanged() {
    final input = _pwController.text.trim();
    setState(() {
      /// TODO: 비밀번호 유효성 검사
      isPasswordValid = true;
    });
  }

  @override
  void dispose() {
    _pwController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SafeArea(
            child: Header(showBackButton: true, rightWidget: SignUpIndicator()),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text('비밀번호를 입력해주세요.', style: FalletterTextStyle.title2),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: CustomTextFormField(
              controller: _pwController,
              obscureText: _obscureText,
              maxLines: 1,
              decoration: InputDecoration(
                hintText: '비밀번호를 입력해주세요',
                hintStyle: FalletterTextStyle.placeholder.copyWith(
                  color: FalletterColor.gray700,
                ),
                suffixIcon:
                    _pwController.text.isNotEmpty
                        ? (_obscureText
                            ? FieldIcons.hidePwIcon(
                              onPressed: () {
                                setState(() {
                                  _obscureText = false;
                                });
                              },
                            )
                            : FieldIcons.showPwIcon(
                              onPressed: () {
                                setState(() {
                                  _obscureText = true;
                                });
                              },
                            ))
                        : null,
              ),
            ),
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
            child: CustomElevatedButton(
              width: double.infinity,
              onPressed: isPasswordValid ? _goToNextStep : null,
              child: const Text('회원가입'),
            ),
          ),
        ],
      ),
    );
  }
}
