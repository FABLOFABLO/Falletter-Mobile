import 'package:falletter/core/constants/color.dart';
import 'package:falletter/core/constants/text_style.dart';
import 'package:flutter/material.dart';

class SignUpFlow {
  static const totalSteps = 5;
  static int currentStep = 1;

  static void nextStep() {
    if (currentStep < totalSteps) currentStep++;
  }
}

class SignUpIndicator extends StatelessWidget {
  const SignUpIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text('${SignUpFlow.currentStep}', style: FalletterTextStyle.body1),
        Text('/${SignUpFlow.totalSteps}', style: FalletterTextStyle.body1.copyWith(
          color: FalletterColor.gray500,
        )),
      ],
    );
  }
}