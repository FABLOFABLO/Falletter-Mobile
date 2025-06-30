import 'dart:async';
import 'package:falletter/core/components/button/elevated_button.dart';
import 'package:falletter/core/components/text_form_field/text_form_field.dart';
import 'package:falletter/core/constants/text_style.dart';
import 'package:falletter/core/constants/color.dart';
import 'package:falletter/presentation/sign_up/view/password_page.dart';
import 'package:falletter/core/components/header/header.dart';
import 'package:falletter/core/components/header/sign_up_indicator.dart';
import 'package:flutter/material.dart';

class VerifyPage extends StatefulWidget {
  const VerifyPage({super.key});

  @override
  State<VerifyPage> createState() => _VerifyPageState();
}

class _VerifyPageState extends State<VerifyPage> {
  final TextEditingController _verifyController = TextEditingController();
  Timer? _timer;
  int _secondsRemaining = 300;
  bool isButtonEnabled = false;

  @override
  void initState() {
    super.initState();
    _startTimer();
    _verifyController.addListener(_onCodeChanged);
  }

  @override
  void dispose() {
    _timer?.cancel();
    _verifyController.dispose();
    super.dispose();
  }

  void _onCodeChanged() {
    // TODO: 인증번호 유효성 조건이 확정되면 아래 조건 수정
    setState(() {
      isButtonEnabled = _verifyController.text.trim().isNotEmpty && _secondsRemaining > 0;
    });
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining > 0) {
        setState(() {
          _secondsRemaining--;
        });
      } else {
        setState(() {
          isButtonEnabled = false;
        });
        _timer?.cancel();
      }
    });
  }

  String _formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  void _verifyCode() {
    // TODO: 실제 인증번호 유효성 검사는 추후 구현
    SignUpFlow.nextStep();
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const PasswordPage()),
    );
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('인증번호를 입력해주세요.', style: FalletterTextStyle.title2),
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    '입력한 이메일로 전송했어요!',
                    style: FalletterTextStyle.body3.copyWith(
                      color: FalletterColor.gray400,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Stack(
              children: [
                CustomTextFormField(
                  controller: _verifyController,
                  decoration: InputDecoration(
                    hintText: '인증번호를 입력해주세요',
                    hintStyle: FalletterTextStyle.placeholder.copyWith(
                      color: FalletterColor.gray700,
                    ),
                  ),
                  keyboardType: TextInputType.number,
                ),
                Positioned(
                  right: 12,
                  top: 0,
                  bottom: 0,
                  child: Center(
                    child: Text(
                      _formatTime(_secondsRemaining),
                      style: FalletterTextStyle.body2.copyWith(
                        color: FalletterColor.error,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
            child: CustomElevatedButton(
              width: double.infinity,
              onPressed: isButtonEnabled ? _verifyCode : null,
              child: const Text('다음'),
            ),
          ),
        ],
      ),
    );
  }
}