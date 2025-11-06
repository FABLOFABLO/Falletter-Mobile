import 'dart:async';
import 'package:falletter/core/providers/signin_provider.dart';
import 'package:falletter/presentation/main_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:falletter/core/components/button/elevated_button.dart';
import 'package:falletter/core/components/icon/field_icon.dart';
import 'package:falletter/core/components/text_form_field/text_form_field.dart';
import 'package:falletter/core/constants/color.dart';
import 'package:falletter/core/constants/text_style.dart';
import 'package:falletter/presentation/sign_up_page/view/gender_page.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _pwController = TextEditingController();

  bool isButtonEnabled = false;
  bool _obscureText = true;

  @override
  void initState() {
    super.initState();
    _emailController.addListener(_updateButtonState);
    _pwController.addListener(_updateButtonState);

    Future.microtask(() {
      ref.listen<AsyncValue<Map<String, dynamic>?>>(
        signInStateProvider,
            (previous, next) {
          next.when(
            data: (data) {
              if (data != null && data['access_token'] != null) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const MainApp()),
                );
              }
            },
            error: (error, stack) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('로그인 실패: ${error.toString()}')),
              );
            },
            loading: () {},
          );
        },
      );
    });
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

  Future<void> _login() async {
    final rawEmail = _emailController.text.trim();
    final email = rawEmail.contains('@')
        ? rawEmail
        : '$rawEmail@dsm.hs.kr';
    final password = _pwController.text.trim();

    await ref.read(signInStateProvider.notifier).signIn(
      email: email,
      password: password,
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
    final signInState = ref.watch(signInStateProvider);

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

    final isLoading = signInState.isLoading;

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
                      Text('로그인하고\n팔레터 사용하기', style: FalletterTextStyle.title2),
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
                          child: Text(
                            '회원가입',
                            style: FalletterTextStyle.body3,
                          ),
                        ),
                      ],
                    ),
                  ),
                  CustomElevatedButton(
                    width: double.infinity,
                    onPressed: isButtonEnabled && !isLoading ? _login : null,
                    child: isLoading
                        ? const CircularProgressIndicator(
                      color: Colors.white,
                    )
                        : const Text('로그인하기'),
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
