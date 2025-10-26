import 'package:falletter/core/constants/color.dart';
import 'package:falletter/core/constants/text_style.dart';
import 'package:falletter/core/providers/item_count_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ItemBox extends ConsumerWidget {
  final Widget item;
  final String itemKey;

  const ItemBox({
    super.key,
    required this.item,
    required this.itemKey,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final itemCountMap = ref.watch(itemCountProvider);
    final count = itemCountMap[itemKey] ?? 0;

    return Container(
      width: double.infinity,
      height: 68,
      decoration: BoxDecoration(
        color: FalletterColor.middleBlack,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
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