import 'package:falletter/core/constants/color.dart';
import 'package:falletter/core/constants/text_style.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:falletter/core/components/flexible_icon.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final void Function(int) onTap;

  const CustomBottomNavigationBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  static const _icons = [
    Symbols.home,
    Symbols.mail,
    Symbols.brick,
    Symbols.notifications,
    Symbols.person,
  ];

  static const _labels = ['홈', '레터', '답변', '알림', '마이페이지'];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10, bottom: 26),
      child: Container(
        decoration: const BoxDecoration(
          color: FalletterColor.black,
          border: Border(
            top: BorderSide(color: FalletterColor.gray900, width: 0.5),
          ),
        ),
        child: SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(_icons.length, (index) {
                final isSelected = currentIndex == index;
                final gradient = const LinearGradient(
                  colors: FalletterColor.blueGradient,
                );

                return Expanded(
                  child: InkWell(
                    onTap: () => onTap(index),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        isSelected
                            ? FlexibleIcon(
                              icon: _icons[index],
                              gradient: gradient,
                              fill: 1,
                            )
                            : Icon(
                              _icons[index],
                              color: FalletterColor.gray700,
                              size: null,
                              fill: 1,
                            ),
                        isSelected
                            ? ShaderMask(
                              shaderCallback:
                                  (bounds) => gradient.createShader(bounds),
                              child: Text(
                                _labels[index],
                                style: FalletterTextStyle.body3.copyWith(
                                  color: Colors.white,
                                ),
                              ),
                            )
                            : Text(
                              _labels[index],
                              style: FalletterTextStyle.body3.copyWith(
                                color: FalletterColor.gray700,
                              ),
                            ),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}
