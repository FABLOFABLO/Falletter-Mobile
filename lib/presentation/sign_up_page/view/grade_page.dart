import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:falletter/core/components/button/elevated_button.dart';
import 'package:falletter/core/components/header/header.dart';
import 'package:falletter/core/components/header/sign_up_indicator.dart';
import 'package:falletter/core/components/text_form_field/text_form_field.dart';
import 'package:falletter/core/constants/color.dart';
import 'package:falletter/core/constants/text_style.dart';
import 'package:falletter/presentation/sign_up_page/view/email_page.dart';
import 'package:flutter/material.dart';
import 'package:falletter/core/providers/signup_provider.dart';

class GradePage extends ConsumerStatefulWidget {
  const GradePage({super.key});

  @override
  ConsumerState<GradePage> createState() => _GradePageState();
}

class _GradePageState extends ConsumerState<GradePage> {
  final TextEditingController _gradeController = TextEditingController();
  bool isButtonEnabled = false;

  @override
  void initState() {
    super.initState();
    SignUpFlow.currentStep = 2;
    _gradeController.addListener(_onTextChanged);
  }

  void _onTextChanged() {
    final input = _gradeController.text.trim();
    final parts = input.split(' ');

    setState(() {
      isButtonEnabled =
          parts.length >= 2 && parts[0].isNotEmpty && parts[1].isNotEmpty;
    });
  }

  void _goToNextStep() {
    final input = _gradeController.text.trim();
    final parts = input.split(' ');

    String schoolNumber = '';
    String name = '';

    if (parts.isNotEmpty) {
      schoolNumber = parts[0].trim();
    }
    if (parts.length > 1) {
      name = parts.sublist(1).join(' ').trim();
    }

    ref.read(signUpProvider.notifier).setSchoolNumber(schoolNumber);
    ref.read(signUpProvider.notifier).setName(name);

    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const EmailPage()),
    );
  }

  @override
  void dispose() {
    _gradeController.removeListener(_onTextChanged);
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
            child: Text(
              '학번과 이름을 함께 입력해주세요.',
              style: FalletterTextStyle.title2,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: CustomTextFormField(
              controller: _gradeController,
              maxLines: 1,
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
