import 'package:falletter/core/constants/color.dart';
import 'package:falletter/core/constants/text_style.dart';
import 'package:flutter/material.dart';

class ReusableLetterBox extends StatelessWidget {
  final List<Widget> children;
  final double width;
  final double height;

  const ReusableLetterBox({
    super.key,
    required this.children,
    this.width = double.infinity,
    this.height = 76,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: FalletterColor.middleBlack,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: children,
          ),
        ),
      ),
    );
  }
}
