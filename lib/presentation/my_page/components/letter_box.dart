import 'package:falletter/core/constants/color.dart';
import 'package:falletter/core/constants/text_style.dart';
import 'package:falletter/core/utils/sent_time_utils.dart';
import 'package:flutter/material.dart';

class LetterBox extends StatelessWidget {
  final DateTime? sentAt;
  final String recipientInfo;

  const LetterBox({
    super.key,
    this.sentAt,
    required this.recipientInfo,
  });

  @override
  Widget build(BuildContext context) {
    final String recipientText = '$recipientInfo에게';
    final String time = formatSentTime(sentAt);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        width: double.infinity,
        height: 76,
        decoration: BoxDecoration(
          color: FalletterColor.middleBlack,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                time,
                style: FalletterTextStyle.body4.copyWith(
                  color: FalletterColor.gray400,
                ),
              ),
              const SizedBox(
                height: 4,
              ),
              Text(
                recipientText,
                style: FalletterTextStyle.subTitle2,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
