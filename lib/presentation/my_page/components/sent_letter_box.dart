import 'package:falletter/core/constants/color.dart';
import 'package:falletter/core/constants/text_style.dart';
import 'package:falletter/core/utils/sent_time_utils.dart';
import 'package:falletter/presentation/my_page/components/letter_box.dart';
import 'package:flutter/material.dart';

class SentLetterBox extends StatelessWidget {
  final DateTime? sentAt;
  final String recipientInfo;
  final bool isDelivered;
  const SentLetterBox({
    super.key,
    this.sentAt,
    required this.recipientInfo,
    this.isDelivered = true,
  });

  @override
  Widget build(BuildContext context) {
    final String recipientText = '$recipientInfo에게';
    final String time = isDelivered
        ? formatSentTime(sentAt)
        : '전송중...';

    return ReusableLetterBox(
      children: [
        Text(
          time,
          style: FalletterTextStyle.body4.copyWith(
            color: FalletterColor.gray400,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          recipientText,
          style: FalletterTextStyle.subTitle2,
        ),
      ],
    );
  }
}