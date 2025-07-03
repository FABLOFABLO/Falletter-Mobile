import 'package:flutter/material.dart';
import 'package:falletter/core/constants/color.dart';
import 'package:falletter/core/constants/text_style.dart';
import 'package:falletter/core/components/button/delete_comment_button.dart';

class CommentItem extends StatelessWidget {
  final String nickname;
  final String time;
  final String text;
  final bool isAuthor;
  final VoidCallback? onDelete;

  const CommentItem({
    super.key,
    required this.nickname,
    required this.time,
    required this.text,
    required this.isAuthor,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: FalletterColor.middleBlack,
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.all(20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(nickname, style: FalletterTextStyle.body4.copyWith(color: FalletterColor.gray200)),
                    const SizedBox(width: 8),
                    Text(time, style: FalletterTextStyle.body4.copyWith(color: FalletterColor.gray200)),
                  ],
                ),
                const SizedBox(height: 8),
                Text(text, style: FalletterTextStyle.body4.copyWith(color: FalletterColor.white)),
              ],
            ),
          ),
          if (isAuthor && onDelete != null)
            DeleteCommentButton(onPressed: onDelete!),
        ],
      ),
    );
  }
}