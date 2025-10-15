import 'package:flutter/material.dart';
import 'package:falletter/core/components/button/elevated_button.dart';
import 'package:falletter/core/components/icon/field_icon.dart';
import 'package:falletter/core/components/text_form_field/text_form_field.dart';
import 'package:falletter/core/constants/color.dart';
import 'package:falletter/core/constants/text_style.dart';
import 'package:falletter/presentation/sign_up_page/view/gender_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _pwController = TextEditingController();

  bool isButtonEnabled = false;
  bool _obscureText = true;

  @override
  void initState() {
    super.initState();
    _emailController.addListener(_updateButtonState);
    _pwController.addListener(_updateButtonState);
  }

  void _updateButtonState() {
    final emailInput = _emailController.text.trim();
    final pwInput = _pwController.text.trim();

    final isIdValid = RegExp(r'^[a-zA-Z0-9._]+$').hasMatch(emailInput);
    final isPwValid = pwInput.isNotEmpty;

    final newButtonState = isIdValid && emailInput.isNotEmpty && isPwValid;

    if (isButtonEnabled != newButtonState) {
      setState(() {
        isButtonEnabled = newButtonState;
      });
    }
  }

  void _login() {
    // TODO: 로그인 처리 코드
    debugPrint(
      '로그인 버튼 클릭: 이메일=${_emailController.text}, 비밀번호=${_pwController.text}',
    );
  }

  @override
  void dispose() {
    _emailController.removeListener(_updateButtonState);
    _pwController.removeListener(_updateButtonState);

    _emailController.dispose();
    _pwController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget? suffixIcon;
    if (_pwController.text.isNotEmpty) {
      if (_obscureText) {
        suffixIcon = FieldIcons.hidePwIcon(
          onPressed: () => setState(() => _obscureText = false),
        );
      } else {
        suffixIcon = FieldIcons.showPwIcon(
          onPressed: () => setState(() => _obscureText = true),
        );
      }
    }

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 32),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('로그인하고\n팔레터 사용하기',
                          style: FalletterTextStyle.title2),
                      const SizedBox(height: 40),
                      CustomTextFormField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          labelText: '이메일',
                          labelStyle: FalletterTextStyle.label,
                          hintText: '이메일을 입력해주세요',
                          hintStyle: FalletterTextStyle.placeholder.copyWith(
                            color: FalletterColor.gray700,
                          ),
                          suffixIcon: FieldIcons.emailText(),
                        ),
                      ),
                      const SizedBox(height: 32),
                      CustomTextFormField(
                        controller: _pwController,
                        obscureText: _obscureText,
                        maxLines: 1,
                        decoration: InputDecoration(
                          labelText: '비밀번호',
                          labelStyle: FalletterTextStyle.label,
                          hintText: '비밀번호를 입력해주세요',
                          hintStyle: FalletterTextStyle.placeholder.copyWith(
                            color: FalletterColor.gray700,
                          ),
                          suffixIcon: suffixIcon,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Column(
                children: [
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
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const GenderPage(),
                              ),
                            );
                          },
                          child: Text('회원가입',
                              style: FalletterTextStyle.body3),
                        ),
                      ],
                    ),
                  ),
                  CustomElevatedButton(
                    width: double.infinity,
                    onPressed: isButtonEnabled ? _login : null,
                    child: const Text('로그인하기'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
