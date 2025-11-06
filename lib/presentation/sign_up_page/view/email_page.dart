import 'package:falletter/core/components/button/elevated_button.dart';
import 'package:falletter/core/components/header/header.dart';
import 'package:falletter/core/components/header/sign_up_indicator.dart';
import 'package:falletter/core/components/text_form_field/text_form_field.dart';
import 'package:falletter/core/constants/text_style.dart';
import 'package:falletter/core/components/icon/field_icon.dart';
import 'package:falletter/services/auth_service.dart';
import 'package:falletter/presentation/sign_up_page/view/verify_page.dart';
import 'package:flutter/material.dart';

class EmailPage extends StatefulWidget {
  const EmailPage({super.key});

  @override
  State<EmailPage> createState() => _EmailPageState();
}

class _EmailPageState extends State<EmailPage> {
  final TextEditingController _emailController = TextEditingController();
  bool isButtonEnabled = false;
  bool isLoading = false;

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
    _emailController.removeListener(_onEmailChanged);
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _sendVerificationCode() async {
    final emailInput = _emailController.text.trim();
    final fullEmail = '$emailInput@dsm.hs.kr';
    final authService = AuthService();

    setState(() => isLoading = true);
    final result = await authService.sendVerificationCode(fullEmail);
    setState(() => isLoading = false);

    if (!mounted) return;

    if (result == 'OK') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => VerifyPage(email: fullEmail),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result)),
      );
    }
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
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      '이메일을 입력해주세요.',
                      style: FalletterTextStyle.title2,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: CustomTextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        suffixIcon: FieldIcons.emailText(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
            child: CustomElevatedButton(
              width: double.infinity,
              onPressed:
                  isButtonEnabled && !isLoading ? _sendVerificationCode : null,
              child:
                  isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text('인증번호 전송'),
            ),
          ),
        ],
      ),
    );
  }
}
