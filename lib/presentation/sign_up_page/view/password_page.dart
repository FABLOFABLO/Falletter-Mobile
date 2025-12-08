import 'package:falletter/initial_page.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:falletter/core/components/button/elevated_button.dart';
import 'package:falletter/core/components/header/header.dart';
import 'package:falletter/core/components/header/sign_up_indicator.dart';
import 'package:falletter/core/components/icon/field_icon.dart';
import 'package:falletter/core/components/text_form_field/text_form_field.dart';
import 'package:falletter/core/constants/color.dart';
import 'package:falletter/core/constants/text_style.dart';
import 'package:falletter/core/providers/signup_provider.dart';
import 'package:falletter/core/providers/theme_provider.dart';
import 'package:falletter/core/theme/theme_colors.dart';
import 'package:falletter/services/auth_service.dart';

class PasswordPage extends ConsumerStatefulWidget {
  const PasswordPage({super.key});

  @override
  ConsumerState<PasswordPage> createState() => _PasswordPageState();
}

class _PasswordPageState extends ConsumerState<PasswordPage> {
  final TextEditingController _pwController = TextEditingController();
  bool _isLoading = false;
  bool _obscureText = true;
  bool isPasswordValid = false;

  @override
  void initState() {
    super.initState();
    SignUpFlow.currentStep = 5;
    _pwController.addListener(_validatePassword);
  }

  @override
  void dispose() {
    _pwController.dispose();
    super.dispose();
  }

  void _validatePassword() {
    setState(() {
      isPasswordValid = _pwController.text.isNotEmpty;
    });
  }

  Future<void> _signUp(ThemeColors themeColors) async {
    final signUpState = ref.read(signUpProvider);
    final authService = AuthService();

    setState(() => _isLoading = true);

    try {
      final result = await authService.signUp(
        email: signUpState.email!,
        password: _pwController.text.trim(),
        schoolNumber: signUpState.schoolNumber!,
        name: signUpState.name ?? '유저',
        gender: signUpState.gender!,
      );

      if (!mounted) return;

      if (result == 'OK') {
        await _showSuccessDialog(themeColors);
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(result)));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('회원가입 실패: $e')));
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _showSuccessDialog(ThemeColors themeColors) async {
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
                  themeColors.signupLottie, // 테마별 Lottie 적용
                  width: 400,
                  height: 400,
                  repeat: false,
                  onLoaded: (composition) async {
                    await Future.delayed(const Duration(seconds: 2));
                    if (dialogContext.mounted) {
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
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const PostLoginPage()),
            (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final selectedTheme = ref.watch(themeProvider);
    final themeColors = appThemeColors[selectedTheme]!;

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
                    suffixIcon: _pwController.text.isNotEmpty
                        ? (_obscureText
                        ? FieldIcons.hidePwIcon(
                      onPressed: () => setState(() {
                        _obscureText = false;
                      }),
                    )
                        : FieldIcons.showPwIcon(
                      onPressed: () => setState(() {
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
              onPressed: isPasswordValid && !_isLoading
                  ? () => _signUp(themeColors)
                  : null,
              child: _isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text('회원가입'),
            ),
          ),
        ],
      ),
    );
  }
}