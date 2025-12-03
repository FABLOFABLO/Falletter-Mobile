import 'package:falletter/core/components/header/header.dart';
import 'package:falletter/core/constants/color.dart';
import 'package:falletter/core/constants/text_style.dart';
import 'package:falletter/core/providers/item_count_provider.dart';
import 'package:falletter/core/utils/gender_format_utils.dart';
import 'package:falletter/models/brick_history_model.dart';
import 'package:falletter/presentation/my_page/components/brick_history_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

List<BrickHistoryResponseModel> _groupHistoryByQuestion(
  List<BrickHistoryResponseModel> historyList,
) {
  final nonQuestionItems =
      historyList.where((item) => item.type != 'QUESTION').toList();

  final questionItems =
      historyList.where((item) => item.type == 'QUESTION').toList();

  final Map<String, List<BrickHistoryResponseModel>> grouped = {};

  for (var item in questionItems) {
    final key = '${item.questionId}_${item.writerUserId}';

    if (!grouped.containsKey(key)) {
      grouped[key] = [];
    }
    grouped[key]!.add(item);
  }

  final List<BrickHistoryResponseModel> groupedItems = [];

  grouped.forEach((key, items) {
    if (items.isEmpty) return;

    final totalAmount = items.fold<int>(0, (sum, item) => sum + item.amount);

    items.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    final latestItem = items.first;

    groupedItems.add(latestItem.copyWith(amount: totalAmount));
  });

  final result = [...nonQuestionItems, ...groupedItems];

  result.sort((a, b) => b.createdAt.compareTo(a.createdAt));

  return result;
}

String _getBoxTitle(BrickHistoryResponseModel item) {
  if (item.amount > 0) {
    if (item.type == 'ATTENDANCE') {
      return '출석 보상';
    }
    return item.description;
  }

  if (item.amount < 0) {
    if (item.type == 'QUESTION') {
      return genderFormat(
        item.schoolNumber as String,
        item.gender as String,
      );
    }
    return item.description;
  }

  return item.description;
}

class UsedBrickView extends ConsumerWidget {
  const UsedBrickView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final historyAsync = ref.watch(brickHistoryProvider);

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Header(showBackButton: true),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Text(
                '브릭 사용 내역',
                style: FalletterTextStyle.title2,
              ),
            ),
            Expanded(
              child: historyAsync.when(
                data: (historyList) {
                  if (historyList.isEmpty) {
                    return const Center(
                      child: Text(
                        "브릭 사용 내역이 없습니다.",
                        style: TextStyle(color: FalletterColor.white),
                      ),
                    );
                  }

                  final groupedHistory = _groupHistoryByQuestion(historyList);

                  return ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: groupedHistory.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final item = groupedHistory[index];
                      return BrickHistoryBox(
                        title: _getBoxTitle(item),
                        question: item.question,
                        createdAt: item.createdAt,
                        amount: item.amount,
                      );
                    },
                  );
                },
                loading: () {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: FalletterColor.white,
                    ),
                  );
                },
                error: (error, stackTrace) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "브릭 사용 내역을 불러오지 못했습니다.",
                          style: TextStyle(color: FalletterColor.white),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          error.toString(),
                          style: const TextStyle(
                            color: Colors.red,
                            fontSize: 12,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () {
                            ref.invalidate(brickHistoryProvider);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: FalletterColor.gray700,
                          ),
                          child: const Text(
                            '다시 시도',
                            style: TextStyle(color: FalletterColor.white),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
