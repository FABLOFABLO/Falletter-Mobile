import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:falletter/core/constants/color.dart';

class Header extends StatelessWidget {
  final bool showBackButton;
  final VoidCallback? onBack;
  final Widget? rightWidget;

  const Header({
    super.key,
    this.showBackButton = true,
    this.onBack,
    this.rightWidget,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (showBackButton)
            IconButton(
              icon: Icon(Symbols.arrow_back_ios, color: FalletterColor.white),
              onPressed: onBack ?? () => Navigator.pop(context),
            ),

          const Spacer(),

          if (rightWidget != null)
            rightWidget!,
        ],
      ),
    );
  }
}