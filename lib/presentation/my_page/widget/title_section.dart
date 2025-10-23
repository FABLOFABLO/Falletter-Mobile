import 'package:falletter/core/constants/color.dart';
import 'package:falletter/core/constants/text_style.dart';
import 'package:falletter/presentation/my_page/components/detail_box.dart';
import 'package:flutter/material.dart';

class TitleSection extends StatelessWidget {
  final String title;
  final List<String> items;
  final List<VoidCallback> onTaps;

  const TitleSection({
    super.key,
    required this.title,
    required this.items,
    required this.onTaps,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 32),
        Text(
          title,
          style: FalletterTextStyle.button.copyWith(
            color: FalletterColor.gray400,
          ),
        ),

        const SizedBox(height: 12),

        for (int i = 0; i < items.length; i++) ...[
          DetailBox(
            onTap: onTaps[i],
            child: Text(items[i]),
          ),
          if (i != items.length - 1) const SizedBox(height: 12),
        ],
      ],
    );
  }
}
