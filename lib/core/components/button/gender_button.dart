import 'package:falletter/core/constants/color.dart';
import 'package:falletter/core/constants/text_style.dart';
import 'package:flutter/material.dart';

class GenderButton extends StatelessWidget {
  final String label;
  final IconData? icon;
  final Widget? iconWidget;
  final Color iconColor;
  final bool isSelected;
  final VoidCallback onTap;

  const GenderButton({
    super.key,
    required this.label,
    this.icon,
    this.iconWidget,
    required this.iconColor,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: FalletterColor.middleBlack,
          borderRadius: BorderRadius.circular(8),
          border: isSelected
              ? Border.all(color: FalletterColor.white, width: 2)
              : null,
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 30),
              child: SizedBox(
                width: 100,
                height: 100,
                child: iconWidget ?? Icon(icon, color: iconColor, size: 100),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(30),
              child: Text(
                label,
                style: FalletterTextStyle.title2,
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}