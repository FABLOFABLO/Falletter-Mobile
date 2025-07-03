import 'package:falletter/core/constants/color.dart';
import 'package:falletter/core/constants/text_style.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

class PostHeaderCard extends StatelessWidget {
  final String nickname;
  final String time;
  final String title;
  final String content;
  final VoidCallback onMorePressed;

  const PostHeaderCard({
    super.key,
    required this.nickname,
    required this.time,
    required this.title,
    required this.content,
    required this.onMorePressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: FalletterColor.middleBlack,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text(nickname, style: FalletterTextStyle.body3.copyWith(color: FalletterColor.gray200)),
                    const SizedBox(width: 8),
                    Text(time, style: FalletterTextStyle.body3.copyWith(color: FalletterColor.gray200)),
                  ],
                ),
                IconButton(
                  icon: const Icon(Symbols.more_horiz, color: FalletterColor.white),
                  onPressed: onMorePressed,
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(title, style: FalletterTextStyle.subTitle2.copyWith(color: FalletterColor.white)),
            const SizedBox(height: 12),
            Text(content, style: FalletterTextStyle.body3.copyWith(color: FalletterColor.gray400)),
          ],
        ),
      ),
    );
  }
}