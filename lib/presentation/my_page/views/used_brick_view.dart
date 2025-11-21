import 'package:falletter/core/components/header/header.dart';
import 'package:falletter/core/constants/text_style.dart';
import 'package:falletter/core/utils/gender_format_utils.dart';
import 'package:falletter/presentation/my_page/components/brick_history_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BrickHistoryResponseModel {
  final String description;
  final int amount;
  final String type;
  final String? question;
  final String gender;
  final String schoolNumber;
  final DateTime createdAt;

  BrickHistoryResponseModel({
    required this.description,
    required this.amount,
    required this.type,
    this.question,
    required this.gender,
    required this.schoolNumber,
    required this.createdAt,
  });
}

String _getBoxTitle(BrickHistoryResponseModel item) {
  if (item.amount > 0) {
    return item.type == 'REWARD' ? '출석체크 보상' : '브릭 획득 (${item.description})';
  } else if (item.amount < 0) {
    switch (item.type) {
      case 'QUESTION':
        return genderFormat(item.schoolNumber, item.gender);
      case 'HINT':
        return '힌트 사용';
      default:
        return '브릭 사용 (${item.description})';
    }
  }
  return item.description;
}

final List<BrickHistoryResponseModel> dummyHistoryList = [
  BrickHistoryResponseModel(
    description: "질문 응답", amount: -2, type: 'QUESTION',
    question: "웃는게 가장 예쁜 사람은?", gender: 'F', schoolNumber: '201',
    createdAt: DateTime(2025, 3, 12, 12, 0),
  ),
  BrickHistoryResponseModel(
    description: "질문 응답", amount: -1, type: 'QUESTION',
    question: "웃는게 가장 예쁜 사람은?", gender: 'F', schoolNumber: '201',
    createdAt: DateTime(2025, 3, 12, 12, 0),
  ),
  BrickHistoryResponseModel(
    description: "출석 보상", amount: 3, type: 'REWARD',
    question: null, gender: 'U', schoolNumber: '',
    createdAt: DateTime(2025, 3, 12, 12, 0),
  ),
];

class UsedBrickView extends ConsumerWidget {
  const UsedBrickView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final historyList = dummyHistoryList;

    Widget itemBuilder(BuildContext context, int index) {
      final item = historyList[index];

      return BrickHistoryBox(
        title: _getBoxTitle(item),
        question: item.question,
        createdAt: item.createdAt,
        amount: item.amount,
      );
    }

    Widget separatorBuilder(BuildContext context, int index) {
      return const SizedBox(height: 12);
    }

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
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemBuilder: itemBuilder,
                separatorBuilder: separatorBuilder,
                itemCount: historyList.length,
              ),
            ),
          ],
        ),
      ),
    );
  }
}