import 'package:falletter/core/components/header/header.dart';
import 'package:falletter/core/constants/text_style.dart';
import 'package:flutter/material.dart';

class ThemeView extends StatelessWidget {
  const ThemeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Header(
              showBackButton: true,
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Text(
                '테마 설정',
                style: FalletterTextStyle.title2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
