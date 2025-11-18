import 'package:falletter/core/constants/color.dart';
import 'package:falletter/core/constants/text_style.dart';
import 'package:falletter/presentation/my_page/components/reusable_box.dart';
import 'package:flutter/material.dart';

class NoticeBox extends StatelessWidget {
  final String title;
  final String subtitle;
  final String time;
  final bool isClicked;
  final VoidCallback? onTap;

  const NoticeBox({
    super.key,
    required this.title,
    required this.subtitle,
    required this.time,
    this.isClicked = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final titleColor =
        isClicked ? FalletterColor.gray400 : FalletterColor.white;

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: onTap,
      child: ReusableLetterBox(
        height: 92,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: FalletterTextStyle.subTitle2.copyWith(
                    color: titleColor,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: FalletterTextStyle.body4.copyWith(
                  color: FalletterColor.gray400,
                ),
              ),
              const SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    time,
                    style: FalletterTextStyle.body4.copyWith(
                      color: FalletterColor.gray400,
                    ),
                  ),
                  Text(
                      '자세히 보기',
                      style: FalletterTextStyle.body4,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
