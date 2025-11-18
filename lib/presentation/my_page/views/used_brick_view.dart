/*
import 'package:falletter/core/components/header/header.dart';
import 'package:falletter/core/constants/text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UsedBrickView extends ConsumerWidget {
  const UsedBrickView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

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
            Expanded(child: ListView.separated(itemBuilder: itemBuilder, separatorBuilder: separatorBuilder, itemCount: itemCount))
          ],
        ),
      ),
    );
  }
}*/

import 'package:falletter/core/components/header/header.dart';
import 'package:falletter/core/constants/text_style.dart';
import 'package:falletter/presentation/my_page/components/brick_history_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// UsedBrickView 클래스 외부에 더미 데이터 모델 정의
class BrickHistoryItem {
  final String title;
  final String? question;
  final DateTime createdAt;
  final int amount;

  BrickHistoryItem({
    required this.title,
    this.question,
    required this.createdAt,
    required this.amount,
  });
}

final List<BrickHistoryItem> _dummyHistory = [
  BrickHistoryItem(
    title: '2학년 여학생의 선택',
    question: '웃는 게 가장 예쁜 사람은?',
    createdAt: DateTime(2025, 3, 12, 12, 0),
    amount: -2,
  ),
  BrickHistoryItem(
    title: '2학년 여학생의 선택',
    question: '웃는 게 가장 예쁜 사람은?',
    createdAt: DateTime(2025, 3, 12, 12, 0),
    amount: -1,
  ),
  BrickHistoryItem(
    title: '출석체크 보상',
    question: null,
    createdAt: DateTime(2025, 3, 12, 12, 0),
    amount: 3,
  ),
  // 실제로는 API를 통해 데이터를 받아와 여기에 사용해야 합니다.
];

class UsedBrickView extends ConsumerWidget {
  const UsedBrickView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 실제 구현 시, 이 부분을 API 호출 및 Riverpod 상태 감시로 대체해야 합니다.
    final historyList = _dummyHistory;

    Widget itemBuilder(BuildContext context, int index) {
      final item = historyList[index];
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: BrickHistoryBox(
          title: item.title,
          question: item.question,
          createdAt: item.createdAt,
          amount: item.amount,
        ),
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
              padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
              child: Text(
                '브릭 사용 내역',
                style: FalletterTextStyle.title2,
              ),
            ),
            Expanded(
              child: ListView.separated(
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