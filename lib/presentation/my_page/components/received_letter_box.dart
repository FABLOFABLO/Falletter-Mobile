import 'package:falletter/core/constants/text_style.dart';
import 'package:falletter/presentation/my_page/components/reusable_box.dart';
import 'package:flutter/material.dart';

class ReceivedLetterBox extends StatelessWidget {
  final String arrivedAt;
  final String preview;

  const ReceivedLetterBox({
    super.key,
    required this.arrivedAt,
    required this.preview,
  });

  @override
  Widget build(BuildContext context) {
    return ReusableLetterBox(
      children: [
        Text(
          arrivedAt,
          style: FalletterTextStyle.subTitle2,
        ),
        const SizedBox(
          height: 4,
        ),
        Text(
          preview,
          style: FalletterTextStyle.body3,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}
