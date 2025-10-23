import 'package:falletter/core/constants/color.dart';
import 'package:falletter/core/constants/text_style.dart';
import 'package:flutter/material.dart';

class DetailBox extends StatelessWidget {
  final Widget child;
  final void Function() onTap;

  const DetailBox({
    super.key,
    required this.child,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: FalletterColor.middleBlack,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: double.infinity,
          height: 60,
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.all(20),
          child: DefaultTextStyle(
            style: FalletterTextStyle.button.copyWith(
              color: FalletterColor.white,
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}
