import 'package:falletter/core/constants/color.dart';
import 'package:falletter/core/constants/text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ItemBox extends ConsumerWidget {
  final Widget item;
  final String itemKey;
  final int count;

  const ItemBox({
    super.key,
    required this.item,
    required this.itemKey,
    required this.count,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      width: double.infinity,
      height: 68,
      decoration: BoxDecoration(
        color: FalletterColor.middleBlack,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            item,
            Text(
              '$count개',
              style: FalletterTextStyle.body1,
            ),
          ],
        ),
      ),
    );
  }
}