import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:falletter/core/components/button/elevated_button.dart';
import 'package:falletter/core/components/header/header.dart';
import 'package:falletter/core/components/header/sign_up_indicator.dart';
import 'package:falletter/core/components/text_form_field/text_form_field.dart';
import 'package:falletter/core/constants/color.dart';
import 'package:falletter/core/constants/text_style.dart';
import 'package:falletter/core/components/icon/field_icon.dart';
import 'package:falletter/presentation/main_app.dart';

class PasswordPage extends StatefulWidget {
  const PasswordPage({super.key});

  @override
  State<PasswordPage> createState() => _PasswordPageState();
}

class _PasswordPageState extends State<PasswordPage> {
  final TextEditingController _pwController = TextEditingController();
  bool isPasswordValid = false;
  bool _obscureText = true;

  @override
  void initState() {
    super.initState();
    _pwController.addListener(_onPasswordChanged);
  }

  void _onPasswordChanged() {
    setState(() {
      // TODO: 실제 비밀번호 유효성 검사
      isPasswordValid = _pwController.text.isNotEmpty;
    });
  }

  void _showSuccessDialog() async {
    await showGeneralDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(0.8),
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (dialogContext, __, ___) {
        return Scaffold(
          backgroundColor: Colors.transparent,
          body: Stack(
            alignment: Alignment.center,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(height: 150),
                  Text('가입 완료!', style: FalletterTextStyle.subTitle2),
                  const SizedBox(height: 8),
                  Text('팔레터를 사용해보세요', style: FalletterTextStyle.title2),
                ],
              ),
              Center(
                child: Lottie.asset(
                  'assets/lottie/congratulation.json',
                  width: 400,
                  height: 400,
                  repeat: false,
                  onLoaded: (composition) async {
                    await Future.delayed(composition.duration);

                    if (mounted) {
                      Navigator.pop(dialogContext);
                    }
                  },
                ),
              ),
            ],
          ),
        );
      },
    );

    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const MainApp()),
      );
    }
  }

  void _goToNextStep() {
    _showSuccessDialog();
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
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
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
                                  onPressed:
                                      () => setState(() {
                                        _obscureText = false;
                                      }),
                                )
                                : FieldIcons.showPwIcon(
                                  onPressed:
                                      () => setState(() {
                                        _obscureText = true;
                                      }),
                                ))
                            : null,
                  ),
                ),
              ),
            ),
          ),
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
