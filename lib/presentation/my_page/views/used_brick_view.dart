import 'package:falletter/core/components/header/header.dart';
import 'package:falletter/core/constants/text_style.dart';
import 'package:flutter/material.dart';

class UsedBrickView extends StatelessWidget {
  const UsedBrickView({super.key});

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
                '브릭 사용 내역',
                style: FalletterTextStyle.title2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
